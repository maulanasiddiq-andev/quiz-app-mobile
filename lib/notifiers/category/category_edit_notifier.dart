import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/states/category/category_edit_state.dart';

class CategoryEditNotifier extends StateNotifier<CategoryEditState> {
  final String categoryId;
  CategoryEditNotifier(this.categoryId): super(CategoryEditState()) {
    getCategoryById(categoryId);
  }

  Future<void> getCategoryById(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await CategoryService.getCategoryById(id);

      state = state.copyWith(category: result.data);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateName(String value) {
    var category = state.category;

    category = category?.copyWith(name: value);

    state = state.copyWith(category: category);
  }

  void updateDescription(String value) {
    var category = state.category;

    category = category?.copyWith(description: value);

    state = state.copyWith(category: category);
  }

  void updateIsMain(bool value) {
    var category = state.category;

    category = category?.copyWith(isMain: value);

    state = state.copyWith(category: category);
  }

  Future<bool> editCategoryById() async {
    state = state.copyWith(isLoadingUpdate: true);

    try {
      final result = await CategoryService.editCategoryById(
        categoryId,
        state.category?.toJson(),
      );

      Fluttertoast.showToast(msg: result.messages[0]);
      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");

      return false;
    } finally {
      state = state.copyWith(isLoadingUpdate: false);
    }
  }
}

final categoryEditProvider = StateNotifierProvider.autoDispose
  .family<CategoryEditNotifier, CategoryEditState, String>((ref, categoryId) => CategoryEditNotifier(categoryId));