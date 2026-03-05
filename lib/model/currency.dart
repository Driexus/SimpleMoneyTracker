enum Currency {
  euro("euro", "Euro", "€"),
  dollar("dollar", "USD", "\$"),
  yen("yen", "Yen", "¥"),
  pound("pound", "Pound Sterling", "£"),
  yuan("yuan", "Chinese Renminbi", "¥"),
  franc("franc", "Swiss Franc", "Fr."),
  inr("inr", "Indian Rupee", "₹"),
  krw("krw", "South Korean Won", "₩"),
  sek("sek", "Krone", "kr"),
  zar("zar", "South African Rand", "R"),
  pln("pln", "Polish Złoty", "zł"),
  idr("idr", "Indonesian Rupiah", "Rp"),
  tryLira("try", "Turkish Lira", "₺"),
  thb("thb", "Thai Baht", "฿"),
  ils("ils", "Israeli New Shekel", "₪"),
  huf("huf", "Hungarian Forint", "Ft"),
  czk("czk", "Czech Koruna", "Kč"),
  php("php", "Philippine Peso", "₱"),
  btc("btc", "Bitcoin", "₿"),;

  final String code;
  final String title;
  final String symbol;

  const Currency(this.code, this.title, this.symbol);

  /// Look up currency by its code string.
  /// Throws ArgumentError if code is not found.
  static Currency fromCode(String value) {
    return Currency.values.firstWhere(
          (c) => c.code == value.toLowerCase(),
      orElse: () => throw ArgumentError("Invalid currency code: $value"),
    );
  }
}