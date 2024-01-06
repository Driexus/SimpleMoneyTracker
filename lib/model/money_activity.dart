class MoneyActivity {
  final String title;
  final int color;
  final String imageKey;

  const MoneyActivity({
    required this.title,
    required this.color,
    required this.imageKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': color,
      'imageKey': imageKey
    };
  }

  @override
  String toString() {
    return 'MoneyActivity{title: $title, color: $color, imageKey: $imageKey}';
  }
}
