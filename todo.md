# Build Plan — RAG Chatbot RicoCapital (Revisi v2)

> Dokumen ini untuk dikonsumsi coding agent (mis. Claude Code) secara bertahap.
> Setiap task ditulis supaya bisa langsung ditempel sebagai instruksi satu task per sesi.

---

## 0. Ringkasan perubahan dari spesifikasi awal

| Komponen | Rencana awal | Rencana revisi (dokumen ini) |
|---|---|---|
| Vector store | Qdrant (service terpisah) | **Dihapus.** Embedding disimpan di kolom database (MySQL/SQLite), similarity dihitung di PHP |
| Sumber materi | PDF + video transcript + judul/deskripsi | **Hanya title + description** modul |
| Chunking | `TextChunkerService`, 300–500 token, overlap | Disederhanakan: 1 modul = 1 chunk (title + description digabung), estimasi token kasar (word count) |
| Embedding provider | Belum ditentukan | **Gemini** (`text-embedding-004` atau versi terbaru saat implementasi — cek dulu, lihat Task 1) |
| Generation provider | Anthropic Messages API | **Gemini** (`gemini-2.0-flash` atau setara — cek versi terbaru saat implementasi) |
| Rate limit | 30/hari/user, scope belum jelas | 30/hari/user, **global lintas semua course** |
| Extraction service (PDF/video/OCR) | 3 service terpisah | **Dihapus semua** — tidak ada sumber selain title+description |

---

## 1. Item yang masih terbuka (blocker)

**Task 0 — WAJIB dikerjakan lebih dulu, sebelum Task 4 (otorisasi ChatController):**

> Baca `app/Http/Controllers/API/CourseController.php` secara langsung. Cari tahu dan dokumentasikan:
> 1. Bagaimana user divalidasi berhak atas `course_id` tertentu — lewat tabel pivot enrollment (mis. `course_user`), atau lewat field level membership yang otomatis membuka semua course?
> 2. Method/scope Eloquent apa yang dipakai untuk itu (mis. `$user->courses()->find($id)` atau semacamnya).
>
> Tulis hasilnya sebagai komentar di `ChatController::ask()` sebelum lanjut Task 4, supaya pola otorisasinya konsisten dengan sistem yang sudah ada — bukan aturan baru yang mungkin bocor.

Rekomendasi lain yang masih perlu keputusanmu (default sudah saya isi, ubah kalau perlu):
- **Kuota untuk pertanyaan yang kena guardrail** (`grounded: false`, tidak sampai panggil Gemini generation): default **tetap dihitung ke kuota 30/hari**, karena tetap ada biaya embedding + query. Kalau nanti data nunjukkan banyak user "kehabisan" kuota gara-gara guardrail, gampang diubah — logikanya sudah dipisah di `RateLimitService` (lihat Task 5).

---

## 2. Struktur file revisi

```
app/
├── Observers/
│   └── CourseModuleObserver.php
├── Console/Commands/
│   └── ReindexModulesCommand.php
├── Jobs/Rag/
│   ├── ProcessModuleForRagJob.php
│   └── RemoveModuleFromRagJob.php
├── Services/Rag/
│   ├── Embedding/
│   │   └── GeminiEmbeddingService.php        // ganti EmbeddingService generik
│   ├── VectorStore/
│   │   └── DbVectorStore.php                 // ganti QdrantVectorStore, query ke tabel rag_chunks langsung
│   ├── Retrieval/RetrievalService.php
│   ├── Generation/
│   │   ├── GeminiAnswerGeneratorService.php   // ganti AnswerGeneratorService generik
│   │   └── prompts/system_prompt.txt
│   └── RateLimitService.php
├── Http/
│   ├── Controllers/API/ChatController.php
│   └── Requests/ChatRequest.php
└── Models/CourseModule.php                    // tambah rag_* ke $fillable/$casts
config/
└── rag.php
database/migrations/
├── xxxx_create_rag_chunks_table.php           // sekarang MENYIMPAN embedding, bukan cuma cermin metadata
└── xxxx_create_chat_query_logs_table.php
routes/api.php
```

Dihapus dari rencana awal: `Extraction/PdfExtractorService.php`, `Extraction/VideoTranscriberService.php`, `Extraction/OcrFallbackService.php`, `Chunking/TextChunkerService.php` (fungsinya diserap jadi method kecil di `ProcessModuleForRagJob`), `VectorStore/QdrantVectorStore.php`, `VectorStore/VectorStoreInterface.php` (opsional dipertahankan sebagai interface tipis di atas `DbVectorStore` kalau mau tetap swappable ke Qdrant nanti).

---

## 3. Skema database revisi

