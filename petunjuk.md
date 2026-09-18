# BUKU PETUNJUK PENGGUNAAN APLIKASI
## (USER MANUAL BOOK)

# RicoCapital Academy App
**Platform Edukasi Investasi & Trading Cryptocurrency Berbasis AI**

Diciptakan oleh:
Tim Pengembang RicoCapital

---

## DAFTAR ISI

| No    | Judul                                                              |
|-------|--------------------------------------------------------------------|
|       | DAFTAR ISI                                                         |
| I     | **BAB I PENDAHULUAN**                                              |
| 1.1   | Tujuan Pembuatan Dokumen                                           |
| 1.2   | Deskripsi Umum Aplikasi                                            |
| 1.3   | Teknologi Aplikasi                                                 |
| 1.4   | Atribusi                                                           |
| 1.5   | Deskripsi Dokumen                                                  |
| II    | **BAB II MANUAL PENGGUNAAN PROGRAM**                               |
| 2.1   | Memulai Penggunaan Aplikasi (Onboarding)                           |
| 2.2   | Autentikasi                                                        |
| 2.2.1 | Pembuatan Akun Baru (Register)                                     |
| 2.2.2 | Masuk ke Akun (Login)                                              |
| 2.3   | Halaman Utama (Landing Page)                                       |
| 2.4   | Sistem Pembayaran & Berlangganan VIP                               |
| 2.4.1 | Pembayaran via Midtrans (Virtual Account / QRIS / E-Wallet)       |
| 2.4.2 | Pembayaran via Crypto (USDT / Bitcoin)                             |
| 2.5   | Dashboard VIP Member                                               |
| 2.5.1 | Menu Berita (News)                                                 |
| 2.5.2 | Menu Sinyal Trading                                                |
| 2.5.3 | Menu Kursus (Course)                                               |
| 2.5.4 | Menu E-Book                                                        |
| 2.6   | Modul Pembelajaran                                                 |
| 2.6.1 | Mengakses Modul Pembelajaran                                       |
| 2.6.2 | Membaca Materi Teks & Menonton Video Modul                         |
| 2.7   | Fitur Asisten AI (RAG AI Chatbot)                                  |
| 2.7.1 | Fungsi Utama Asisten AI                                            |
| 2.7.2 | Cara Mengakses Fitur Asisten AI                                    |
| 2.7.3 | Riwayat Percakapan                                                 |
| 2.8   | Pengaturan Akun                                                    |
| 2.8.1 | Mengelola Profil Pengguna                                          |
| 2.8.2 | Mengubah Kata Sandi                                                |
| 2.8.3 | Keluar dari Akun (Logout)                                          |
| 2.9   | Notifikasi & Pengumuman VIP                                        |

---

## BAB I
## PENDAHULUAN

### 1.1 Tujuan Pembuatan Dokumen

Dokumen ini dibuat sebagai pedoman komprehensif dan dokumentasi resmi penggunaan aplikasi RicoCapital Academy. Tujuannya adalah untuk memberikan panduan langkah demi langkah kepada pengguna akhir agar dapat memanfaatkan seluruh fitur aplikasi secara optimal, mulai dari pendaftaran akun, berlangganan paket keanggotaan VIP, mengakses modul pembelajaran, hingga berinteraksi dengan Asisten AI Pembelajaran.

### 1.2 Deskripsi Umum Aplikasi

**RicoCapital Academy App** adalah platform edukasi investasi dan trading cryptocurrency berbasis kecerdasan buatan (AI) yang dirancang untuk memberdayakan masyarakat Indonesia dalam memahami dunia aset digital secara aman dan terstruktur. Aplikasi seluler ini menyediakan:

