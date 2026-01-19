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
import 'package:quiz_app/notifiers/admin/role/role_detail_notifier.dart';

class RoleDetailPage extends ConsumerStatefulWidget {
  final String roleId;
  const RoleDetailPage({super.key, required this.roleId});

  @override
  ConsumerState<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends ConsumerState<RoleDetailPage> {
  Future<bool> confirmDelete() async {
    final result = confirmDialog(
      context: context, 
      title: "Perhatian", 
      content: "Apakah anda yakin ingin menghapus role ini?"
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(roleDetailProvider(widget.roleId));
    final notifier = ref.read(roleDetailProvider(widget.roleId).notifier);

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Detail Role"),
      body: state.isLoading || state.role == null
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
                              content: state.role?.name,
                            ),
                            DetailFieldComponent(
                              fieldName: "Deskripsi",
                              content: state.role?.description,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Role Module",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  crossAxisCount: 2,
                                  childAspectRatio: 5,
                                  children: [
                                    ...state.role!.roleModules.map((
                                      roleModule,
                                    ) {
                                      return Text(
                                        roleModule.roleModuleName,
                                        style: TextStyle(fontSize: 20),
                                      );
                                    }),
                                  ],
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
                        moduleNames: [ModuleConstant.editRole],
                        child: Expanded(
                          child: CustomButtonComponent(
                            onTap: () async {
                              final result = await context.push("/admin/${ResourceConstant.role}/${ActionConstant.edit}/${widget.roleId}");

                              if (result != null && result == true) {
                                notifier.getRoleById(widget.roleId);
                              }
                            },
                            text: "Edit",
                          ),
                        ),
                      ),
                      CheckModuleComponent(
                        moduleNames: [ModuleConstant.deleteRole],
                        child: Expanded(
                          child: CustomButtonComponent(
                            onTap: () async {
                              final deleteConfirmed = await confirmDelete();

                              if (deleteConfirmed == true) {
                                final result = await notifier.deleteRole();

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
