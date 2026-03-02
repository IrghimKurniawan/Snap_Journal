class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String expiresIn;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['token'], 
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }
}