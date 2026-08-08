import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

/// Mock MainScreen yang merender Bottom Navigation berbeda
/// berdasarkan status subscription user.
class MockMainScreen extends StatefulWidget {
  final bool isSubscribed;
  final String userName;
  const MockMainScreen({
    super.key,
    required this.isSubscribed,
    this.userName = 'RicoCapital',
  });

  @override
  State<MockMainScreen> createState() => _MockMainScreenState();
}

class _MockMainScreenState extends State<MockMainScreen> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _buildNavItems() {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    ];

    if (widget.isSubscribed) {
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'));
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Modul'));
    }

    items.addAll([
      const BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Paket VIP'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: FlutterLogo(key: Key('app_logo')),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: Text('Home Screen Content')),
          if (widget.isSubscribed) const Center(child: Text('News Screen Content')),
          if (widget.isSubscribed) const Center(child: Text('Modul Screen Content')),
          const Center(child: Text('Paket VIP Screen Content')),
          const Center(child: Text('Profile Screen Content')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: const Key('bottom_nav_bar'),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _buildNavItems(),
      ),
    );
  }
}

void main() {
  group('4. MAIN SCREEN WIDGET TESTS (setelah login)', () {
    testWidgets('User BELUM subscribe: menu News & Modul TIDAK muncul di bottom nav', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: false)));

      // Harus ada
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Paket VIP'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Harus TIDAK ada
      expect(find.text('News'), findsNothing);
      expect(find.text('Modul'), findsNothing);
    });

    testWidgets('User SUDAH subscribe: menu News & Modul MUNCUL di bottom nav', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: true)));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('News'), findsOneWidget);
      expect(find.text('Modul'), findsOneWidget);
      expect(find.text('Paket VIP'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Tab Home selalu muncul untuk semua user', (WidgetTester tester) async {
      // Non-subscriber
      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: false)));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Home Screen Content'), findsOneWidget);

      // Subscriber
      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: true)));
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Tab Profile selalu muncul untuk semua user', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: false)));
      expect(find.text('Profile'), findsOneWidget);

      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: true)));
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('AppBar menampilkan nama/logo aplikasi dengan benar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockMainScreen(isSubscribed: false)));

      expect(find.text('RicoCapital'), findsOneWidget);
      expect(find.byKey(const Key('app_logo')), findsOneWidget);
    });
  });
}
