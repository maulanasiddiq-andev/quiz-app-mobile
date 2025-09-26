class CategoryModel {
  final String categoryId;
  final String title;

  CategoryModel({
    required this.categoryId,
    required this.title
  });

  CategoryModel.fromJson(Map<String, dynamic> json) :
    categoryId = json['categoryId'],
    title = json['title'];
}