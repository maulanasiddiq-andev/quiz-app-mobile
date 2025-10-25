import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/role_model.dart';

class UserModel extends BaseModel {
  final String userId;
  final String email;
  final String username;
  final String name;
  final String? profileImage;
  final String? coverImage; 
  final DateTime emailVerifiedTime;
  final DateTime? lastLoginTime;
  final int failedLoginAttempts;
  final String? roleId;
  final RoleModel? role;

  UserModel({
    required super.description,
    required super.recordStatus,
    required super.version,
    required super.createdBy,
    required super.createdTime,
    required super.modifiedBy,
    required super.modifiedTime,
    required this.email,
    required this.name,
    required this.username,
    required this.coverImage,
    required this.profileImage,
    required this.userId,
    required this.emailVerifiedTime,
    required this.failedLoginAttempts,
    required this.lastLoginTime,
    this.roleId,
    this.role,
  });

  UserModel.fromJson(Map<String, dynamic> json) :
    email = json['email'],
    name = json['name'],
    username = json['username'],
    userId = json['userId'],
    profileImage = json['profileImage'],
    coverImage = json['coverImage'],
    emailVerifiedTime = DateTime.parse(json['emailVerifiedTime']),
    lastLoginTime = json['lastLoginTime'] != null ? DateTime.parse(json['lastLoginTime']) : null,
    failedLoginAttempts = json['failedLoginAttempts'],
    roleId = json['roleId'],
    role = RoleModel.fromJson(json['role']),
    super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'userId': userId,
      'email': email,
      'username': username,
      'name': name,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'emailVerifiedTime': emailVerifiedTime.toIso8601String(),
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'failedLoginAttempts': failedLoginAttempts,
      'roleId': roleId,
      'role': role?.toJson(),
    });
    return json;
  }
}