import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

/// Shimmer / Skeleton Loading Widget
class MockShimmerLoading extends StatelessWidget {
  const MockShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (i) => Container(
        key: Key('shimmer_item_$i'),
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
      )),
    );
  }
}

/// Mock page yang menampilkan loading → data / error
class MockDataPage extends StatefulWidget {
  final bool simulateError;
  final bool simulateEmpty;
  const MockDataPage({super.key, this.simulateError = false, this.simulateEmpty = false});

  @override
  State<MockDataPage> createState() => _MockDataPageState();
}

class _MockDataPageState extends State<MockDataPage> {
  bool _isLoading = true;
  bool _hasError = false;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    if (widget.simulateError) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Page')),
      body: _isLoading
          ? const MockShimmerLoading()
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 64, color: Colors.redAccent, key: Key('error_icon')),
                      const SizedBox(height: 16),
                      const Text('Koneksi internet tidak tersedia', key: Key('error_message'),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      const Text('Periksa jaringan Anda dan coba lagi', key: Key('error_subtitle')),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        key: const Key('retry_btn'),
                        onPressed: () {
                          _retryCount++;
                          _loadData();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('Data Loaded Successfully', key: Key('data_content'))),
    );
  }
}

/// Mock Snackbar/Dialog notification page
class MockNotificationPage extends StatelessWidget {
  const MockNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('trigger_success_snackbar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    key: Key('success_snackbar'),
                    content: Text('Pembayaran berhasil! Akses VIP Anda aktif.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Trigger Success'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('trigger_failed_snackbar'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    key: Key('failed_snackbar'),
                    content: Text('Pembayaran gagal. Silakan coba lagi.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Trigger Failed'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('trigger_success_dialog'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    key: const Key('success_dialog'),
                    title: const Text('Transaksi Berhasil'),
                    content: const Text('Selamat! Akun VIP Anda telah aktif.'),
                    actions: [
                      TextButton(
                        key: const Key('dialog_ok_btn'),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Trigger Success Dialog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              key: const Key('trigger_cancel_dialog'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    key: const Key('cancel_dialog'),
                    title: const Text('Transaksi Dibatalkan'),
                    content: const Text('Pembayaran Anda telah dibatalkan.'),
                    actions: [
                      TextButton(
                        key: const Key('dialog_dismiss_btn'),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Trigger Cancel Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('8. ERROR & LOADING STATE WIDGET TESTS', () {
    // --- SHIMMER / LOADING ---
    testWidgets('Shimmer/loading ditampilkan saat data sedang dimuat', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockDataPage()));

      // State awal: loading shimmer
      expect(find.byKey(const Key('shimmer_item_0')), findsOneWidget);
      expect(find.byKey(const Key('shimmer_item_1')), findsOneWidget);
      expect(find.byKey(const Key('shimmer_item_2')), findsOneWidget);

      // Setelah loading selesai
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shimmer_item_0')), findsNothing);
      expect(find.byKey(const Key('data_content')), findsOneWidget);
    });

    // --- ERROR STATE ---
    testWidgets('Pesan error muncul saat koneksi internet tidak tersedia', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockDataPage(simulateError: true)));

      // Tunggu loading
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_icon')), findsOneWidget);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Koneksi internet tidak tersedia'), findsOneWidget);
      expect(find.byKey(const Key('error_subtitle')), findsOneWidget);
    });

    // --- RETRY BUTTON ---
    testWidgets('Tombol Coba Lagi muncul saat terjadi error dan bisa ditekan', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockDataPage(simulateError: true)));

      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('retry_btn')), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);

      // Tap retry
      await tester.tap(find.byKey(const Key('retry_btn')));
      await tester.pump();

      // Loading shimmer kembali muncul (retry triggered)
      expect(find.byKey(const Key('shimmer_item_0')), findsOneWidget);

      // Flush pending timer dari Future.delayed agar tidak bocor
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
    });

    // --- SNACKBAR SUCCESS ---
    testWidgets('Snackbar notifikasi muncul setelah transaksi berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockNotificationPage()));

      await tester.tap(find.byKey(const Key('trigger_success_snackbar')));
      await tester.pump();

      expect(find.text('Pembayaran berhasil! Akses VIP Anda aktif.'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    // --- SNACKBAR FAILED ---
    testWidgets('Snackbar notifikasi muncul setelah transaksi gagal/cancel', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockNotificationPage()));

      await tester.tap(find.byKey(const Key('trigger_failed_snackbar')));
      await tester.pump();

      expect(find.text('Pembayaran gagal. Silakan coba lagi.'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    // --- DIALOG SUCCESS ---
    testWidgets('Dialog notifikasi muncul setelah transaksi berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockNotificationPage()));

      await tester.tap(find.byKey(const Key('trigger_success_dialog')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('success_dialog')), findsOneWidget);
      expect(find.text('Transaksi Berhasil'), findsOneWidget);
      expect(find.text('Selamat! Akun VIP Anda telah aktif.'), findsOneWidget);

      // Dismiss
      await tester.tap(find.byKey(const Key('dialog_ok_btn')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('success_dialog')), findsNothing);
    });

    // --- DIALOG CANCEL ---
    testWidgets('Dialog notifikasi muncul setelah transaksi dibatalkan', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockNotificationPage()));

      await tester.tap(find.byKey(const Key('trigger_cancel_dialog')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('cancel_dialog')), findsOneWidget);
      expect(find.text('Transaksi Dibatalkan'), findsOneWidget);
      expect(find.text('Pembayaran Anda telah dibatalkan.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('dialog_dismiss_btn')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('cancel_dialog')), findsNothing);
    });
  });
}
