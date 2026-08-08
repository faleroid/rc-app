import 'package:flutter_test/flutter_test.dart';
import '../helpers/mock_repositories.dart';

void main() {
  group('4. TOKEN SERVICE UNIT TESTS (Arrange-Act-Assert)', () {
    late MockTokenService mockTokenService;

    setUp(() {
      mockTokenService = MockTokenService();
    });

    test('simpan token ke storage → tersimpan dengan key yang benar', () async {
      // Arrange
      const newToken = 'sanctum_bearer_token_key_test_123';

      // Act
      await mockTokenService.saveToken(newToken);

      // Assert
      final storedToken = await mockTokenService.getToken();
      expect(storedToken, equals(newToken));
    });

    test('baca token dari storage → return token yang sebelumnya disimpan', () async {
      // Arrange
      const existingToken = 'fake_bearer_token_xyz';

      // Act
      final result = await mockTokenService.getToken();

      // Assert
      expect(result, isNotNull);
      expect(result, equals(existingToken));
    });

    test('hapus token → setelah logout, getToken() harus return null [Negative]', () async {
      // Arrange
      await mockTokenService.saveToken('token_to_be_deleted');

      // Act
      await mockTokenService.deleteToken();

      // Assert
      final tokenAfterDelete = await mockTokenService.getToken();
      expect(tokenAfterDelete, isNull);
    });
  });
}
