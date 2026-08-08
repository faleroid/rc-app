import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

class MockSplashScreen extends StatefulWidget {
  final bool hasToken;
  const MockSplashScreen({super.key, this.hasToken = false});

  @override
  State<MockSplashScreen> createState() => _MockSplashScreenState();
}

class _MockSplashScreenState extends State<MockSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (widget.hasToken) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Scaffold(body: Text('MainScreen'))),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MockOnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('RicoCapital', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class MockOnboardingScreen extends StatefulWidget {
  const MockOnboardingScreen({super.key});

  @override
  State<MockOnboardingScreen> createState() => _MockOnboardingScreenState();
}

class _MockOnboardingScreenState extends State<MockOnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> _pages = [
    'Selamat Datang di RicoCapital Apps',
    'Akses Edukasi Crypto & Market Signal',
    'Tingkatkan Profit Trading Anda Hari Ini',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            key: const Key('skip_btn'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Scaffold(body: Text('LoginScreen'))),
              );
            },
            child: const Text('Skip'),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (idx) => setState(() => _currentPage = idx),
        itemCount: _pages.length,
        itemBuilder: (_, index) => Center(
          child: Text(_pages[index], style: const TextStyle(fontSize: 18)),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          key: const Key('mulai_btn'),
          onPressed: () {
            if (_currentPage == _pages.length - 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Scaffold(body: Text('LoginScreen'))),
              );
            } else {
              _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Text(_currentPage == _pages.length - 1 ? 'Mulai Login' : 'Lanjut'),
        ),
      ),
    );
  }
}

void main() {
  group('1. SPLASH SCREEN & ONBOARDING WIDGET TESTS', () {
    testWidgets('SplashScreen muncul saat aplikasi pertama dibuka', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockSplashScreen(hasToken: false)));

      expect(find.text('RicoCapital'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Animasi/transisi dari SplashScreen ke OnboardingScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockSplashScreen(hasToken: false)));

      expect(find.text('RicoCapital'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Selamat Datang di RicoCapital Apps'), findsOneWidget);
    });

    testWidgets('OnboardingScreen menampilkan halaman onboarding', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockOnboardingScreen()));

      expect(find.text('Selamat Datang di RicoCapital Apps'), findsOneWidget);
      expect(find.byKey(const Key('skip_btn')), findsOneWidget);
      expect(find.byKey(const Key('mulai_btn')), findsOneWidget);
    });

    testWidgets('Tombol Skip di onboarding mengarah ke LoginScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockOnboardingScreen()));

      await tester.tap(find.byKey(const Key('skip_btn')));
      await tester.pumpAndSettle();

      expect(find.text('LoginScreen'), findsOneWidget);
    });

    testWidgets('Jika user sudah pernah login (ada token) → SplashScreen langsung ke MainScreen', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockSplashScreen(hasToken: true)));

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('MainScreen'), findsOneWidget);
    });
  });
}
