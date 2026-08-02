// ─── ASSETS — GAMBAR ─────────────────────────────────────────
class AppImages {
  AppImages._();

  static const String _base = 'assets/images/';

  static const String logo            = '${_base}logo.png';
  static const String logoWhite       = '${_base}logo_white.png';

  // Hero / Banner
  static const String heroBanner      = '${_base}hero_banner.png';

  // Modul Ebook thumbnails (ganti path sesuai asset sebenarnya)
  static const String modulEbook1     = '${_base}modul_ebook_1.png';
  static const String modulEbook2     = '${_base}modul_ebook_2.png';
  static const String modulEbook3     = '${_base}modul_ebook_3.png';
  static const String modulEbook4     = '${_base}modul_ebook_4.png';

  // Testimonial
  static const String testimoniPlaceholder = '${_base}testimoni_placeholder.png';

  // Founder / Info
  static const String founderImage    = '${_base}founder.png';

  // Avatar placeholder
  static const String avatarDefault   = '${_base}avatar_default.png';

  // Sosial media
  static const String iconTelegram    = '${_base}ic_telegram.png';
  static const String iconInstagram   = '${_base}ic_instagram.png';
  static const String iconYoutube     = '${_base}ic_youtube.png';
  static const String iconTiktok      = '${_base}ic_tiktok.png';
}

// ─── ASSETS — VIDEO ──────────────────────────────────────────
class AppVideos {
  AppVideos._();

  static const String _base = 'assets/videos/';

  static const String introVideo      = '${_base}intro.mp4';
  static const String tradingDemo     = '${_base}trading_demo.mp4';
}

// ─── ASSETS — ICON (SVG/PNG custom) ─────────────────────────
class AppIcons {
  AppIcons._();

  static const String _base = 'assets/icons/';

  static const String iconHome        = '${_base}ic_home.svg';
  static const String iconModul       = '${_base}ic_modul.svg';
  static const String iconAI          = '${_base}ic_ai.svg';
  static const String iconNotif       = '${_base}ic_notif.svg';
  static const String iconSignal      = '${_base}ic_signal.svg';
}

// ─── URL / LINK EKSTERNAL ────────────────────────────────────
class AppLinks {
  AppLinks._();

  static const String telegramGroup   = 'https://t.me/ricocapital';
  static const String instagram       = 'https://instagram.com/ricocapital';
  static const String youtube         = 'https://www.youtube.com/@ricocapitaledu';
  static const String tiktok          = 'https://tiktok.com/@ricocapital';
  static const String website         = 'https://ricocapital.id';
}

// ─── DURASI ANIMASI ──────────────────────────────────────────
class AppDurations {
  AppDurations._();

  static const Duration fast    = Duration(milliseconds: 200);
  static const Duration normal  = Duration(milliseconds: 350);
  static const Duration slow    = Duration(milliseconds: 500);
}
