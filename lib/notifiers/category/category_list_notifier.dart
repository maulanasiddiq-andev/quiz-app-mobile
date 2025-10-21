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
      final BaseResponse<SearchResponse<CategoryModel>> result = await CategoryService.getCategories(state.pageIndex, state.pageSize);

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
}

final categoryListProvider = StateNotifierProvider.autoDispose<CategoryListNotifier, CategoryListState>((ref) => CategoryListNotifier());