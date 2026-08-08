import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';
import '../helpers/test_fixtures.dart';

/// Status badge builder untuk setiap status transaksi
class TransactionStatusBadge extends StatelessWidget {
  final String status;
  const TransactionStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color bgColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'settlement':
      case 'success':
      case 'paid':
        label = 'Berhasil';
        bgColor = Colors.green;
        break;
      case 'pending':
        label = 'Menunggu';
        bgColor = Colors.amber;
        textColor = Colors.black87;
        break;
      case 'expire':
      case 'expired':
        label = 'Kedaluwarsa';
        bgColor = Colors.grey;
        break;
      case 'cancel':
      case 'deny':
        label = 'Dibatalkan';
        bgColor = Colors.red;
        break;
      default:
        label = 'Unknown';
        bgColor = Colors.blueGrey;
    }

    return Container(
      key: Key('badge_$status'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

/// Mock Transaction History Page
class MockTransactionHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  const MockTransactionHistoryPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Riwayat Transaksi')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey, key: Key('empty_icon')),
              SizedBox(height: 16),
              Text('Belum Ada Transaksi', key: Key('empty_title'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Riwayat transaksi Anda akan muncul di sini setelah melakukan pembayaran.',
                  key: Key('empty_description'), textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return ListTile(
            key: Key('transaction_item_$index'),
            title: Text('${tx["package_name"]} - ${tx["order_id"]}'),
            subtitle: Text('${tx["payment_method"]} • ${tx["created_at"]}'),
            trailing: TransactionStatusBadge(status: tx['status']),
          );
        },
      ),
    );
  }
}

void main() {
  group('6. HALAMAN RIWAYAT TRANSAKSI WIDGET TESTS', () {
    testWidgets('Daftar transaksi ditampilkan dengan status yang benar', (WidgetTester tester) async {
      final transactions = fakeTransactionList();
      await tester.pumpWidget(createWidgetUnderTest(MockTransactionHistoryPage(transactions: transactions)));

      expect(find.text('Riwayat Transaksi'), findsOneWidget);
      expect(find.byKey(const Key('transaction_item_0')), findsOneWidget);
      expect(find.byKey(const Key('transaction_item_1')), findsOneWidget);
      expect(find.byKey(const Key('transaction_item_2')), findsOneWidget);
      expect(find.byKey(const Key('transaction_item_3')), findsOneWidget);
    });

    testWidgets('Status settlement ditampilkan dengan label & warna Berhasil (hijau)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MockTransactionHistoryPage(transactions: [
          {'package_name': 'Pro Plan', 'order_id': 'RC-001', 'payment_method': 'BCA', 'status': 'settlement', 'created_at': '2026-08-01'},
        ]),
      ));

      expect(find.text('Berhasil'), findsOneWidget);
      final Container badge = tester.widget(find.byKey(const Key('badge_settlement')));
      final BoxDecoration decoration = badge.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.green));
    });

    testWidgets('Status pending ditampilkan dengan label & warna Menunggu (kuning)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MockTransactionHistoryPage(transactions: [
          {'package_name': 'VIP', 'order_id': 'RC-002', 'payment_method': 'GoPay', 'status': 'pending', 'created_at': '2026-08-08'},
        ]),
      ));

      expect(find.text('Menunggu'), findsOneWidget);
      final Container badge = tester.widget(find.byKey(const Key('badge_pending')));
      final BoxDecoration decoration = badge.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.amber));
    });

    testWidgets('Status expire ditampilkan dengan label & warna Kedaluwarsa (abu)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MockTransactionHistoryPage(transactions: [
          {'package_name': 'Starter', 'order_id': 'RC-003', 'payment_method': 'CC', 'status': 'expire', 'created_at': '2026-07-15'},
        ]),
      ));

      expect(find.text('Kedaluwarsa'), findsOneWidget);
      final Container badge = tester.widget(find.byKey(const Key('badge_expire')));
      final BoxDecoration decoration = badge.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.grey));
    });

    testWidgets('Status cancel ditampilkan dengan label & warna Dibatalkan (merah)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MockTransactionHistoryPage(transactions: [
          {'package_name': 'Pro', 'order_id': 'RC-004', 'payment_method': 'OVO', 'status': 'cancel', 'created_at': '2026-07-10'},
        ]),
      ));

      expect(find.text('Dibatalkan'), findsOneWidget);
      final Container badge = tester.widget(find.byKey(const Key('badge_cancel')));
      final BoxDecoration decoration = badge.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.red));
    });

    testWidgets('Saat daftar transaksi kosong → tampilkan empty state yang informatif', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MockTransactionHistoryPage(transactions: []),
      ));

      expect(find.byKey(const Key('empty_icon')), findsOneWidget);
      expect(find.byKey(const Key('empty_title')), findsOneWidget);
      expect(find.text('Belum Ada Transaksi'), findsOneWidget);
      expect(find.byKey(const Key('empty_description')), findsOneWidget);
    });
  });
}