`rag_chunks` sekarang jadi **satu-satunya** tempat penyimpanan vektor (bukan cuma cermin lokal dari Qdrant):

```php
Schema::create('rag_chunks', function (Blueprint $table) {
    $table->id();
    $table->foreignId('module_id')->constrained('course_modules')->cascadeOnDelete();
    $table->foreignId('course_id')->constrained('courses'); // denormalisasi, buat filter cepat tanpa join
    $table->text('content');              // title + description digabung, hasil final yang di-embed
    $table->json('embedding');            // vector Gemini, disimpan sebagai array float
    $table->string('embedding_model');    // nama model, buat migrasi kalau ganti model nanti
    $table->string('content_hash');       // idempotency check
    $table->timestamps();

    $table->index('course_id');
    $table->index('module_id');
});
```

Catatan performa: similarity dihitung di PHP dengan cara load semua `rag_chunks` untuk `course_id` yang relevan (jumlahnya kecil — puluhan modul per course), lalu hitung cosine similarity satu-satu. Ini cukup untuk skala saat ini. Kalau nanti jumlah modul per course sudah ratusan-ribuan, baru pertimbangkan pindah ke ekstensi vector di database (mis. `pgvector` kalau migrasi ke Postgres) — bukan sekarang.

`chat_query_logs` — tidak berubah dari spesifikasi awal:

```php
Schema::create('chat_query_logs', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained();
    $table->foreignId('course_id')->nullable()->constrained('courses');
    $table->text('question');
    $table->boolean('grounded');
    $table->float('top_score')->nullable();
    $table->timestamps();
});
```

`config/rag.php`:

```php
return [
    'embedding_model' => env('RAG_EMBEDDING_MODEL', 'text-embedding-004'),
    'generation_model' => env('RAG_GENERATION_MODEL', 'gemini-2.0-flash'),
    'similarity_threshold' => env('RAG_SIMILARITY_THRESHOLD', 0.70),
    'top_k' => env('RAG_TOP_K', 5),
    'daily_question_limit' => env('RAG_DAILY_LIMIT', 30),
];
```

---

## 4. Urutan task untuk coding agent

Kerjakan berurutan — tiap task diasumsikan sesi terpisah, jadi tiap task menyebutkan file yang disentuh secara eksplisit.

### Task 0 — Investigasi otorisasi (lihat Bagian 1)
Blocker. Tidak menulis kode, cuma dokumentasi temuan.

### Task 1 — Cek Gemini API terkini & setup kredensial
- Cek dokumentasi resmi Gemini API (nama model embedding & generation terbaru bisa sudah berubah sejak dokumen ini ditulis — jangan asumsikan `text-embedding-004`/`gemini-2.0-flash` masih nama yang benar, verifikasi dulu).
- Tambah `GEMINI_API_KEY` ke `.env` dan `.env.example`.
- Buat `config/rag.php` (Bagian 3).

### Task 2 — Migrasi database
File: `database/migrations/xxxx_create_rag_chunks_table.php`, `xxxx_create_chat_query_logs_table.php`.
Pakai skema di Bagian 3. Pastikan jalan di SQLite (lokal) dan kompatibel MySQL (produksi) — hindari tipe kolom spesifik-driver.

### Task 3 — Pipeline ingestion
File: `app/Observers/CourseModuleObserver.php`, `app/Jobs/Rag/ProcessModuleForRagJob.php`, `app/Jobs/Rag/RemoveModuleFromRagJob.php`, `app/Services/Rag/Embedding/GeminiEmbeddingService.php`, `app/Services/Rag/VectorStore/DbVectorStore.php`.

- Observer `created`/`updated` → dispatch `ProcessModuleForRagJob`:
  1. Gabung `title + description` jadi satu string.
  2. Hitung `content_hash` (mis. `sha256`), bandingkan ke hash tersimpan — kalau sama, skip (idempotency).
  3. Panggil `GeminiEmbeddingService` untuk dapat vector.
  4. Upsert ke `rag_chunks` (satu baris per modul — replace kalau sudah ada).
- Observer `deleted` → dispatch `RemoveModuleFromRagJob` → hapus baris `rag_chunks` terkait (FK cascade sebenarnya sudah otomatis handle ini kalau modul dihapus dari DB; job ini tetap berguna untuk kasus soft-delete atau future-proofing kalau nanti ada storage kedua lagi).
- `app/Console/Commands/ReindexModulesCommand.php`: loop semua `CourseModule`, dispatch `ProcessModuleForRagJob` untuk tiap satu — dipakai saat ganti model embedding (bandingkan `embedding_model` di tabel).

