class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String? bio;
  final String? photoUrl;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    this.bio,
    this.photoUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
    );
  }
}