import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/notifiers/category/category_detail_notifier.dart';

class CategoryEditPage extends ConsumerStatefulWidget {
  final CategoryModel category;
  const CategoryEditPage({super.key, required this.category});

  @override
  ConsumerState<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends ConsumerState<CategoryEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = widget.category.name;
    descriptionController.text = widget.category.description;

    super.initState();
  }

  Future<bool> submitCategory() async {
    if (formKey.currentState!.validate()) {
      return await ref.read(categoryDetailProvider.notifier).editCategoryById(
        widget.category.categoryId, 
        nameController.text, 
        descriptionController.text
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarComponent(title: "Edit Kategori"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama kategori harus diisi.";
                          }

                          return null;
                        },
                      ),
                      InputComponent(
                        title: "Deskripsi", 
                        controller: descriptionController
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
                  Navigator.of(context).pop();
                }
              }, 
              text: "Submit",
              isLoading: ref.watch(categoryDetailProvider).isLoading,
            ),
          )
        ],
      ),
    );
  }
}