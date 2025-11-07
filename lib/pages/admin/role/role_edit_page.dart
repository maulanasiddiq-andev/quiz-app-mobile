import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/notifiers/admin/role/role_edit_notifier.dart';
import 'package:quiz_app/states/admin/role/role_edit_state.dart';

class RoleEditPage extends ConsumerStatefulWidget {
  final String roleId;
  const RoleEditPage({super.key, required this.roleId});

  @override
  ConsumerState<RoleEditPage> createState() => _RoleEditPageState();
}

class _RoleEditPageState extends ConsumerState<RoleEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void _syncControllers(RoleEditState? previous, RoleEditState next) {
    final updates = {
      nameController: next.role?.name,
      descriptionController: next.role?.description,
    };

    for (final entry in updates.entries) {
      final controller = entry.key;
      final newText = entry.value ?? '';
      if (controller.text != newText) {
        controller.text = newText;
      }
    }
  }

  Future<bool> submitRole() async {
    if (formKey.currentState!.validate()) {
      return await ref.read(roleEditProvider(widget.roleId).notifier).updateRoleById();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(roleEditProvider(widget.roleId));
    final notifier = ref.read(roleEditProvider(widget.roleId).notifier);

    ref.listen(roleEditProvider(widget.roleId), (previous, next) {
      if (previous != next) _syncControllers(previous, next);
    });

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Edit Role"),
      body: state.isLoading || state.role == null
        ? Center(
            child: CircularProgressIndicator(color: colors.primary),
          )
        : Column(
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
                            onChanged: (value) {
                              notifier.updateName(value);
                            },
                          ),
                          InputComponent(
                            title: "Description", 
                            controller: descriptionController,
                            onChanged: (value) {
                              notifier.updateDescription(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Atur sebagai role default"),
                              Switch(
                                value: state.role!.isMain, 
                                onChanged: (value) {
                                  notifier.updateIsMain(value);
                                }
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Text(
                                "Role Module",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                                children: [
                                  ...state.role!.roleModules.asMap().entries.map((value) {
                                    final roleModule = value.value;
                                    final index = value.key;
                              
                                    return CheckboxListTile(
                                      controlAffinity: ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        roleModule.roleModuleName,
                                        style: TextStyle(
                                          fontSize: 16
                                        ),
                                      ),
                                      value: roleModule.isSelected,
                                      onChanged: (value) {
                                        if (value != null) {
                                          notifier.updateRoleModule(index, value);
                                        }
                                      },
                                    );
                                  })
                                ],
                              ),
                            ],
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
                    final result = await submitRole();

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