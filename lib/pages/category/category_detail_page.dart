import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/check_module_component.dart';
import 'package:quiz_app/components/confirm_dialog.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/detail_field_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/module_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/category/category_detail_notifier.dart';

class CategoryDetailPage extends ConsumerStatefulWidget {
  final String categoryId;
  const CategoryDetailPage({super.key, required this.categoryId});

  @override
  ConsumerState<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends ConsumerState<CategoryDetailPage> {
  Future<bool> confirmDelete() async {
    final result = confirmDialog(
      context: context, 
      title: "Perhatian", 
      content: "Apakah anda yakin ingin menghapus kategori ini?"
    );

    return result;
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(categoryDetailProvider(widget.categoryId));
    final notifier = ref.read(categoryDetailProvider(widget.categoryId).notifier);

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Detail Kategori"),
      body: state.isLoading || state.category == null
          ? Center(child: CircularProgressIndicator(color: colors.primary))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            DetailFieldComponent(
                              fieldName: "Nama",
                              content: state.category?.name,
                            ),
                            DetailFieldComponent(
                              fieldName: "Deskripsi",
                              content: state.category?.description,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Kategori Default"),
                                Switch(
                                  value: state.category!.isMain, 
                                  onChanged: (value) {
                                    // no action for this switch
                                  }
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    spacing: 10,
                    children: [
                      CheckModuleComponent(
                        moduleNames: [ModuleConstant.editCategory],
                        child: Expanded(
                          child: CustomButtonComponent(
                            onTap: () async {
                              final result = await context.push("/${ResourceConstant.category}/${ActionConstant.edit}/${widget.categoryId}");

                              if (result != null && result == true) {
                                // if the category is updated
                                // refresh
                                notifier.getCategoryById(widget.categoryId);
                              }
                            },
                            text: "Edit",
                          ),
                        ),
                      ),
                      CheckModuleComponent(
                        moduleNames: [ModuleConstant.deleteCategory],
                        child: Expanded(
                          child: CustomButtonComponent(
                            onTap: () async {
                              final deleteConfirmed = await confirmDelete();

                              if (deleteConfirmed == true) {
                                // if delete is confirmed
                                // delete
                                final result = await notifier.deleteCategory(widget.categoryId);

                                // if delete is succesful
                                // navigate back
                                if (result == true && context.mounted) {
                                  context.pop();
                                }
                              }
                            },
                            text: "Hapus",
                            isError: true,
                            isLoading: state.isLoadingDelete,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}