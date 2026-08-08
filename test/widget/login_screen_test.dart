import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

class MockLoginScreenWidget extends StatefulWidget {
  final bool simulateApiError;
  const MockLoginScreenWidget({super.key, this.simulateApiError = false});

  @override
  State<MockLoginScreenWidget> createState() => _MockLoginScreenWidgetState();
}

class _MockLoginScreenWidgetState extends State<MockLoginScreenWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _apiError;
  bool _isLoading = false;

  void _validateAndLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _apiError = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    if (!email.contains('@')) {
      setState(() => _emailError = 'Format email tidak valid');
      return;
    }

    if (password.length < 8) {
      setState(() => _passwordError = 'Password minimal 8 karakter');
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (widget.simulateApiError) {
      setState(() {
        _isLoading = false;
        _apiError = 'Email atau password salah (HTTP 401)';
      });
    } else {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Scaffold(body: Text('MainScreen'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormEmpty = _emailController.text.isEmpty || _passwordController.text.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Login RicoCapital')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('email_field'),
              controller: _emailController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError,
              ),
            ),
            TextField(
              key: const Key('password_field'),
              controller: _passwordController,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordError,
              ),
            ),
            const SizedBox(height: 16),
            if (_apiError != null)
              Text(_apiError!, key: const Key('api_error_text'), style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator(key: Key('loading_indicator'))
                : ElevatedButton(
                    key: const Key('login_btn'),
                    onPressed: isFormEmpty ? null : _validateAndLogin,
                    child: const Text('Masuk'),
                  ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('2. LOGIN SCREEN WIDGET TESTS', () {
    testWidgets('Form login muncul dengan field email & password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget()));

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_btn')), findsOneWidget);
    });

    testWidgets('Tombol Login disabled saat field kosong', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget()));

      final ElevatedButton btn = tester.widget(find.byKey(const Key('login_btn')));
      expect(btn.onPressed, isNull);
    });

    testWidgets('Pesan error muncul saat email format salah', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget()));

      await tester.enterText(find.byKey(const Key('email_field')), 'invalidemail');
      await tester.enterText(find.byKey(const Key('password_field')), '12345678');
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_btn')));
      await tester.pump();

      expect(find.text('Format email tidak valid'), findsOneWidget);
    });

    testWidgets('Pesan error muncul saat password kurang dari 8 karakter', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget()));

      await tester.enterText(find.byKey(const Key('email_field')), 'valid@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_btn')));
      await tester.pump();

      expect(find.text('Password minimal 8 karakter'), findsOneWidget);
    });

    testWidgets('Loading indicator muncul saat proses login berlangsung', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget()));

      await tester.enterText(find.byKey(const Key('email_field')), 'trader@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_btn')));
      await tester.pump(); // Start loading state

      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400)); // Finish loading
    });

    testWidgets('Navigasi ke MainScreen setelah login berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget()));

      await tester.enterText(find.byKey(const Key('email_field')), 'trader@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_btn')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('MainScreen'), findsOneWidget);
    });

    testWidgets('Pesan error dari API ditampilkan dengan benar di UI', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockLoginScreenWidget(simulateApiError: true)));

      await tester.enterText(find.byKey(const Key('email_field')), 'trader@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_btn')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('api_error_text')), findsOneWidget);
      expect(find.text('Email atau password salah (HTTP 401)'), findsOneWidget);
    });
  });
}
