class Execise {
  final int id;
  final String name;
  final String bodypart;
  final int caloriesBurnt;
  final bool isRepetitive;
  final String? imageUrl;
  final int rate;

  Execise(
      {required this.id,
      required this.name,
      required this.bodypart,
      required this.caloriesBurnt,
      required this.imageUrl,
      required this.isRepetitive,
      this.rate = 0});

  factory Execise.fromjson(Map<String, dynamic> json) {
    return Execise(
      id: json['id'],
      name: json['name'],
      caloriesBurnt: json['calories_burned'].toInt(),
      bodypart: json['body_part'],
      isRepetitive: json['is_repetitive'],
      imageUrl: json['image'],
    );
  }
}
