import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/constants/select_data_constant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/models/select_data_model.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/states/select_data_state.dart';

class SelectDataNotifier extends StateNotifier<SelectDataState> {
  final String data;
  SelectDataNotifier(this.data): super(SelectDataState()) {
    getDatas();
  }

  Future<void> getDatas() async {
    state = state.copyWith(isLoading: true);

    try {
      dynamic result;

      switch (data) {
        case SelectDataConstant.category:
          result = await CategoryService.getCategories(
            state.pageIndex, 
            state.pageSize
          );
          break;
        default:
          result = await CategoryService.getCategories(
            state.pageIndex, 
            state.pageSize
          );
          break;
      }

      final List<SelectDataModel> datas = [];
      if (result is BaseResponse<SearchResponse<CategoryModel>>) {
        for (var data in result.data!.items) {
          final selectData = SelectDataModel(
            id: data.categoryId, 
            name: data.name
          );

          datas.add(selectData);
        }
      }

      state = state.copyWith(
        datas: datas,
        isLoading: false
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }
}

final selectDataProvider = StateNotifierProvider.autoDispose.family<SelectDataNotifier, SelectDataState, String>((ref, data) => SelectDataNotifier(data));