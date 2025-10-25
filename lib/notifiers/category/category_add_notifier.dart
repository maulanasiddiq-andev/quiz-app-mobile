import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/states/category/category_add_state.dart';

class CategoryAddNotifier extends StateNotifier<CategoryAddState> {
  CategoryAddNotifier(): super(CategoryAddState());

  Future<bool> addCategory(String name, String description) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await CategoryService.addCategory(name, description);
      Fluttertoast.showToast(msg: result.messages[0]);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);

      return false;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);

      return false;
    }
  }
}

final categoryAddProvider = StateNotifierProvider.autoDispose<CategoryAddNotifier, CategoryAddState>((ref) => CategoryAddNotifier());