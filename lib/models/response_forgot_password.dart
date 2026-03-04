class ForgotPasswordResponse {
  final bool success;
  final String message;

  ForgotPasswordResponse({
    required this.success,
    required this.message,
  });

  factory ForgotPasswordResponse.fromJson(
      Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json["success"] ?? true, 
      // kalau backend gak kirim success, anggap true kalau status 200
      message: json["message"] ?? "",
    );
  }
}