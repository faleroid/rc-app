import 'package:dio/dio.dart';

class BitcoinPricePoint {
  final DateTime time;
  final double price;

  BitcoinPricePoint({required this.time, required this.price});
}

class BitcoinData {
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final List<BitcoinPricePoint> priceHistory;

  BitcoinData({
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.priceHistory,
  });
}

class BitcoinRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.coingecko.com/api/v3',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'RicoCapitalApp/1.0',
    },
  ));

  Future<BitcoinData> fetchBitcoinData() async {
    try {
      // Satu endpoint yang memberikan semua data sekaligus (lebih stabil)
      final response = await _dio.get(
        '/coins/bitcoin/market_chart',
        queryParameters: {
          'vs_currency': 'usd',
          'days': '7',
          'interval': 'daily',
        },
      );

      final prices = response.data['prices'] as List;

      if (prices.isEmpty) {
        throw Exception('Data harga kosong');
      }

      final priceHistory = prices.map((point) {
        return BitcoinPricePoint(
          time: DateTime.fromMillisecondsSinceEpoch((point[0] as num).toInt()),
          price: (point[1] as num).toDouble(),
        );
      }).toList();

      // Hitung harga saat ini dan perubahan dari data histori
      final currentPrice = priceHistory.last.price;
      final firstPrice = priceHistory.first.price;
      final priceChange = currentPrice - firstPrice;
      final priceChangePercent = (priceChange / firstPrice) * 100;

      return BitcoinData(
        currentPrice: currentPrice,
        priceChange24h: priceChange,
        priceChangePercentage24h: priceChangePercent,
        priceHistory: priceHistory,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 429) {
        throw Exception('Rate limit tercapai. Coba lagi nanti.');
      }
      throw Exception(
        e.response?.data?['error'] ?? 'Gagal memuat data Bitcoin ($statusCode)',
      );
    } catch (e) {
      throw Exception('Gagal memuat data Bitcoin: $e');
    }
  }
}
