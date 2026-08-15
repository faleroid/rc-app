class CryptoWallets {
  // USDT TRC 20
  static const String usdtTrc20Address = 'TREdcYwqfUwbp86Vxyv319AN3Cfachpkaf';
  static const String usdtTrc20Network = 'TRC 20';
  static const String usdtTrc20QrAsset = 'assets/images/wallet/USDT_TRC20.jpeg';

  // USDT BEP 20
  static const String usdtBep20Address = '0x5628a71d252e0d617c5919b545f289177237e12e';
  static const String usdtBep20Network = 'BEP 20';
  static const String usdtBep20QrAsset = 'assets/images/wallet/USDT_BEP20.jpeg';

  // BITCOIN
  static const String bitcoinAddress = '1BmFehufuUarW1YseDw8PHgFqm3avP8ycX';
  static const String bitcoinNetwork = 'Bitcoin';
  static const String bitcoinQrAsset = 'assets/images/wallet/Bitcoin.jpeg';

  // Legacy & Alias Getters
  static const String usdtAddress = usdtTrc20Address;
  static const String usdtNetwork = usdtTrc20Network;
  static const String usdtQrAsset = usdtTrc20QrAsset;

  static const String ethereumAddress = usdtBep20Address;
  static const String ethereumNetwork = usdtBep20Network;
  static const String ethereumQrAsset = usdtBep20QrAsset;
}
