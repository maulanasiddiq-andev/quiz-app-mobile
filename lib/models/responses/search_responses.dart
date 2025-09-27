class SearchResponse<T> {
  final List<T> items;
  final int totalItems;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  SearchResponse({
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.items,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>)  fromJsonT) => SearchResponse(
    currentPage: json['currentPage'], 
    hasNextPage: json['hasNextPage'], 
    hasPreviousPage: json['hasPreviousPage'], 
    items: (json['items'] as List).map((data) => fromJsonT(data)).toList(), 
    pageSize: json['pageSize'], 
    totalItems: json['totalItems'], 
    totalPages: json['totalPages'],
  );
}