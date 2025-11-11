import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/notifiers/admin/role/role_create_notifier.dart';

class RoleCreatePage extends ConsumerStatefulWidget {
  const RoleCreatePage({super.key});

  @override
  ConsumerState<RoleCreatePage> createState() => _RoleCreatePageState();
}

class _RoleCreatePageState extends ConsumerState<RoleCreatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isMain = false;

  Future<bool> submitRole() async {
    if (formKey.currentState!.validate()) {
      return await ref.read(roleCreateProvider.notifier).createCategory(
        nameController.text, 
        descriptionController.text, 
        isMain
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roleCreateProvider);
    
    return Scaffold(
      appBar: CustomAppbarComponent(title: "Buat Role"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 15,
                    children: [
                      InputComponent(
                        title: "Nama", 
                        controller: nameController,
                      ),
                      InputComponent(
                        title: "Description", 
                        controller: descriptionController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Atur sebagai role default"),
                          Switch(
                            value: isMain, 
                            onChanged: (value) {
                              setState(() {
                                isMain = value;
                              });
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
                final result = await submitRole();

                if (result == true && context.mounted) {
                  context.pop(true);
                }
              }, 
              text: "Submit",
              isLoading: state.isLoading,
            ),
          )
        ],
      ),
    );
  }
}