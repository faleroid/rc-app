import 'dart:convert';
import 'lib/models/module_detail_model.dart';

void main() {
  final jsonString = '''{
    "success": true,
    "message": "Module successfully retrieved",
    "data": {
        "module": {
            "id": 12,
            "title": "Test Cloudfare",
            "slug": "test-cloudfare",
            "description": "Ini deskripsi dari cloudfare",
            "status": "published",
            "created_at": "2026-08-12T04:28:59.000000Z",
            "updated_at": "2026-08-12T04:41:58.000000Z",
            "video_url": null,
            "formatted_duration": "1m",
            "formatted_file_size": "2.67 MB",
            "youtube_embed_url": null,
            "file_url": "http://localhost:8000/media/r2/videos/courses/pengenalan-trading-pemula/test-cloudfare-OLzuBp5P.mp4",
            "video_playback_url": "https://pub-6f2c5d84691f614d1086d8c432e49386.r2.dev/videos/courses/pengenalan-trading-pemula/test-cloudfare-OLzuBp5P.mp4"
        },
        "navigation": {
            "previous": null,
            "next": null,
            "current": 1,
            "total": 1
        }
    }
}''';

  try {
    final parsed = jsonDecode(jsonString);
    final response = ModuleDetailResponse.fromJson(parsed);
    print("Parsing success!");
    print("Title: ${response.module.title}");
    print("fileUrl: ${response.module.fileUrl}");
    print("videoPlaybackUrl: ${response.module.videoPlaybackUrl}");
    print("videoStreamUrl: ${response.module.videoStreamUrl}");
  } catch (e, stackTrace) {
    print("Error: $e");
    print(stackTrace);
  }
}
