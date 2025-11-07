import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/models/select_data_model.dart';

class SelectDataState {
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final List<SelectDataModel> datas;
  final String search;
  final String sortDir;

  const SelectDataState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.datas = const [],
    this.search = "",
    this.hasNextPage = false,
    this.sortDir = SortDirConstant.desc
  });

  SelectDataState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    List<SelectDataModel>? datas,
    String? search,
    bool? hasNextPage,
    String? sortDir
  }) {
    return SelectDataState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      datas: datas ?? this.datas,
      search: search ?? this.search,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      sortDir: sortDir ?? this.sortDir
    );
  }
}