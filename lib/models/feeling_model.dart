class FeelingModel {
  final String? id;
  final String feeling;
  final String? date;

  FeelingModel({
    this.id,
    required this.feeling,
    this.date,
  });

  factory FeelingModel.fromJson(Map<String, dynamic> json) {
    return FeelingModel(
      id: json['id']?.toString(),
      feeling: json['mood'] ?? json['feeling'] ?? '',
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        "mood": feeling,
      };
}
