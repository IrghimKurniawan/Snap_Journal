class FeelingModel {
  final String id;
  final String feeling; // 'happy' | 'calm' | 'sad' | 'neutral'
  final String date;

  FeelingModel({
    required this.id,
    required this.feeling,
    required this.date,
  });

  factory FeelingModel.fromJson(Map<String, dynamic> json) {
    return FeelingModel(
      id: json['id'].toString(),
      feeling: json['feeling'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'feeling': feeling,
        'date': date,
      };
}
