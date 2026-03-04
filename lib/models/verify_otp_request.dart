class VerifyOtpResponse {
  final bool success;
  final String message;

  VerifyOtpResponse({
    required this.success,
    required this.message,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json["success"] ?? true,
      message: json["message"] ?? "",
    );
  }
}