import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/role_module_model.dart';

class RoleModel extends BaseModel {
  final String roleId;
  final String name;
  final bool isMain;
  final List<RoleModuleModel> roleModules;

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
    required this.roleModules
  });

  RoleModel.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    roleId = json['roleId'],
    isMain = json['isMain'],
    roleModules = (json['roleModules'] as List)
      .map((roleModule) => RoleModuleModel.fromJson(roleModule))
      .toList(),
    super.fromJson(json);
}