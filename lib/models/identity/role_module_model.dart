import 'package:quiz_app/models/base_model.dart';

class RoleModuleModel extends BaseModel {
  final String roleModuleId;
  final String roleId;
  final String roleModuleName;

  RoleModuleModel({
    required super.createdBy,
    required super.createdTime,
    required super.description,
    required super.modifiedBy,
    required super.modifiedTime,
    required super.recordStatus,
    required super.version,
    required this.roleId,
    required this.roleModuleId,
    required this.roleModuleName
  });

  RoleModuleModel.fromJson(Map<String, dynamic> json) :
    roleId = json['roleId'],
    roleModuleId = json['roleModuleId'],
    roleModuleName = json['roleModuleName'],
    super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'roleModuleId': roleModuleId,
      'roleId': roleId,
      'roleModuleName': roleModuleName,
    });
    return json;
  }
}