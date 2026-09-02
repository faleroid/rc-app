/// In-memory cache service with TTL (Time-To-Live) support.
///
/// Singleton service that stores API responses in memory to avoid
/// redundant network calls when switching between bottom navigation tabs.
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  /// Default TTL: 5 minutes
  static const Duration defaultTtl = Duration(minutes: 5);

  final Map<String, _CacheEntry> _cache = {};

  /// Get cached data by key. Returns null if not found or expired.
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    if (entry.data is T) {
      return entry.data as T;
    }
    return null;
  }

  /// Store data in cache with optional custom TTL.
  void set<T>(String key, T data, {Duration? ttl}) {
    _cache[key] = _CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl ?? defaultTtl),
    );
  }

  /// Invalidate (remove) a specific cache entry.
  void invalidate(String key) {
    _cache.remove(key);
  }

  /// Invalidate all entries matching a prefix.
  /// Useful for clearing all signal caches, all ebook caches, etc.
  void invalidateByPrefix(String prefix) {
    _cache.removeWhere((key, _) => key.startsWith(prefix));
  }

  /// Clear all cached data (e.g., on logout).
  void invalidateAll() {
    _cache.clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}
