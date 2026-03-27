class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String? bio;
  final String? photoUrl;
  final String? picture;

  UserProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    this.bio,
    this.photoUrl,
    this.picture,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      picture: json['picture'],
    );
  }
}