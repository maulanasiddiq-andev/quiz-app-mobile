class SelectDataModel {
  final String id;
  final String name;
  final bool isSelected;

  SelectDataModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  SelectDataModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return SelectDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}