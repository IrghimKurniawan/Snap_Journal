class RegisterModel {
  final String id;
  final String name;
  final String email;
  final String? token;

  RegisterModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      token: json['token'], // kalau API kirim token
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
    };
  }
}