### Task 4 — Endpoint chat + otorisasi
File: `app/Http/Controllers/API/ChatController.php`, `app/Http/Requests/ChatRequest.php`, `routes/api.php`.

**Prasyarat: Task 0 harus sudah selesai.**

- Route: di dalam `Route::middleware('auth:sanctum')`, tambah `throttle:chat`.
- `ChatRequest`: validasi `question` (string, required), `course_id` (required, exists di `courses`), `module_id` (nullable).
- `ChatController::ask()` urutan cek:
  1. `hasActiveMembership()` — kalau gagal → **403** (perilaku lama, konsisten).
  2. Cek user berhak atas `course_id` (pola dari Task 0) — kalau gagal → **403** juga (ini toh soal hak akses, bukan soal topik pertanyaan).
  3. Cek kuota harian via `RateLimitService` — kalau habis → **200** dengan body semacam `{ "answer": "Kuota harian tercapai...", "grounded": false }` (BUKAN 403 — supaya tidak logout paksa, sesuai kontrak status code di spesifikasi awal).
  4. Panggil `RetrievalService` → `AnswerGeneratorService` → simpan ke `chat_query_logs` → balas **200**.

⚠️ Ingat kontrak status code dari spesifikasi awal: guardrail "di luar topik" HARUS 200 + `grounded: false`. 403 cuma untuk membership/akses course yang benar-benar tidak sah.

### Task 5 — Retrieval, guardrail, rate limit
File: `app/Services/Rag/Retrieval/RetrievalService.php`, `app/Services/Rag/RateLimitService.php`.

- `RetrievalService::search($question, $courseId, $topK)`:
  1. Embed `$question` via `GeminiEmbeddingService`.
  2. Ambil semua `rag_chunks` where `course_id = $courseId`.
  3. Hitung cosine similarity tiap baris, urutkan, ambil top-k.
  4. Return array hasil + skor tertinggi.
- Guardrail gate: kalau skor tertinggi < `config('rag.similarity_threshold')` → return tanpa panggil generation.
- `RateLimitService::remainingToday($userId)`: hitung dari `chat_query_logs` where `user_id` dan `created_at` hari ini — bandingkan ke `config('rag.daily_question_limit')`. Simpan sebagai service terpisah (bukan langsung di controller) supaya gampang diubah kalau nanti keputusan soal "guardrail dihitung kuota atau tidak" (Bagian 1) berubah.

### Task 6 — Generation
File: `app/Services/Rag/Generation/GeminiAnswerGeneratorService.php`, `app/Services/Rag/Generation/prompts/system_prompt.txt`.

- System prompt eksplisit: jawab HANYA dari konteks yang diberikan, kalau info tidak ada arahkan ke pengajar, jangan pakai pengetahuan umum di luar konteks, jangan jawab topik personal/di luar materi.
- Susun prompt: system prompt + hasil retrieval (title+description tiap modul relevan) + pertanyaan user.
- Non-streaming dulu untuk v1 (sesuai keputusanmu soal Dio — cek Task 7 untuk keputusan final soal ini).

### Task 7 — Response ke Flutter (non-streaming v1)
Karena kamu sudah pakai Dio (poin 7), SSE sebenarnya bisa langsung dikerjakan kalau mau — tapi saya tetap sarankan **v1 non-streaming (JSON biasa)** dulu:
- Lebih cepat rilis & lebih gampang di-debug soal kontrak status code (Bagian 4, Task 4) yang sudah cukup rumit sendiri.
- SSE bisa jadi v2 setelah v1 stabil dan kamu sudah lihat pola pertanyaan user asli.

Kalau kamu tetap mau SSE langsung di v1, kasih tahu saya — saya bisa revisi Task 6 & 7 supaya `ChatController` return `StreamedResponse` dan sisi Flutter pakai `ResponseType.stream` di Dio.

### Task 8 — Testing adversarial (guardrail)
Bukan file baru, tapi checklist manual/otomatis sebelum rilis:
- Pertanyaan pengetahuan umum ("siapa presiden Indonesia?") → harus `grounded: false`.
- Pertanyaan personal ("kapan gajian saya?") → harus `grounded: false`.
- Pertanyaan course lain yang bukan haknya → harus 403 (via Task 4 langkah 2), bukan sampai ke retrieval.
- Pertanyaan valid tentang materi yang benar-benar ada → harus `grounded: true` dengan jawaban relevan.

---

## 5. Yang perlu kamu putuskan sebelum Task 4 dimulai

- Jawaban Task 0 (pola otorisasi course).
- Konfirmasi nama model Gemini terbaru saat implementasi (Task 1) — jangan hardcode dari dokumen ini, cek dulu.