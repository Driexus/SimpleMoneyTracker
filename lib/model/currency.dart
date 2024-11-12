enum Currency {
  euro("Euro", "€"),
  dollar("USD", "\$"),
  yen("Yen", "¥");

  final String title;
  final String symbol;

  const Currency(this.title, this.symbol);
}