- **Modul Pembelajaran Interaktif**: Kursus video dan teks yang disusun oleh praktisi berpengalaman, mencakup materi mulai dari pengenalan blockchain, analisis teknikal (Technical Analysis), hingga strategi trading lanjutan.
- **Sinyal Trading Real-Time**: Rekomendasi sinyal masuk dan keluar pasar (Buy/Sell) yang diperbarui secara berkala oleh tim analis.
- **Asisten AI Pembelajaran (RAG Chatbot)**: Fitur chatbot cerdas berbasis teknologi Retrieval-Augmented Generation (RAG) yang mampu menjawab pertanyaan siswa berdasarkan materi modul yang tersedia.
- **Berita Cryptocurrency Terkini**: Agregasi berita terbaru dari dunia kripto dan keuangan global.
- **E-Book Premium**: Koleksi buku digital yang dapat dibaca langsung di dalam aplikasi.
- **Sistem Pembayaran Terintegrasi**: Mendukung pembayaran melalui Midtrans (Virtual Account, QRIS, E-Wallet) dan transfer Cryptocurrency (USDT TRC-20/BEP-20, Bitcoin).

### 1.3 Teknologi Aplikasi

Aplikasi ini dibangun menggunakan arsitektur teknologi modern yang tangguh untuk mendukung pengalaman belajar yang optimal, meliputi:

- **Antarmuka (Frontend Mobile)**: Flutter, digunakan untuk membangun aplikasi seluler lintas platform (Android & iOS) yang responsif dan berkinerja tinggi.
- **Antarmuka (Frontend Web)**: React.js dengan Inertia.js, digunakan untuk panel administrasi dan halaman web publik.
- **Server & Basis Data (Backend)**: Laravel (PHP) dan MySQL yang di-hosting pada shared hosting, bertugas memproses logika program, autentikasi, dan manajemen data.
- **Penyimpanan Media**: Cloudflare R2, digunakan untuk menyimpan dan menyajikan video modul pembelajaran secara efisien melalui CDN global.
- **Sistem Cerdas (AI)**: Claude Haiku 4.5 (Anthropic) / Gemini 3.6 Flash (Google), mesin pendorong di balik Asisten AI Pembelajaran yang mampu memproses pertanyaan siswa secara cerdas berdasarkan konteks materi modul (Retrieval-Augmented Generation).
- **Payment Gateway**: Midtrans Snap, digunakan untuk memproses pembayaran keanggotaan VIP melalui berbagai metode pembayaran digital.
- **Notifikasi Push**: Firebase Cloud Messaging (FCM), digunakan untuk mengirimkan notifikasi pengumuman VIP secara real-time ke perangkat pengguna.
- **Autentikasi & Keamanan**: Laravel Sanctum (Token-based Authentication) dengan Flutter Secure Storage untuk penyimpanan token yang terenkripsi di perangkat.

### 1.4 Atribusi

Aplikasi ini dikembangkan dan dikelola sepenuhnya oleh tim internal RicoCapital. Pengembangan sistem didukung oleh berbagai teknologi modern, seperti Flutter, Laravel, MySQL, serta layanan dari Cloudflare R2, Midtrans, Anthropic Claude AI, Google Gemini AI, dan Firebase. Seluruh aset visual, desain antarmuka, dan konten edukasi dikembangkan secara internal oleh tim RicoCapital.

### 1.5 Deskripsi Dokumen

Dokumen ini memuat penjelasan mendalam mengenai tujuan sistem, deskripsi fungsional aplikasi, spesifikasi teknologi yang digunakan, atribusi pengembangan, serta panduan teknis langkah demi langkah (user manual) dalam menggunakan RicoCapital Academy App. Dokumen ini diharapkan menjadi rujukan utama bagi pengguna akhir untuk memanfaatkan seluruh fitur aplikasi dan ekosistem pembelajaran secara optimal.

---

## BAB II
## MANUAL PENGGUNAAN PROGRAM

### 2.1 Memulai Penggunaan Aplikasi (Onboarding)

Saat pertama kali mengunduh dan membuka aplikasi RicoCapital Academy, pengguna akan disambut dengan halaman Splash Screen yang menampilkan logo resmi RicoCapital. Sistem secara otomatis memeriksa status autentikasi pengguna:

1. Buka aplikasi **RicoCapital Academy** pada perangkat seluler Anda.
2. Halaman Splash Screen akan tampil sekilas menampilkan logo RicoCapital.
3. Jika pengguna **belum login** atau **belum memiliki akun**, sistem akan mengarahkan ke **Halaman Utama (Landing Page)** yang menampilkan informasi umum tentang RicoCapital Academy.
4. Jika pengguna **sudah login** dan memiliki **token sesi yang masih aktif**, sistem akan langsung mengarahkan ke **Dashboard VIP Member**.

