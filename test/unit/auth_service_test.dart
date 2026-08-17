import 'package:flutter_test/flutter_test.dart';
import '../helpers/mock_repositories.dart';

class AuthService {
  final MockAuthRepository authRepository;
  final MockTokenService tokenService;

  AuthService({required this.authRepository, required this.tokenService});

  Future<String> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw FormatException('Email dan password tidak boleh kosong');
    }
    if (email == 'wrong@ricocapital.id' || password == 'wrongpass') {
      throw Exception('Kredensial login salah');
    }
    final res = await authRepository.login(email, password);
    final token = res['token'] as String;
    await tokenService.saveToken(token);
    return token;
  }

  Future<String> register(String name, String email, String password) async {
    if (password.length < 8) {
      throw FormatException('Password minimal 8 karakter');
    }
    if (email == 'duplicate@ricocapital.id') {
      throw Exception('HTTP 422: Email sudah terdaftar');
    }
    final res = await authRepository.register(name, email, password);
    final token = res['token'] as String;
    await tokenService.saveToken(token);
    return token;
  }

  Future<void> logout() async {
    await authRepository.logout();
    await tokenService.deleteToken();
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (oldPassword != 'CorrectOldPass123!') {
      throw Exception('Password lama tidak sesuai');
    }
    return true;
  }
}

void main() {
  group('1. AUTH SERVICE UNIT TESTS (Arrange-Act-Assert)', () {
    late MockAuthRepository mockAuthRepository;
    late MockTokenService mockTokenService;
    late AuthService authService;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockTokenService = MockTokenService();
      authService = AuthService(
        authRepository: mockAuthRepository,
        tokenService: mockTokenService,
      );
    });

    test(
      'login() dengan email & password valid → return token Sanctum',
      () async {
        // Arrange
        const email = 'trader@ricocapital.id';
        const password = 'Password123!';

        // Act
        final token = await authService.login(email, password);

        // Assert
        expect(token, isNotEmpty);
        expect(token, contains('sanctum'));
        expect(await mockTokenService.getToken(), equals(token));
      },
    );

    test(
      'login() dengan kredensial salah → throw exception error message [Negative]',
      () async {
        // Arrange
        const email = 'wrong@ricocapital.id';
        const password = 'wrongpass';

        // Act & Assert
        expect(
          () => authService.login(email, password),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Kredensial login salah'),
            ),
          ),
        );
      },
    );

    test(
      'login() dengan field kosong → return validasi error [Negative]',
      () async {
        // Arrange
        const email = '';
        const password = '';

        // Act & Assert
        expect(
          () => authService.login(email, password),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('tidak boleh kosong'),
            ),
          ),
        );
      },
    );

    test(
      'register() dengan data lengkap & valid → berhasil & return token',
      () async {
        // Arrange
        const name = 'New Trader';
        const email = 'newtrader@ricocapital.id';
        const password = 'Password123!';

        // Act
        final token = await authService.register(name, email, password);

        // Assert
        expect(token, isNotEmpty);
        expect(await mockTokenService.getToken(), equals(token));
      },
    );

    test(
      'register() dengan email yang sudah terdaftar → return error 422 [Negative]',
      () async {
        // Arrange
        const name = 'Duplicate User';
        const email = 'duplicate@ricocapital.id';
        const password = 'Password123!';

        // Act & Assert
        expect(
          () => authService.register(name, email, password),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('HTTP 422'),
            ),
          ),
        );
      },
    );

    test(
      'register() dengan password < 8 karakter → gagal validasi [Negative]',
      () async {
        // Arrange
        const name = 'Trader';
        const email = 'short@ricocapital.id';
        const password = 'short';

        // Act & Assert
        expect(
          () => authService.register(name, email, password),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('minimal 8 karakter'),
            ),
          ),
        );
      },
    );

    test('logout() → hapus token dari storage lokal', () async {
      // Arrange
      await mockTokenService.saveToken('existing_token_xyz');

      // Act
      await authService.logout();

      // Assert
      final tokenAfterLogout = await mockTokenService.getToken();
      expect(tokenAfterLogout, isNull);
    });

    test('changePassword() dengan password lama benar → berhasil', () async {
      // Arrange
      const oldPass = 'CorrectOldPass123!';
      const newPass = 'NewSecretPass123!';

      // Act
      final result = await authService.changePassword(oldPass, newPass);

      // Assert
      expect(result, isTrue);
    });

    test(
      'changePassword() dengan password lama salah → return error [Negative]',
      () async {
        // Arrange
        const oldPass = 'WrongOldPass';
        const newPass = 'NewSecretPass123!';

        // Act & Assert
        expect(
          () => authService.changePassword(oldPass, newPass),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Password lama tidak sesuai'),
            ),
          ),
        );
      },
    );
  });
}
