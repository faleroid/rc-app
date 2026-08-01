import 'dart:convert';
import 'lib/models/module_detail_model.dart';

void main() {
  final jsonString = '''{
    "success": true,
    "message": "Module successfully retrieved",
    "data": {
        "module": {
            "id": 1,
            "course_id": 1,
            "title": "Pengenalan Analisis Fundamental",
            "slug": "pengenalan-analisis-fundamental",
            "description": null,
            "content": null,
            "duration_minutes": 30,
            "created_at": null,
            "updated_at": "2026-06-29T15:47:33.000000Z",
            "formatted_duration": "30m",
            "formatted_file_size": null,
            "file_url": null
        },
        "navigation": {
            "previous": null,
            "next": {
                "id": 2,
                "title": "Indikator Ekonomi Penting",
                "slug": "indikator-ekonomi-penting",
                "sort_order": 2
            },
            "current": 1,
            "total": 3
        }
    }
}''';
  try {
    final parsed = jsonDecode(jsonString);
    final response = ModuleDetailResponse.fromJson(parsed);
    print("Success!");
    print("description: ${response.module.description}");
    print("fileUrl: ${response.module.fileUrl}");
  } catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
}