### 2.2 Autentikasi

#### 2.2.1 Pembuatan Akun Baru (Register)

Sebelum dapat menggunakan seluruh fitur premium yang tersedia di dalam aplikasi RicoCapital Academy, pengguna diwajibkan untuk melakukan registrasi atau pembuatan akun baru terlebih dahulu.

**Panduan pengisian data pada Halaman Pembuatan Akun Baru:**

1. Dari halaman Landing Page, tekan tombol **"Masuk"** di pojok kanan atas layar.
2. Pada halaman Login, ketuk tautan **"Daftar"** di bagian bawah formulir untuk berpindah ke halaman Registrasi.
3. Isi formulir pendaftaran dengan data berikut:
   - **Nama Lengkap**: Masukkan nama lengkap Anda pada kolom yang tersedia.
   - **Email**: Masukkan alamat email aktif yang akan digunakan sebagai identitas login.
   - **Kata Sandi**: Buat kata sandi minimal 8 karakter yang menggabungkan huruf dan angka.
   - **Konfirmasi Kata Sandi**: Masukkan ulang kata sandi yang sama untuk memastikan kecocokan.
4. Setelah semua kolom terisi dengan benar, tekan tombol **"Daftar"** untuk menyelesaikan proses registrasi.
5. Jika registrasi berhasil, sistem akan secara otomatis memasukkan Anda ke dalam aplikasi dan mengarahkan ke Halaman Utama.

> **Catatan:** Pastikan alamat email yang didaftarkan adalah email aktif, karena akan digunakan sebagai identitas login di kemudian hari.

#### 2.2.2 Masuk ke Akun (Login)

Jika pengguna sudah memiliki akun yang terdaftar, pengguna dapat langsung masuk ke aplikasi melalui halaman Login.

**Panduan masuk ke akun:**

1. Dari halaman Landing Page, tekan tombol **"Masuk"** di pojok kanan atas layar.
2. Masukkan **Email** yang terdaftar pada kolom pertama.
3. Masukkan **Kata Sandi** akun Anda pada kolom kedua.
4. Tekan tombol **"Masuk"** untuk melakukan autentikasi.
5. Jika data login valid, sistem akan mengarahkan Anda ke **Dashboard VIP Member** (jika keanggotaan aktif) atau ke **Halaman Utama** untuk melakukan pembelian paket VIP terlebih dahulu.

> **Catatan:** Jika Anda salah memasukkan email atau kata sandi, sistem akan menampilkan pesan error berupa keterangan kesalahan yang spesifik.

### 2.3 Halaman Utama (Landing Page)

Halaman Utama adalah tampilan pertama yang dilihat oleh pengguna yang belum login atau belum berlangganan paket VIP. Halaman ini berfungsi sebagai etalase digital yang memperkenalkan seluruh ekosistem RicoCapital Academy.

**Komponen Halaman Utama:**

Halaman utama memiliki navigasi Tab Bar dengan 4 tab utama yang dapat digeser:

1. **Tab Home**: Menampilkan informasi utama, video testimonial YouTube, ticker harga cryptocurrency real-time, dan call-to-action untuk bergabung.
2. **Tab Academy**: Menampilkan deskripsi kurikulum pembelajaran, daftar modul, dan keunggulan metode edukasi RicoCapital.
3. **Tab About**: Menampilkan profil tim pengembang, visi misi RicoCapital, dan informasi kontak resmi.
4. **Tab Packages**: Menampilkan daftar paket keanggotaan VIP beserta harga, benefit, dan tombol pembelian.

**Panduan navigasi Halaman Utama:**

1. Geser (swipe) layar ke kiri/kanan atau ketuk label tab untuk berpindah antar konten.
2. Untuk memulai berlangganan, ketuk tombol **"Mulai Belajar Sekarang"** atau navigasi ke tab **"Packages"**.
3. Tekan tombol **"Masuk"** di pojok kanan atas untuk login jika sudah memiliki akun.

