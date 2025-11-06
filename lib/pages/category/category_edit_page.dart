import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/notifiers/category/category_edit_notifier.dart';
import 'package:quiz_app/states/category/category_edit_state.dart';

class CategoryEditPage extends ConsumerStatefulWidget {
  final String categoryId;
  const CategoryEditPage({super.key, required this.categoryId});

  @override
  ConsumerState<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends ConsumerState<CategoryEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void _syncControllers(CategoryEditState? previous, CategoryEditState next) {
    final updates = {
      nameController: next.category?.name,
      descriptionController: next.category?.description,
    };

    for (final entry in updates.entries) {
      final controller = entry.key;
      final newText = entry.value ?? '';
      if (controller.text != newText) {
        controller.text = newText;
      }
    }
  }

  Future<bool> submitCategory() async {
    if (formKey.currentState!.validate()) {
      return await ref.read(categoryEditProvider(widget.categoryId).notifier).editCategoryById();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryEditProvider(widget.categoryId));
    final notifier = ref.read(categoryEditProvider(widget.categoryId).notifier);
    final colors = Theme.of(context).colorScheme;

    ref.listen(categoryEditProvider(widget.categoryId), (previous, next) {
      if (previous != next) _syncControllers(previous, next);
    });

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Edit Kategori"),
      body: Column(
        children: [
          Expanded(
            child: state.isLoading || state.category == null
            ? Center(child: CircularProgressIndicator(color: colors.primary))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        InputComponent(
                          title: "Nama Kategori", 
                          controller: nameController,
                          onChanged: (value) {
                            notifier.updateName(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nama kategori harus diisi.";
                            }

                            return null;
                          },
                        ),
                        InputComponent(
                          title: "Deskripsi", 
                          controller: descriptionController,
                          onChanged: (value) {
                            notifier.updateDescription(value);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Atur sebagai kategori default"),
                            Switch(
                              value: state.category!.isMain, 
                              onChanged: (value) {
                                notifier.updateIsMain(value);
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
            child: CustomButtonComponent(
              onTap: () async {
                final result = await submitCategory();
            
                if (result == true && context.mounted) {
                  context.pop(true);
                }
              }, 
              text: "Submit",
              isLoading: state.isLoadingUpdate,
            ),
          )
        ],
      ),
    );
  }
}