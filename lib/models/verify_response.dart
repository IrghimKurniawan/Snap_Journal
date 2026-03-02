class VerifyResponseModel {
  final bool? status;
  final String message;

  VerifyResponseModel({
    this.status,
    required this.message,
  });

  factory VerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyResponseModel(
      status: json['status'],
      message: json['message'] ?? "Berhasil",
    );
  }
}