### 2.4 Sistem Pembayaran & Berlangganan VIP

Untuk mengakses seluruh fitur premium (Modul Pembelajaran, Sinyal Trading, Berita, E-Book, dan Asisten AI), pengguna diwajibkan berlangganan salah satu paket keanggotaan VIP yang tersedia.

#### 2.4.1 Pembayaran via Midtrans (Virtual Account / QRIS / E-Wallet)

**Panduan pembayaran menggunakan Midtrans:**

1. Pilih paket keanggotaan VIP yang diinginkan pada tab **"Packages"**.
2. Tekan tombol **"Berlangganan Sekarang"** pada kartu paket yang dipilih.
3. Sistem akan menampilkan halaman **Checkout Pembayaran** yang berisi ringkasan paket, harga, dan metode pembayaran.
4. Tekan tombol **"Bayar Sekarang"** untuk membuka widget pembayaran **Midtrans Snap**.
5. Pada widget Midtrans, pilih metode pembayaran yang diinginkan:
   - **Virtual Account** (BCA, BNI, BRI, Mandiri, Permata, dll.)
   - **QRIS** (Scan QR Code menggunakan aplikasi e-wallet)
   - **E-Wallet** (GoPay, ShopeePay, DANA, OVO, dll.)
6. Ikuti instruksi pembayaran yang ditampilkan pada layar sesuai metode yang dipilih.
7. Setelah pembayaran berhasil diproses:
   - Sistem akan secara otomatis mengaktifkan keanggotaan VIP Anda melalui **Webhook Midtrans** (jalur utama).
   - Jika notifikasi webhook belum diterima, sistem juga menyediakan **Auto-Sync** yang memperbarui status saat Anda kembali ke aplikasi.
8. Keanggotaan VIP akan langsung aktif dan seluruh fitur premium dapat diakses.

#### 2.4.2 Pembayaran via Crypto (USDT / Bitcoin)

**Panduan pembayaran menggunakan Cryptocurrency:**

1. Pilih paket keanggotaan VIP yang diinginkan pada tab **"Packages"**.
2. Tekan tombol **"Bayar dengan Crypto"** pada kartu paket yang dipilih.
3. Sistem akan menampilkan dialog **Pembayaran Crypto** yang berisi:
   - **Alamat Wallet** tujuan transfer (USDT TRC-20, USDT BEP-20, atau Bitcoin).
   - **QR Code** yang dapat di-scan langsung dari aplikasi dompet kripto Anda.
   - **Nominal transfer** dalam mata uang kripto yang harus dikirimkan.
4. Transfer sejumlah koin kripto yang tertera ke alamat wallet yang ditampilkan.
5. Setelah transfer berhasil, **ambil screenshot bukti transfer** dari aplikasi dompet kripto Anda.
6. Kembali ke aplikasi RicoCapital, lalu **unggah foto bukti transfer** pada formulir yang tersedia.
7. Tekan tombol **"Kirim Bukti"** untuk mengirimkan bukti transfer kepada tim admin.
8. Status pembayaran Anda akan berubah menjadi **"Menunggu Verifikasi"**.
9. Tim admin RicoCapital akan melakukan **verifikasi manual** terhadap bukti transfer Anda.
10. Setelah diverifikasi dan disetujui oleh admin, keanggotaan VIP Anda akan **otomatis aktif**.

> **Catatan:** Proses verifikasi pembayaran crypto biasanya memerlukan waktu 1×24 jam kerja. Anda dapat memeriksa status pembayaran pada menu **Riwayat Pembayaran** di halaman Profil.

### 2.5 Dashboard VIP Member

Setelah keanggotaan VIP aktif, pengguna akan diarahkan ke Dashboard VIP Member yang menampilkan 4 menu utama pada bar navigasi bawah (Bottom Navigation Bar).

#### 2.5.1 Menu Berita (News)

Menu Berita menampilkan kumpulan artikel dan berita terkini seputar dunia cryptocurrency, blockchain, dan keuangan global.

**Panduan menggunakan Menu Berita:**

