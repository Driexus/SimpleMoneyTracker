class MoneyActivity {

  final int? id;
  final String title;
  final int color;
  final String imageKey;

  const MoneyActivity({
    this.id,
    required this.title,
    required this.color,
    required this.imageKey,
  });

  MoneyActivity.fromDBMap(Map<String, dynamic> dbMap) :
    id = dbMap['activityId'] as int,
    title = dbMap['title'] as String,
    color = dbMap['color'] as int,
    imageKey = dbMap['imageKey'] as String;

  Map<String, dynamic> toMap() {
    return {
      'activityId': id,
      'title': title,
      'color': color,
      'imageKey': imageKey
    };
  }

  MoneyActivity copy({
    String? title,
    int? color,
    String? imageKey
  }) {
    return MoneyActivity(
      id: id,
      title: title ?? this.title,
      color: color ?? this.color,
      imageKey: imageKey ?? this.imageKey
    );
  }

  @override
  String toString() {
    return 'MoneyActivity{title: $title, color: $color, imageKey: $imageKey}';
  }
}
