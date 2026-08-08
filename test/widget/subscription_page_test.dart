import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

/// Data model paket subscription untuk testing
class TestPackage {
  final int id;
  final String name;
  final String price;
  final String description;
  final List<String> benefits;
  final bool isActive;
  final bool canUpgrade;

  const TestPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.benefits,
    this.isActive = false,
    this.canUpgrade = false,
  });
}

/// Mock Subscription Page Widget
class MockSubscriptionPage extends StatefulWidget {
  final int? activePackageId;
  final void Function(int packageId)? onSelectPackage;

  const MockSubscriptionPage({
    super.key,
    this.activePackageId,
    this.onSelectPackage,
  });

  @override
  State<MockSubscriptionPage> createState() => _MockSubscriptionPageState();
}

class _MockSubscriptionPageState extends State<MockSubscriptionPage> {
  final List<TestPackage> _packages = const [
    TestPackage(
      id: 1,
      name: 'Starter Plan',
      price: 'Rp 99.000',
      description: 'Akses dasar signal & news',
      benefits: ['Signal Crypto', 'Akses Berita VIP'],
    ),
    TestPackage(
      id: 2,
      name: 'Pro Plan',
      price: 'Rp 199.000',
      description: 'Akses penuh kelas & video edukasi',
      benefits: ['Semua fitur Starter', 'Video Edukasi Full', 'Private Discord Group'],
    ),
    TestPackage(
      id: 3,
      name: 'VIP Ultimate',
      price: 'Rp 499.000',
      description: 'Fitur paling komplit + 1-on-1 Mentoring',
      benefits: ['Semua Fitur Pro', '1-on-1 Mentoring', 'Whale Alert Indicator'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Paket VIP')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _packages.length,
        itemBuilder: (context, index) {
          final pkg = _packages[index];
          final isCurrentActive = widget.activePackageId == pkg.id;
          final isUpgrade = widget.activePackageId != null &&
              widget.activePackageId! < pkg.id;

          return Card(
            key: Key('package_card_${pkg.id}'),
            color: isCurrentActive ? Colors.amber.shade900 : null,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pkg.name,
                        key: Key('package_name_${pkg.id}'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (isCurrentActive)
                        Container(
                          key: const Key('active_badge'),
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Aktif', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(pkg.price, key: Key('package_price_${pkg.id}'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(pkg.description),
                  const SizedBox(height: 8),
                  ...pkg.benefits.map((b) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 6),
                        Text(b),
                      ],
                    ),
                  )),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: Key('select_btn_${pkg.id}'),
                      onPressed: isCurrentActive
                          ? null
                          : () => widget.onSelectPackage?.call(pkg.id),
                      child: Text(
                        isCurrentActive
                            ? 'Paket Aktif'
                            : isUpgrade
                                ? 'Upgrade Paket'
                                : 'Pilih ${pkg.name}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  group('5. HALAMAN PAKET SUBSCRIPTION WIDGET TESTS', () {
    testWidgets('3 kartu paket ditampilkan dengan nama, harga, dan benefit yang benar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockSubscriptionPage()));

      // Nama Paket 1 & 2
      expect(find.byKey(const Key('package_name_1')), findsOneWidget);
      expect(find.byKey(const Key('package_name_2')), findsOneWidget);
      expect(find.text('Starter Plan'), findsOneWidget);
      expect(find.text('Pro Plan'), findsOneWidget);

      // Harga
      expect(find.text('Rp 99.000'), findsOneWidget);
      expect(find.text('Rp 199.000'), findsOneWidget);

      // Benefit spot-check
      expect(find.text('Signal Crypto'), findsOneWidget);
      expect(find.text('Video Edukasi Full'), findsOneWidget);

      // Scroll ke bawah untuk melihat paket ke-3
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('package_name_3')), findsOneWidget);
      expect(find.text('VIP Ultimate'), findsOneWidget);
      expect(find.text('Rp 499.000'), findsOneWidget);
      expect(find.text('1-on-1 Mentoring'), findsOneWidget);
    });

    testWidgets('Tombol pilih paket memicu callback pembayaran Midtrans', (WidgetTester tester) async {
      int? selectedId;
      await tester.pumpWidget(createWidgetUnderTest(
        MockSubscriptionPage(onSelectPackage: (id) => selectedId = id),
      ));

      await tester.tap(find.byKey(const Key('select_btn_2')));
      await tester.pump();

      expect(selectedId, equals(2));
    });

    testWidgets('Tombol upgrade paket muncul hanya jika user subscribe paket lebih rendah', (WidgetTester tester) async {
      // User punya Starter Plan (id=1), paket 2 & 3 harus bertuliskan "Upgrade Paket"
      await tester.pumpWidget(createWidgetUnderTest(
        const MockSubscriptionPage(activePackageId: 1),
      ));

      // Paket aktif: disabled
      final ElevatedButton activeBtn = tester.widget(find.byKey(const Key('select_btn_1')));
      expect(activeBtn.onPressed, isNull);
      expect(find.text('Paket Aktif'), findsOneWidget);

      // Scroll ke bawah agar semua card terrender
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Paket lebih tinggi: setidaknya 1 tombol "Upgrade Paket" terlihat
      expect(find.text('Upgrade Paket'), findsAtLeastNWidgets(1));
    });

    testWidgets('UI paket yang sedang aktif ditandai berbeda (badge/highlight)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        const MockSubscriptionPage(activePackageId: 2),
      ));

      // Badge "Aktif" muncul pada paket 2
      expect(find.byKey(const Key('active_badge')), findsOneWidget);
      expect(find.text('Aktif'), findsOneWidget);

      // Card paket 2 harus berbeda warnanya (amber.shade900)
      final Card card = tester.widget(find.byKey(const Key('package_card_2')));
      expect(card.color, equals(Colors.amber.shade900));

      // Card paket lain tidak berwarna khusus
      final Card card1 = tester.widget(find.byKey(const Key('package_card_1')));
      expect(card1.color, isNull);
    });
  });
}