1. Ketuk ikon **"Berita"** (ikon artikel) pada bar navigasi bawah.
2. Daftar artikel berita akan ditampilkan dalam format kartu dengan gambar thumbnail, judul, dan waktu publikasi.
3. Ketuk salah satu kartu artikel untuk membaca isi berita secara lengkap.
4. Pada halaman detail berita, Anda dapat membaca artikel lengkap beserta gambar pendukungnya.

#### 2.5.2 Menu Sinyal Trading

Menu Sinyal Trading menyajikan rekomendasi sinyal masuk dan keluar pasar (Buy/Sell) yang diperbarui secara berkala oleh tim analis RicoCapital.

**Panduan menggunakan Menu Sinyal Trading:**

1. Ketuk ikon **"Sinyal"** (ikon grafik) pada bar navigasi bawah.
2. Daftar sinyal trading akan ditampilkan dalam format kartu yang memuat:
   - **Pasangan Aset** (contoh: BTC/USDT, ETH/USDT).
   - **Tipe Sinyal**: Buy (Beli) atau Sell (Jual).
   - **Harga Entry, Take Profit, dan Stop Loss**.
   - **Status Sinyal**: Aktif, Tercapai (TP Hit), atau Terkena Stop Loss (SL Hit).
3. Ketuk salah satu kartu sinyal untuk melihat detail lengkap beserta analisis dan keterangan tambahan.

> **Catatan (Khusus Admin):** Pengguna dengan peran Admin akan melihat tombol **"+ Sinyal"** (Floating Action Button) untuk menambahkan sinyal trading baru.

#### 2.5.3 Menu Kursus (Course)

Menu Kursus menampilkan seluruh daftar kursus yang tersedia dalam kurikulum RicoCapital Academy.

**Panduan menggunakan Menu Kursus:**

1. Ketuk ikon **"Kursus"** (ikon buku) pada bar navigasi bawah.
2. Daftar kursus akan ditampilkan dalam format kartu dengan informasi:
   - **Judul Kursus** (contoh: "Technical Analysis Masterclass", "Pengenalan Trading untuk Pemula").
   - **Jumlah Modul** yang tersedia dalam kursus tersebut.
   - **Total Durasi** pembelajaran.
   - **Level Kesulitan**: Pemula, Menengah, atau Lanjutan.
3. Ketuk salah satu kartu kursus untuk masuk ke halaman detail kursus yang berisi daftar modul pembelajaran.

#### 2.5.4 Menu E-Book

Menu E-Book menyajikan koleksi buku digital premium yang dapat dibaca langsung di dalam aplikasi.

**Panduan menggunakan Menu E-Book:**

1. Ketuk ikon **"E-Book"** (ikon perpustakaan) pada bar navigasi bawah.
2. Daftar e-book akan ditampilkan dalam format kartu dengan cover buku, judul, dan penulis.
3. Ketuk salah satu kartu e-book untuk membuka dan membaca isi buku secara langsung di dalam aplikasi menggunakan PDF Reader bawaan.

### 2.6 Modul Pembelajaran

#### 2.6.1 Mengakses Modul Pembelajaran

Modul Pembelajaran adalah inti dari kurikulum edukasi RicoCapital Academy. Setiap kursus terdiri dari beberapa modul yang disusun secara berurutan dan terstruktur.

**Panduan mengakses Modul Pembelajaran:**

1. Dari **Menu Kursus**, ketuk salah satu kursus yang ingin dipelajari.
2. Halaman detail kursus akan menampilkan **daftar modul** yang tersusun berurutan.
3. Ketuk salah satu modul untuk masuk ke halaman **Detail Modul**.

#### 2.6.2 Membaca Materi Teks & Menonton Video Modul

Halaman Detail Modul menampilkan konten pembelajaran lengkap yang terdiri dari video pembelajaran dan materi teks.

**Komponen halaman Detail Modul:**

1. **Video Pembelajaran**: Di bagian atas halaman, terdapat pemutar video (video player) yang menampilkan materi video dari modul tersebut. Tekan tombol Play (▶) untuk memulai pemutaran video. Video mendukung fitur layar penuh (fullscreen), kontrol kecepatan pemutaran, dan progress bar.
2. **Materi Teks**: Di bawah video, terdapat konten teks pembelajaran yang menjelaskan materi modul secara detail.
3. **Modul Lainnya**: Di bagian paling bawah, terdapat daftar modul lain dari kursus yang sama untuk memudahkan navigasi antar modul.

