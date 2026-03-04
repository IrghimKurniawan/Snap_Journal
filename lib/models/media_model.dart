class MediaModel {
  final String id;
  final String url;
  final String fileName;
  final String createdAt;

  MediaModel({
    required this.id,
    required this.url,
    required this.fileName,
    required this.createdAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'].toString(),
      url: json['url'] ?? '',
      fileName: json['fileName'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
