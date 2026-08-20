import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/widget_test_helper.dart';

/// Mock Profile Page Widget
class MockProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final bool isSubscribed;
  final String? expiresAt;
  final VoidCallback? onLogout;

  const MockProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.isSubscribed = false,
    this.expiresAt,
    this.onLogout,
  });

  @override
  State<MockProfilePage> createState() => _MockProfilePageState();
}

class _MockProfilePageState extends State<MockProfilePage> {
  bool _showChangePassword = false;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmError;

  void _submitChangePassword() {
    setState(() {
      _oldPasswordError = null;
      _newPasswordError = null;
      _confirmError = null;
    });

    if (_oldPasswordController.text.trim().isEmpty) {
      setState(() => _oldPasswordError = 'Password lama tidak boleh kosong');
      return;
    }
    if (_newPasswordController.text.length < 8) {
      setState(() => _newPasswordError = 'Password baru minimal 8 karakter');
      return;
    }
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      setState(() => _confirmError = 'Konfirmasi password tidak cocok');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        key: Key('password_success_snackbar'),
        content: Text('Password berhasil diubah'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- User Info ---
            Text(
              widget.userName,
              key: const Key('profile_name'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.userEmail,
              key: const Key('profile_email'),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // --- Subscription Status ---
            Container(
              key: const Key('subscription_status_card'),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isSubscribed
                    ? Colors.green.shade800
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isSubscribed
                        ? 'VIP Member Aktif'
                        : 'Belum Berlangganan',
                    key: const Key('subscription_label'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.isSubscribed && widget.expiresAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Berlaku hingga ${widget.expiresAt}',
                        key: const Key('expires_at_text'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- Ganti Password Section ---
            OutlinedButton(
              key: const Key('toggle_change_password_btn'),
              onPressed: () =>
                  setState(() => _showChangePassword = !_showChangePassword),
              child: Text(
                _showChangePassword
                    ? 'Sembunyikan Ganti Password'
                    : 'Ganti Password',
              ),
            ),
            if (_showChangePassword) ...[
              const SizedBox(height: 12),
              TextField(
                key: const Key('old_password_field'),
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  errorText: _oldPasswordError,
                ),
              ),
              TextField(
                key: const Key('new_password_field'),
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  errorText: _newPasswordError,
                ),
              ),
              TextField(
                key: const Key('confirm_new_password_field'),
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  errorText: _confirmError,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                key: const Key('submit_change_password_btn'),
                onPressed: _submitChangePassword,
                child: const Text('Simpan Password Baru'),
              ),
            ],
            const SizedBox(height: 24),

            // --- Logout ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const Key('logout_btn'),
                onPressed: () {
                  widget.onLogout?.call();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const Scaffold(body: Text('LoginScreen')),
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('7. HALAMAN PROFIL WIDGET TESTS', () {
    testWidgets('Nama dan email user ditampilkan dengan benar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MockProfilePage(
            userName: 'Siti VIP Trader',
            userEmail: 'siti.vip@ricocapital.id',
          ),
        ),
      );

      expect(find.byKey(const Key('profile_name')), findsOneWidget);
      expect(find.text('Siti VIP Trader'), findsOneWidget);
      expect(find.byKey(const Key('profile_email')), findsOneWidget);
      expect(find.text('siti.vip@ricocapital.id'), findsOneWidget);
    });

    testWidgets('Status subscription aktif ditampilkan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MockProfilePage(
            userName: 'Siti',
            userEmail: 'siti@rc.id',
            isSubscribed: true,
            expiresAt: '2026-09-01',
          ),
        ),
      );

      expect(find.byKey(const Key('subscription_label')), findsOneWidget);
      expect(find.text('VIP Member Aktif'), findsOneWidget);
    });

    testWidgets('Status subscription tidak aktif ditampilkan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MockProfilePage(
            userName: 'Andi',
            userEmail: 'andi@rc.id',
            isSubscribed: false,
          ),
        ),
      );

      expect(find.text('Belum Berlangganan'), findsOneWidget);
    });

    testWidgets('Tanggal expired subscription ditampilkan jika aktif', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MockProfilePage(
            userName: 'Siti',
            userEmail: 'siti@rc.id',
            isSubscribed: true,
            expiresAt: '2026-09-01',
          ),
        ),
      );

      expect(find.byKey(const Key('expires_at_text')), findsOneWidget);
      expect(find.text('Berlaku hingga 2026-09-01'), findsOneWidget);
    });

    testWidgets(
      'Form ganti password muncul dengan field password lama & baru',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            const MockProfilePage(userName: 'Siti', userEmail: 'siti@rc.id'),
          ),
        );

        // Form belum muncul
        expect(find.byKey(const Key('old_password_field')), findsNothing);

        // Tap toggle button
        await tester.tap(find.byKey(const Key('toggle_change_password_btn')));
        await tester.pumpAndSettle();

        // Form muncul
        expect(find.byKey(const Key('old_password_field')), findsOneWidget);
        expect(find.byKey(const Key('new_password_field')), findsOneWidget);
        expect(
          find.byKey(const Key('confirm_new_password_field')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('submit_change_password_btn')),
          findsOneWidget,
        );
      },
    );

    testWidgets('Validasi form ganti password — field kosong', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MockProfilePage(userName: 'Siti', userEmail: 'siti@rc.id'),
        ),
      );

      await tester.tap(find.byKey(const Key('toggle_change_password_btn')));
      await tester.pumpAndSettle();

      // Submit tanpa mengisi field
      await tester.tap(find.byKey(const Key('submit_change_password_btn')));
      await tester.pump();

      expect(find.text('Password lama tidak boleh kosong'), findsOneWidget);
    });

    testWidgets(
      'Validasi form ganti password — konfirmasi password tidak cocok',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(
            const MockProfilePage(userName: 'Siti', userEmail: 'siti@rc.id'),
          ),
        );

        await tester.tap(find.byKey(const Key('toggle_change_password_btn')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('old_password_field')),
          'OldPass123!',
        );
        await tester.enterText(
          find.byKey(const Key('new_password_field')),
          'NewPass123!',
        );
        await tester.enterText(
          find.byKey(const Key('confirm_new_password_field')),
          'DifferentPass!',
        );
        await tester.pump();

        await tester.tap(find.byKey(const Key('submit_change_password_btn')));
        await tester.pump();

        expect(find.text('Konfirmasi password tidak cocok'), findsOneWidget);
      },
    );

    testWidgets('Tombol logout ada dan bisa ditekan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MockProfilePage(userName: 'Siti', userEmail: 'siti@rc.id'),
        ),
      );

      expect(find.byKey(const Key('logout_btn')), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets(
      'Setelah logout, navigasi ke LoginScreen dan callback terpanggil',
      (WidgetTester tester) async {
        bool logoutCalled = false;

        await tester.pumpWidget(
          createWidgetUnderTest(
            MockProfilePage(
              userName: 'Siti',
              userEmail: 'siti@rc.id',
              onLogout: () => logoutCalled = true,
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('logout_btn')));
        await tester.pumpAndSettle();

        expect(logoutCalled, isTrue);
        expect(find.text('LoginScreen'), findsOneWidget);
      },
    );
  });
}
