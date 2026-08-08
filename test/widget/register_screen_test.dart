import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

/// Mock Register Screen Widget untuk Widget Testing
class MockRegisterScreenWidget extends StatefulWidget {
  final bool simulateSuccess;
  const MockRegisterScreenWidget({super.key, this.simulateSuccess = true});

  @override
  State<MockRegisterScreenWidget> createState() => _MockRegisterScreenWidgetState();
}

class _MockRegisterScreenWidgetState extends State<MockRegisterScreenWidget> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  void _validateAndRegister() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Nama tidak boleh kosong');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Email tidak boleh kosong');
      return;
    }
    if (!_emailController.text.contains('@')) {
      setState(() => _emailError = 'Format email tidak valid');
      return;
    }
    if (_passwordController.text.length < 8) {
      setState(() => _passwordError = 'Password minimal 8 karakter');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _confirmPasswordError = 'Konfirmasi password tidak cocok');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (widget.simulateSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Scaffold(body: Text('MainScreen'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('name_field'),
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Nama Lengkap', errorText: _nameError),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('email_field'),
              controller: _emailController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Email', errorText: _emailError),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('password_field'),
              controller: _passwordController,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Password', errorText: _passwordError),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('confirm_password_field'),
              controller: _confirmPasswordController,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                errorText: _confirmPasswordError,
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator(key: Key('register_loading'))
                : ElevatedButton(
                    key: const Key('register_btn'),
                    onPressed: _validateAndRegister,
                    child: const Text('Daftar'),
                  ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('3. REGISTER SCREEN WIDGET TESTS', () {
    testWidgets('Form register menampilkan semua field yang diperlukan', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockRegisterScreenWidget()));

      expect(find.byKey(const Key('name_field')), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_field')), findsOneWidget);
      expect(find.byKey(const Key('register_btn')), findsOneWidget);
      expect(find.text('Daftar Akun Baru'), findsOneWidget);
    });

    testWidgets('Validasi field kosong (nama) menampilkan pesan error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockRegisterScreenWidget()));

      // Tap register tanpa mengisi field
      await tester.tap(find.byKey(const Key('register_btn')));
      await tester.pump();

      expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('Validasi field kosong (email) menampilkan pesan error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockRegisterScreenWidget()));

      await tester.enterText(find.byKey(const Key('name_field')), 'Budi Trader');
      await tester.pump();

      await tester.tap(find.byKey(const Key('register_btn')));
      await tester.pump();

      expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('Konfirmasi password tidak cocok → tampilkan error', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockRegisterScreenWidget()));

      await tester.enterText(find.byKey(const Key('name_field')), 'Budi Trader');
      await tester.enterText(find.byKey(const Key('email_field')), 'budi@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'DifferentPass!');
      await tester.pump();

      await tester.tap(find.byKey(const Key('register_btn')));
      await tester.pump();

      expect(find.text('Konfirmasi password tidak cocok'), findsOneWidget);
    });

    testWidgets('Loading indicator muncul saat proses registrasi', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockRegisterScreenWidget()));

      await tester.enterText(find.byKey(const Key('name_field')), 'Budi Trader');
      await tester.enterText(find.byKey(const Key('email_field')), 'budi@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'Password123!');
      await tester.pump();

      await tester.tap(find.byKey(const Key('register_btn')));
      await tester.pump();

      expect(find.byKey(const Key('register_loading')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('Navigasi ke MainScreen setelah registrasi berhasil', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const MockRegisterScreenWidget(simulateSuccess: true)));

      await tester.enterText(find.byKey(const Key('name_field')), 'Budi Trader');
      await tester.enterText(find.byKey(const Key('email_field')), 'budi@ricocapital.id');
      await tester.enterText(find.byKey(const Key('password_field')), 'Password123!');
      await tester.enterText(find.byKey(const Key('confirm_password_field')), 'Password123!');
      await tester.pump();

      await tester.tap(find.byKey(const Key('register_btn')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('MainScreen'), findsOneWidget);
    });
  });
}
