import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/models/identity/user_model.dart';

class UserListState {
  final String search;
  final String sortDir;
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<UserModel> users;

  UserListState({
    this.sortDir = SortDirConstant.desc,
    this.search = "",
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.users = const [],
  });

  UserListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<UserModel>? users,
    String? search,
    String? sortDir
  }) {
    return UserListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      users: users ?? this.users,
      search: search ?? this.search,
      sortDir: sortDir ?? this.sortDir
    );
  }
}
