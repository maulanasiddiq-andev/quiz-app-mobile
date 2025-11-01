import 'package:quiz_app/models/select_data_model.dart';

class SelectDataState {
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final List<SelectDataModel> datas;
  final String search;

  const SelectDataState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 20,
    this.datas = const [],
    this.search = ""
  });

  SelectDataState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    List<SelectDataModel>? datas,
    String? search
  }) {
    return SelectDataState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      datas: datas ?? this.datas,
      search: search ?? this.search
    );
  }
}