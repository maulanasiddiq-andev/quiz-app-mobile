class CategoryModel {
  final String categoryId;
  final String name;

  CategoryModel({
    required this.categoryId,
    required this.name
  });

  CategoryModel.fromJson(Map<String, dynamic> json) :
    categoryId = json['categoryId'],
    name = json['name'];
}