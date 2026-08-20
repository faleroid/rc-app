import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Mengonversi format waktu berita (timeAgo atau pubDate) ke Bahasa Indonesia
  static String formatNewsDate({String? timeAgo, String? pubDate}) {
    // 1. Coba parse pubDate jika ada dan valid
    if (pubDate != null && pubDate.trim().isNotEmpty) {
      final parsed = _parseDateTime(pubDate);
      if (parsed != null) {
        return formatRelativeTimeId(parsed);
      }
    }

    // 2. Jika ada timeAgo (misal string berbahasa Inggris dari API), terjemahkan ke bahasa Indonesia
    if (timeAgo != null && timeAgo.trim().isNotEmpty) {
      return translateTimeAgoString(timeAgo);
    }

    // 3. Fallback jika pubDate tidak dapat di-parse sebagai DateTime standar
    if (pubDate != null && pubDate.trim().isNotEmpty) {
      return translateTimeAgoString(pubDate);
    }

    return '';
  }

  /// Menghitung selisih waktu dari [dateTime] ke waktu saat ini dalam format Bahasa Indonesia
  static String formatRelativeTimeId(DateTime dateTime) {
    final now = DateTime.now();
    final localDate = dateTime.toLocal();
    final diff = now.difference(localDate);

    // Jika waktu sedikit di masa depan karena perbedaan clock/zona waktu
    if (diff.isNegative) {
      return 'Baru saja';
    }

    if (diff.inSeconds < 60) {
      return 'Baru saja';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit yang lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam yang lalu';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari yang lalu';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  /// Mem-parse string tanggal ke [DateTime] dari berbagai format umum
  static DateTime? _parseDateTime(String dateStr) {
    final trimmed = dateStr.trim();
    if (trimmed.isEmpty) return null;

    // Coba ISO 8601 standar
    final isoParsed = DateTime.tryParse(trimmed);
    if (isoParsed != null) return isoParsed;

    // Format RFC 2822 / RSS feed dan custom formats
    final formats = [
      "EEE, dd MMM yyyy HH:mm:ss Z",
      "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
      "EEE, dd MMM yyyy HH:mm:ss zzz",
      "dd MMM yyyy HH:mm:ss Z",
      "yyyy-MM-dd HH:mm:ss",
      "yyyy-MM-dd HH:mm",
      "dd/MM/yyyy HH:mm:ss",
      "dd/MM/yyyy HH:mm",
      "dd-MM-yyyy HH:mm:ss",
      "dd-MM-yyyy HH:mm",
      "MMMM d, yyyy",
      "d MMMM yyyy",
    ];

    for (final pattern in formats) {
      try {
        return DateFormat(pattern, 'en_US').parse(trimmed);
      } catch (_) {}
      try {
        return DateFormat(pattern, 'id_ID').parse(trimmed);
      } catch (_) {}
    }

    return null;
  }

  /// Menerjemahkan frasa waktu relatif berbahasa Inggris ke Bahasa Indonesia
  static String translateTimeAgoString(String input) {
    String text = input.trim();
    if (text.isEmpty) return '';

    final lower = text.toLowerCase();
    if (lower == 'just now' || lower == 'a moment ago' || lower == 'right now') {
      return 'Baru saja';
    }
    if (lower == 'yesterday') {
      return 'Kemarin';
    }

    // Pola angka + satuan + ago (e.g., "5 hours ago", "2 mins ago")
    final regexNumber = RegExp(
      r'(\d+)\s*(second|sec|minute|min|hour|hr|day|week|month|year)s?\s*ago',
      caseSensitive: false,
    );
    final match = regexNumber.firstMatch(text);
    if (match != null) {
      final count = match.group(1)!;
      final unit = match.group(2)!.toLowerCase();
      switch (unit) {
        case 'second':
        case 'sec':
          return '$count detik yang lalu';
        case 'minute':
        case 'min':
          return '$count menit yang lalu';
        case 'hour':
        case 'hr':
          return '$count jam yang lalu';
        case 'day':
          return '$count hari yang lalu';
        case 'week':
          return '$count minggu yang lalu';
        case 'month':
          return '$count bulan yang lalu';
        case 'year':
          return '$count tahun yang lalu';
      }
    }

    // Pola artikel tunggal (e.g., "an hour ago", "a day ago")
    final regexSingle = RegExp(
      r'(an?)\s+(second|minute|hour|day|week|month|year)\s+ago',
      caseSensitive: false,
    );
    final matchSingle = regexSingle.firstMatch(text);
    if (matchSingle != null) {
      final unit = matchSingle.group(2)!.toLowerCase();
      switch (unit) {
        case 'second':
          return '1 detik yang lalu';
        case 'minute':
          return '1 menit yang lalu';
        case 'hour':
          return '1 jam yang lalu';
        case 'day':
          return '1 hari yang lalu';
        case 'week':
          return '1 minggu yang lalu';
        case 'month':
          return '1 bulan yang lalu';
        case 'year':
          return '1 tahun yang lalu';
      }
    }

    // Terjemahkan nama bulan jika berupa format tanggal
    final Map<String, String> monthsMap = {
      'january': 'Januari',
      'february': 'Februari',
      'march': 'Maret',
      'april': 'April',
      'may': 'Mei',
      'june': 'Juni',
      'july': 'Juli',
      'august': 'Agustus',
      'september': 'September',
      'october': 'Oktober',
      'november': 'November',
      'december': 'Desember',
      'jan': 'Jan',
      'feb': 'Feb',
      'mar': 'Mar',
      'apr': 'Apr',
      'jun': 'Jun',
      'jul': 'Jul',
      'aug': 'Agu',
      'sep': 'Sep',
      'oct': 'Okt',
      'nov': 'Nov',
      'dec': 'Des',
    };

    monthsMap.forEach((en, id) {
      text = text.replaceAll(RegExp('\\b$en\\b', caseSensitive: false), id);
    });

    text = text.replaceAll(RegExp(r'\bago\b', caseSensitive: false), 'yang lalu');
    text = text.replaceAll(RegExp(r'\byesterday\b', caseSensitive: false), 'Kemarin');
    text = text.replaceAll(RegExp(r'\bhours?\b', caseSensitive: false), 'jam');
    text = text.replaceAll(RegExp(r'\bminutes?\b', caseSensitive: false), 'menit');
    text = text.replaceAll(RegExp(r'\bseconds?\b', caseSensitive: false), 'detik');
    text = text.replaceAll(RegExp(r'\bdays?\b', caseSensitive: false), 'hari');
    text = text.replaceAll(RegExp(r'\bweeks?\b', caseSensitive: false), 'minggu');
    text = text.replaceAll(RegExp(r'\bmonths?\b', caseSensitive: false), 'bulan');
    text = text.replaceAll(RegExp(r'\byears?\b', caseSensitive: false), 'tahun');

    return text;
  }
}
