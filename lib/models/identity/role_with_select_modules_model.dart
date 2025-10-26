import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/select_module_model.dart';

class RoleWithSelectModulesModel extends BaseModel {
  final String roleId;
  final String name;
  final bool isMain;
  final List<SelectModuleModel> roleModules;

  RoleWithSelectModulesModel({
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

  RoleWithSelectModulesModel.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    roleId = json['roleId'],
    isMain = json['isMain'],
    roleModules = (json['roleModules'] as List)
      .map((roleModule) => SelectModuleModel.fromJson(roleModule))
      .toList(),
    super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'roleId': roleId,
      'name': name,
      'isMain': isMain,
      'roleModules': roleModules.map((e) => e.toJson()).toList(),
    });
    return json;
  }

  RoleWithSelectModulesModel copyWith({
    int? version,
    String? description,
    String? recordStatus,
    DateTime? createdTime,
    String? createdBy,
    DateTime? modifiedTime,
    String? modifiedBy,
    String? roleId,
    String? name,
    bool? isMain,
    List<SelectModuleModel>? roleModules,
  }) {
    return RoleWithSelectModulesModel(
      version: version ?? this.version,
      description: description ?? this.description,
      recordStatus: recordStatus ?? this.recordStatus,
      createdTime: createdTime ?? this.createdTime,
      createdBy: createdBy ?? this.createdBy,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      roleId: roleId ?? this.roleId,
      name: name ?? this.name,
      isMain: isMain ?? this.isMain,
      roleModules: roleModules ?? List<SelectModuleModel>.from(this.roleModules),
    );
  }
}