> **Catatan:** Format video yang didukung adalah **MP4 (H.264/AAC)**. Jika video berformat `.webm`, beberapa perangkat HP mungkin tidak dapat memutar video tersebut. Dalam hal ini, pesan peringatan akan ditampilkan.

### 2.7 Fitur Asisten AI (RAG AI Chatbot)

#### 2.7.1 Fungsi Utama Asisten AI

Fitur Asisten AI adalah asisten pintar berbasis kecerdasan buatan yang dirancang untuk membantu siswa memahami materi pembelajaran secara lebih efektif. Asisten AI menggunakan teknologi **Retrieval-Augmented Generation (RAG)** yang menggabungkan pencarian konteks materi modul dengan kemampuan generatif Large Language Model (LLM). Adapun fungsi utama dari fitur Asisten AI meliputi:

- **Konsultasi Materi Pembelajaran**: Menyediakan wadah diskusi interaktif bagi siswa untuk menanyakan berbagai hal seputar materi modul yang telah dipelajari. Asisten AI mampu memberikan jawaban yang akurat berdasarkan konten modul yang tersedia dalam kurikulum RicoCapital.
- **Rangkuman Modul Otomatis**: Siswa dapat meminta Asisten AI untuk merangkum poin-poin penting dari suatu modul pembelajaran, sehingga mempercepat proses pemahaman materi.
- **Pencarian Materi Lintas Kursus (Fallback Search)**: Jika materi yang ditanyakan tidak ditemukan di kursus yang sedang dibuka, Asisten AI secara otomatis akan mencari jawaban dari seluruh modul di semua kursus yang tersedia.

#### 2.7.2 Cara Mengakses Fitur Asisten AI

Untuk dapat mulai berinteraksi dan melakukan konsultasi dengan Asisten AI, pengguna dapat mengikuti langkah-langkah panduan berikut:

1. Pastikan Anda sudah **login** dan memiliki **keanggotaan VIP aktif**.
2. Pada Dashboard VIP Member, perhatikan tombol **Floating Action Button** berbentuk lingkaran dengan ikon chat yang berada di pojok kanan bawah layar.
3. Ketuk tombol tersebut untuk membuka **Modal Chatbot AI**.
4. Modal chatbot akan muncul dari bawah layar, menampilkan ruang obrolan dengan pesan sambutan dari Asisten AI.
5. Pada kolom pesan di bagian bawah ruang obrolan, ketik pertanyaan atau topik materi yang ingin ditanyakan.
6. Tekan tombol **Kirim** (ikon panah) untuk mengirimkan pertanyaan.
7. Asisten AI akan memproses pertanyaan, mencari konteks materi yang relevan dari modul pembelajaran, dan memberikan jawaban dalam waktu beberapa detik.
8. Di bawah setiap jawaban AI, terdapat informasi **Sumber Referensi Modul** yang menunjukkan dari modul dan kursus mana jawaban tersebut diambil.

> **Catatan:** Asisten AI hanya dapat menjawab pertanyaan yang berkaitan dengan materi modul RicoCapital (cryptocurrency, blockchain, trading). Pertanyaan di luar topik akan dijawab dengan pesan: *"Materi yang Anda tanyakan belum tersedia di kelas ini."*

#### 2.7.3 Riwayat Percakapan

Aplikasi menyimpan riwayat percakapan Anda dengan Asisten AI secara otomatis di perangkat HP selama **24 jam**. Fitur ini memastikan Anda tidak perlu mengulang pertanyaan yang sama jika keluar dan membuka kembali aplikasi dalam rentang waktu tersebut.

- Jika Anda membuka modal chatbot **dalam 24 jam** sejak percakapan terakhir, riwayat obrolan sebelumnya akan **otomatis dimuat kembali**.
- Jika sudah **melewati 24 jam**, riwayat percakapan akan **dibersihkan secara otomatis** dan Asisten AI akan menyapa dengan pesan sambutan baru.

