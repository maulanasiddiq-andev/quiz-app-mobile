class SelectModuleModel {
  final String roleModuleName;
  final bool isSelected;

  SelectModuleModel({
    required this.roleModuleName,
    required this.isSelected
  });

  factory SelectModuleModel.fromJson(Map<String, dynamic> json) => SelectModuleModel(
    roleModuleName: json['roleModuleName'], 
    isSelected: json['isSelected']
  );

  Map<String, dynamic> toJson() {
    return {
      "roleModuleName": roleModuleName,
      "isSelected": isSelected,
    };
  }

  SelectModuleModel copyWith({
    String? roleModuleName,
    bool? isSelected
  }) {
    return SelectModuleModel(
      roleModuleName: roleModuleName ?? this.roleModuleName,
      isSelected: isSelected ?? this.isSelected
    );
  }
}