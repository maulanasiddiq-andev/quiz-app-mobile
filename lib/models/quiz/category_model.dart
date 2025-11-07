import 'package:quiz_app/models/base_model.dart';

class CategoryModel extends BaseModel {
  final String categoryId;
  final String name;
  final bool isMain;

  CategoryModel({
    required super.createdBy,
    required super.createdTime,
    required super.description,
    required super.modifiedBy,
    required super.modifiedTime,
    required super.recordStatus,
    required super.version,
    required this.categoryId,
    required this.name,
    required this.isMain
  });

  CategoryModel.fromJson(Map<String, dynamic> json) :
    categoryId = json['categoryId'],
    name = json['name'],
    isMain = json['isMain'],
    super.fromJson(json);

  CategoryModel copyWith({
    String? categoryId,
    String? name,
    String? createdBy,
    DateTime? createdTime,
    String? description,
    String? modifiedBy,
    DateTime? modifiedTime,
    String? recordStatus,
    int? version,
    bool? isMain
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      createdTime: createdTime ?? this.createdTime,
      description: description ?? this.description,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      recordStatus: recordStatus ?? this.recordStatus,
      version: version ?? this.version,
      isMain: isMain ?? this.isMain
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'isMain': isMain,
      'createdBy': createdBy,
      'createdTime': createdTime.toIso8601String(),
      'description': description,
      'modifiedBy': modifiedBy,
      'modifiedTime': modifiedTime.toIso8601String(),
      'recordStatus': recordStatus,
      'version': version,
    };
  }
}