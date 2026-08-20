import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/utils/date_formatter.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('DateFormatter Tests', () {
    test('Translates English relative time strings correctly', () {
      expect(DateFormatter.translateTimeAgoString('2 hours ago'), '2 jam yang lalu');
      expect(DateFormatter.translateTimeAgoString('1 hour ago'), '1 jam yang lalu');
      expect(DateFormatter.translateTimeAgoString('5 minutes ago'), '5 menit yang lalu');
      expect(DateFormatter.translateTimeAgoString('1 minute ago'), '1 menit yang lalu');
      expect(DateFormatter.translateTimeAgoString('just now'), 'Baru saja');
      expect(DateFormatter.translateTimeAgoString('a moment ago'), 'Baru saja');
      expect(DateFormatter.translateTimeAgoString('yesterday'), 'Kemarin');
      expect(DateFormatter.translateTimeAgoString('3 days ago'), '3 hari yang lalu');
      expect(DateFormatter.translateTimeAgoString('1 week ago'), '1 minggu yang lalu');
      expect(DateFormatter.translateTimeAgoString('2 months ago'), '2 bulan yang lalu');
      expect(DateFormatter.translateTimeAgoString('1 year ago'), '1 tahun yang lalu');
    });

    test('Formats DateTime differences in Indonesian', () {
      final now = DateTime.now();

      final justNow = now.subtract(const Duration(seconds: 15));
      expect(DateFormatter.formatRelativeTimeId(justNow), 'Baru saja');

      final fiveMinsAgo = now.subtract(const Duration(minutes: 5));
      expect(DateFormatter.formatRelativeTimeId(fiveMinsAgo), '5 menit yang lalu');

      final threeHoursAgo = now.subtract(const Duration(hours: 3));
      expect(DateFormatter.formatRelativeTimeId(threeHoursAgo), '3 jam yang lalu');

      final oneDayAgo = now.subtract(const Duration(days: 1));
      expect(DateFormatter.formatRelativeTimeId(oneDayAgo), 'Kemarin');

      final fourDaysAgo = now.subtract(const Duration(days: 4));
      expect(DateFormatter.formatRelativeTimeId(fourDaysAgo), '4 hari yang lalu');
    });

    test('formatNewsDate handles pubDate ISO and timeAgo fallbacks', () {
      final now = DateTime.now();
      final isoString = now.subtract(const Duration(minutes: 30)).toIso8601String();

      expect(DateFormatter.formatNewsDate(pubDate: isoString), '30 menit yang lalu');
      expect(DateFormatter.formatNewsDate(timeAgo: '4 hours ago'), '4 jam yang lalu');
    });
  });
}
