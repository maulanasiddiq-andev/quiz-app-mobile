import 'package:quiz_app/models/base_model.dart';

class CategoryModel extends BaseModel {
  final String categoryId;
  final String name;

  CategoryModel({
    required super.createdBy,
    required super.createdTime,
    required super.description,
    required super.modifiedBy,
    required super.modifiedTime,
    required super.recordStatus,
    required super.version,
    required this.categoryId,
    required this.name
  });

  CategoryModel.fromJson(Map<String, dynamic> json) :
    categoryId = json['categoryId'],
    name = json['name'],
    super.fromJson(json);
}