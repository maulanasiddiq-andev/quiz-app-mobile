import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/states/category/category_detail_state.dart';

class CategoryDetailNotifier extends StateNotifier<CategoryDetailState>{
  CategoryDetailNotifier(): super(CategoryDetailState());

  Future<void> getCategoryById(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await CategoryService.getCategoryById(id);

      state = state.copyWith(isLoading: false, category: result.data);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }
}

final categoryDetailProvider = StateNotifierProvider.autoDispose<CategoryDetailNotifier, CategoryDetailState>((ref) => CategoryDetailNotifier());