import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/constants/select_data_constant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/role_model.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/models/select_data_model.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/services/role_service.dart';
import 'package:quiz_app/states/select_data_state.dart';

class SelectDataNotifier extends StateNotifier<SelectDataState> {
  final String data;
  SelectDataNotifier(this.data): super(SelectDataState()) {
    getDatas();
  }

  Future<void> getDatas() async {
    if (state.pageIndex == 0) {
      state = state.copyWith(isLoading: true);
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      dynamic result;

      Map<String, dynamic> queryParameters = {
        "pageSize": state.pageSize.toString(),
        "currentPage": state.pageIndex.toString(),
        "search": state.search,
        // "orderDir": state.sortDir
      };

      switch (data) {
        case SelectDataConstant.category:
          result = await CategoryService.getCategories(queryParameters);
          break;
        case SelectDataConstant.role:
          result = await RoleService.getRoles(queryParameters);
        default:
          result = await CategoryService.getCategories(queryParameters);
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
        state = state.copyWith(hasNextPage: result.data!.hasNextPage);
      }
      
      if (result is BaseResponse<SearchResponse<RoleModel>>) {
        for (var data in result.data!.items) {
          final selectData = SelectDataModel(
            id: data.roleId, 
            name: data.name
          );

          datas.add(selectData);
        }
        state = state.copyWith(hasNextPage: result.data!.hasNextPage);
      }

      state = state.copyWith(
        datas: [...state.datas, ...datas],
        isLoading: false,
        isLoadingMore: false,
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getDatas();
    }
  }

  Future<void> refreshDatas() async {
    state = state.copyWith(pageIndex: 0, datas: []);

    await getDatas();
  }

  Future<void> searchDatas(String value) async {
    state = state.copyWith(search: value);
    await refreshDatas();
  }

  Future<void> changeSortDir(String value) async {
    state = state.copyWith(sortDir: value);
    await refreshDatas();
  }
}

final selectDataProvider = StateNotifierProvider.autoDispose.family<SelectDataNotifier, SelectDataState, String>((ref, data) => SelectDataNotifier(data));