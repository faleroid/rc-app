
// ─── DATA SPONSOR GRID (STATIC) ──────────────────────────────
/// Daftar logo sponsor untuk grid statis "SUPPORTED BY" (Part 1).
/// Setiap entry berisi nama dan URL logo. Tambahkan entry baru untuk
/// menambah logo di grid.
class SponsorItem {
  final String name;
  final String? logoUrl; // null = tampilkan nama teks saja

  const SponsorItem({required this.name, this.logoUrl});
}

class AppSponsors {
  AppSponsors._();

  static const List<SponsorItem> gridSponsors = [
    // ── Row 1 (Top — 3 items) ──
    SponsorItem(name: 'Binance Labs'),   // ← Tambahkan logoUrl: 'https://...' nanti
    SponsorItem(name: 'Bloomberg'),
    SponsorItem(name: 'Bybit'),
    // ── Row 2 (Bottom — 2 items, centered) ──
    SponsorItem(name: 'CoinMarketCap'),
    SponsorItem(name: 'LunarCrush'),
  ];
}