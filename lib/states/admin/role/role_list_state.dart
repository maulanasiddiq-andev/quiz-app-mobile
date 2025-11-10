import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/models/identity/role_model.dart';

class RoleListState {
  final String search;
  final String sortDir;
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<RoleModel> roles;
  final String? deletedRoleId;

  RoleListState({
    this.sortDir = SortDirConstant.desc,
    this.search = "",
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.roles = const [],
    this.deletedRoleId
  });

  RoleListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<RoleModel>? roles,
    String? search,
    String? sortDir,
    String? deletedRoleId
  }) {
    return RoleListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      roles: roles ?? this.roles,
      search: search ?? this.search,
      sortDir: sortDir ?? this.sortDir,
      deletedRoleId: deletedRoleId ?? this.deletedRoleId
    );
  }
}
