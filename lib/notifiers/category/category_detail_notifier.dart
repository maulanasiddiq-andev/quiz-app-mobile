import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/states/category/category_detail_state.dart';

class CategoryDetailNotifier extends StateNotifier<CategoryDetailState>{
  final String categoryId;
  CategoryDetailNotifier(this.categoryId): super(CategoryDetailState()) {
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
  
  Future<bool> deleteCategory(String id) async {
    state = state.copyWith(isLoadingDelete: true);

    try {
      final result = await CategoryService.deleteCategory(id);

      state = state.copyWith(category: result.data);
      Fluttertoast.showToast(msg: result.messages[0]);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");

      return false;
    } finally {
      state = state.copyWith(isLoadingDelete: false);
    }
  }
}

final categoryDetailProvider = StateNotifierProvider.autoDispose.family<CategoryDetailNotifier, CategoryDetailState, String>((ref, categoryId) => CategoryDetailNotifier(categoryId));