class BaseResponse<T> {
  final bool succeed;
  final List<String> messages;
  final T? data;

  BaseResponse({
    this.data,
    required this.messages,
    required this.succeed
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json, 
    {T Function(Map<String, dynamic>)? fromJsonT}
  ) {
    final dataJson = json['data'];

    return BaseResponse(
      data: dataJson == null
        ? null
        : (fromJsonT != null ? fromJsonT(dataJson) : dataJson as T),
      messages: List<String>.from(json['messages']),
      succeed: json['succeed'],
    );
  }
}