import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/states/category/category_list_state.dart';

class CategoryListNotifier extends StateNotifier<CategoryListState> {
  CategoryListNotifier(): super(CategoryListState()) {
    getCategories();
  }

  Future<void> getCategories() async {
    state = state.copyWith(isLoading: true);

    try {
      Map<String, dynamic> queryParameters = {
        "pageSize": state.pageSize.toString(),
        "currentPage": state.pageIndex.toString(),
        "search": state.search,
        "orderDir": state.sortDir
      };

      final BaseResponse<SearchResponse<CategoryModel>> result = await CategoryService.getCategories(queryParameters);

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        categories: [...state.categories, ...result.data!.items],
        hasNextPage: result.data!.hasNextPage,
        hasPreviousPage: result.data!.hasPreviousPage,
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> refreshCategories() async {
    state = state.copyWith(pageIndex: 0, categories: []);

    await getCategories();
  }

  Future<void> searchCategories(String value) async {
    state = state.copyWith(search: value);
    await refreshCategories();
  }

  Future<void> changeSortDir(String value) async {
    state = state.copyWith(sortDir: value);
    await refreshCategories();
  }

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(deletedCategoryId: id);

    try {
      final result = await CategoryService.deleteCategory(id);

      final categories = [...state.categories];

      categories.removeWhere((c) => c.categoryId == id);
      state = state.copyWith(categories: [...categories]);

      Fluttertoast.showToast(msg: result.messages[0]);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    }
  }
}

final categoryListProvider = StateNotifierProvider.autoDispose<CategoryListNotifier, CategoryListState>((ref) => CategoryListNotifier());