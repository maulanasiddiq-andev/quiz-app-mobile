class UserModel {
  final String email;
  final String username;
  final String name;

  UserModel({
    required this.email,
    required this.name,
    required this.username,
  });

  UserModel.fromJson(Map<String, dynamic> json) :
    email = json['email'],
    name = json['name'],
    username = json['username'];
}