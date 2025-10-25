import 'package:quiz_app/models/identity/role_with_select_modules_model.dart';

class RoleEditState {
  final bool isLoading;
  final RoleWithSelectModulesModel? role;
  final bool isLoadingUpdate;

  RoleEditState({
    this.isLoading = false,
    this.role,
    this.isLoadingUpdate = false
  });

  RoleEditState copyWith({
    bool? isLoading,
    RoleWithSelectModulesModel? role,
    bool? isLoadingUpdate
  }) {
    return RoleEditState(
      isLoading: isLoading ?? this.isLoading,
      role: role ?? this.role,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate
    );
  }
}