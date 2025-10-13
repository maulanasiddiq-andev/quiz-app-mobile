class UserModel {
  final String userId;
  final String email;
  final String username;
  final String name;
  final String? profileImage;
  final String? coverImage;

  UserModel({
    required this.email,
    required this.name,
    required this.username,
    required this.coverImage,
    required this.profileImage,
    required this.userId
  });

  UserModel.fromJson(Map<String, dynamic> json) :
    email = json['email'],
    name = json['name'],
    username = json['username'],
    userId = json['userId'],
    profileImage = json['profileImage'],
    coverImage = json['coverImage'];
}