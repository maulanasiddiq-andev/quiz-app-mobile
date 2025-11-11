import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/components/select_data_component.dart';
import 'package:quiz_app/constants/select_data_constant.dart';
import 'package:quiz_app/notifiers/admin/user/user_edit_notifier.dart';
import 'package:quiz_app/states/admin/user/user_edit_state.dart';

class UserEditPage extends ConsumerStatefulWidget {
  final String userId;
  const UserEditPage({super.key, required this.userId});

  @override
  ConsumerState<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends ConsumerState<UserEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _syncControllers(UserEditState? previous, UserEditState next) {
    final updates = {
      nameController: next.user?.name,
      emailController: next.user?.email,
      usernameController: next.user?.username,
      descriptionController: next.user?.description,
    };

    for (final entry in updates.entries) {
      final controller = entry.key;
      final newText = entry.value ?? '';
      if (controller.text != newText) {
        controller.text = newText;
      }
    }
  }

  Future<bool> submitUser() async {
    if (formKey.currentState!.validate()) {
      return await ref.read(userEditProvider(widget.userId).notifier).updateUserById();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userEditProvider(widget.userId));
    final notifier = ref.read(userEditProvider(widget.userId).notifier);

    ref.listen(userEditProvider(widget.userId), (previous, next) {
      if (previous != next) _syncControllers(previous, next);
    });

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Edit User"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Center(
                        child: ProfileImageComponent(
                          profileImage: state.user?.profileImage,
                          radius: 60,
                        ),
                      ),
                      InputComponent(
                        title: "Nama", 
                        controller: nameController,
                        onChanged: (value) {
                          notifier.updateName(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama user harus diisi";
                          }

                          return null;
                        },
                      ),
                      InputComponent(
                        title: "Email", 
                        controller: emailController,
                        enabled: false,
                      ),
                      InputComponent(
                        title: "Username", 
                        controller: usernameController,
                        enabled: false,
                      ),
                      InputComponent(
                        title: "Deskripsi", 
                        controller: descriptionController,
                        onChanged: (value) {
                          notifier.updateDescription(value);
                        },
                      ),
                      SelectDataComponent(
                        title: "Role", 
                        data: SelectDataConstant.role,
                        selectedData: state.role,
                        onSelected: (value) {
                          notifier.updateRole(value);
                        },
                      )
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
                final result = await submitUser();

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