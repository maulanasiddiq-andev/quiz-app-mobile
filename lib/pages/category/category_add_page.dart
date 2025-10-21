import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/notifiers/category/category_add_notifier.dart';

class CategoryAddPage extends ConsumerStatefulWidget {
  const CategoryAddPage({super.key});

  @override
  ConsumerState<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends ConsumerState<CategoryAddPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<bool> submitCategory() async {
    if (formKey.currentState!.validate()) {
      return await ref.read(categoryAddProvider.notifier).addCategory(
        nameController.text,
        descriptionController.text,
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Tambah Kategori",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
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
                  Navigator.of(context).pop(true);
                }
              }, 
              text: "Tambah",
              isLoading: ref.watch(categoryAddProvider).isLoading,
            ),
          )
        ],
      ),
    );
  }
}