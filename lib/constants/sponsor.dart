
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
    SponsorItem(
      name: 'Belmawa',
      logoUrl: 'https://www.ricocapital.id/images/supported/belmawa.png',
    ),
    SponsorItem(
      name: 'Dikti Saintek',
      logoUrl: 'https://www.ricocapital.id/images/supported/dikti.png',
    ),
    SponsorItem(
      name: 'P2MW',
      logoUrl: 'https://www.ricocapital.id/images/supported/p2mw.png',
    ),
    SponsorItem(
      name: 'Tut Wuri Handayani',
      logoUrl: 'https://www.ricocapital.id/images/supported/tutwuri.png',
    ),
    SponsorItem(
      name: 'Unsoed',
      logoUrl: 'https://www.ricocapital.id/images/supported/unsoed.png',
    ),
  ];
}