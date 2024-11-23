enum Currency {
  euro("euro", "Euro", "€"),
  dollar("dollar", "USD", "\$"),
  yen("yen", "Yen", "¥");

  final String code;
  final String title;
  final String symbol;

  const Currency(this.code, this.title, this.symbol);

  static Currency fromCode(String value) {
    switch(value) {
      case "euro": return Currency.euro;
      case "dollar": return Currency.dollar;
      case "yen": return Currency.yen;
      default: throw UnimplementedError();
    }
  }
}
