import 'package:quiz_app/models/base_model.dart';

class RoleModel extends BaseModel {
  final String roleId;
  final String name;
  final bool isMain;

  RoleModel({
    required super.createdBy,
    required super.createdTime,
    required super.description,
    required super.modifiedBy,
    required super.modifiedTime,
    required super.recordStatus,
    required super.version,
    required this.roleId,
    required this.name,
    required this.isMain,
  });

  RoleModel.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    roleId = json['roleId'],
    isMain = json['isMain'],
    super.fromJson(json);
}