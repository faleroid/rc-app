import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.title,
    required this.thumbnailUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar (Thumbnail)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                8.0,
              ), // Melengkungkan sudut gambar
              child: Image.network(
                thumbnailUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                // Placeholder jika gambar gagal/belum dimuat
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.blue[900], // Warna fallback seperti desain
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Bagian Judul
          SizedBox(
            height: 38, // Fixed height for max 2 lines
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              maxLines: 2, // Maksimal 2 baris agar rapi
              overflow:
                  TextOverflow.ellipsis, // Tambahkan '...' jika teks kepanjangan
            ),
          ),
        ],
      ),
    );
  }
}
