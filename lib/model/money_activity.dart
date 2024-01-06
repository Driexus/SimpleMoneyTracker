class MoneyActivity {
  final String title;
  final int color;

  const MoneyActivity({
    required this.title,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': color
    };
  }

  @override
  String toString() {
    return 'MoneyActivity{title: $title, color: $color}';
  }
}
