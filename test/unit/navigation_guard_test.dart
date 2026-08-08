import 'package:flutter_test/flutter_test.dart';

class NavigationGuard {
  bool isLoggedIn;
  bool isSubscribed;

  NavigationGuard({this.isLoggedIn = false, this.isSubscribed = false});

  String navigateTo(String targetRoute) {
    if (!isLoggedIn) {
      return '/login';
    }

    if (targetRoute == '/news' || targetRoute == '/modules' || targetRoute == '/academy-detail') {
      if (!isSubscribed) {
        return '/paywall'; // Locked content redirect
      }
    }

    return targetRoute;
  }

  List<String> getAvailableMenuItems() {
    if (!isLoggedIn) return ['/login', '/register'];

    final baseMenus = ['Home', 'Paket VIP', 'Profile'];
    if (isSubscribed) {
      return [...baseMenus, 'News', 'Modul & Video'];
    }
    return baseMenus;
  }
}

void main() {
  group('5. NAVIGATION GUARD UNIT TESTS (Arrange-Act-Assert)', () {
    test('user belum login mencoba akses halaman utama → harus redirect ke LoginScreen', () {
      // Arrange
      final guard = NavigationGuard(isLoggedIn: false, isSubscribed: false);

      // Act
      final destination = guard.navigateTo('/main');

      // Assert
      expect(destination, equals('/login'));
    });

    test('user sudah login tapi belum subscribe → menu News & Modul tidak boleh muncul [Negative]', () {
      // Arrange
      final guard = NavigationGuard(isLoggedIn: true, isSubscribed: false);

      // Act
      final menuItems = guard.getAvailableMenuItems();
      final destinationNews = guard.navigateTo('/news');

      // Assert
      expect(menuItems, contains('Home'));
      expect(menuItems, contains('Paket VIP'));
      expect(menuItems, contains('Profile'));
      expect(menuItems, isNot(contains('News')));
      expect(menuItems, isNot(contains('Modul & Video')));
      expect(destinationNews, equals('/paywall'));
    });

    test('user sudah subscribe → menu News & Modul harus muncul', () {
      // Arrange
      final guard = NavigationGuard(isLoggedIn: true, isSubscribed: true);

      // Act
      final menuItems = guard.getAvailableMenuItems();
      final destinationNews = guard.navigateTo('/news');
      final destinationModules = guard.navigateTo('/modules');

      // Assert
      expect(menuItems, contains('News'));
      expect(menuItems, contains('Modul & Video'));
      expect(destinationNews, equals('/news'));
      expect(destinationModules, equals('/modules'));
    });
  });
}