### 2.8 Pengaturan Akun

#### 2.8.1 Mengelola Profil Pengguna

Halaman Profil digunakan untuk melihat dan mengelola informasi akun pengguna.

**Komponen halaman Profil:**

1. **Avatar Profil**: Ikon profil pengguna yang ditampilkan di bagian atas halaman.
2. **Nama Pengguna (Username)**: Menampilkan nama yang terdaftar. Dapat diperbarui dengan mengetuk opsi **"Ubah Username"**.
3. **Email**: Menampilkan alamat email yang terdaftar di akun (hanya dapat dibaca, tidak dapat diubah).
4. **Status Keanggotaan**: Menampilkan informasi paket VIP yang sedang aktif beserta tanggal kadaluarsanya.
5. **Menu Pengaturan Tambahan**:
   - Ubah Kata Sandi
   - Pusat Bantuan
   - Kebijakan Privasi
   - Syarat & Ketentuan

**Langkah-langkah untuk Mengelola Profil:**

1. Ketuk ikon **Avatar Profil** dan nama pengguna di pojok kanan atas layar utama.
2. Sistem akan mengarahkan ke halaman **Profil Saya**.
3. Untuk mengubah username, ketuk opsi **"Ubah Username"**, masukkan nama baru, lalu tekan **"Simpan"**.
4. Untuk kembali ke halaman utama, ketuk tombol kembali di pojok kiri atas.

#### 2.8.2 Mengubah Kata Sandi

Fitur ini memungkinkan pengguna untuk memperbarui kata sandi akun demi keamanan.

**Panduan mengubah kata sandi:**

1. Dari halaman Profil, ketuk menu **"Ubah Kata Sandi"**.
2. Sistem akan meminta Anda memasukkan **Kata Sandi Lama** terlebih dahulu untuk verifikasi identitas.
3. Setelah verifikasi berhasil, masukkan **Kata Sandi Baru** (minimal 8 karakter).
4. Masukkan ulang kata sandi baru pada kolom **Konfirmasi Kata Sandi Baru**.
5. Tekan tombol **"Simpan"** untuk memperbarui kata sandi.
6. Jika berhasil, sistem akan menampilkan notifikasi berhasil dan Anda dapat menggunakan kata sandi baru untuk login selanjutnya.

#### 2.8.3 Keluar dari Akun (Logout)

Untuk keluar dari sesi aktif pada aplikasi:

1. Dari halaman Profil, gulir ke bawah hingga menemukan tombol **"Keluar"**.
2. Ketuk tombol **"Keluar"** yang berwarna merah.
3. Sistem akan menghapus token sesi dari perangkat dan mengarahkan Anda kembali ke **Halaman Utama (Landing Page)**.

> **Catatan:** Setelah logout, Anda harus login kembali menggunakan email dan kata sandi untuk mengakses fitur premium.

### 2.9 Notifikasi & Pengumuman VIP

Fitur Notifikasi & Pengumuman VIP memungkinkan tim RicoCapital untuk mengirimkan informasi penting, pembaruan, dan pengumuman khusus kepada seluruh anggota VIP aktif secara real-time.

**Panduan mengakses Pengumuman VIP:**

1. Pada bar atas aplikasi (AppBar), perhatikan ikon **Lonceng** yang terletak di samping kiri avatar profil.
2. Jika terdapat pengumuman yang belum dibaca, ikon lonceng akan menampilkan **badge angka merah** yang menunjukkan jumlah pengumuman baru.
3. Ketuk ikon lonceng untuk membuka halaman **Daftar Pengumuman VIP**.
4. Daftar pengumuman akan ditampilkan dengan judul, waktu publikasi, dan status baca/belum baca.
5. Ketuk salah satu pengumuman untuk membaca isi lengkapnya.
6. Setelah dibaca, badge angka pada ikon lonceng akan berkurang secara otomatis.

> **Catatan:** Notifikasi push juga akan dikirimkan ke perangkat Anda meskipun aplikasi sedang tidak dibuka, selama notifikasi pada perangkat Anda diizinkan.

---

**© 2026 RicoCapital Academy. Seluruh Hak Cipta Dilindungi.**
