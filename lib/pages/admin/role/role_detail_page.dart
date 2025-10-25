import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/detail_field_component.dart';
import 'package:quiz_app/notifiers/admin/role/role_detail_notifier.dart';
import 'package:quiz_app/pages/admin/role/role_edit_page.dart';

class RoleDetailPage extends ConsumerStatefulWidget {
  final String roleId;
  const RoleDetailPage({super.key, required this.roleId});

  @override
  ConsumerState<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends ConsumerState<RoleDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(roleDetailProvider(widget.roleId));
    final notifier = ref.read(roleDetailProvider(widget.roleId).notifier);

    return Scaffold(
      appBar: customAppbarComponent(
        "Detail Role",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
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
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        DetailFieldComponent(fieldName: "Nama", content: state.role!.name),
                        DetailFieldComponent(
                          fieldName: "Deskripsi", 
                          content: state.role!.description.isNotEmpty ? state.role!.description : "-"
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              childAspectRatio: 5,
                              children: [
                                ...state.role!.roleModules.map((roleModule) {
                                  return Text(
                                    roleModule.roleModuleName,
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
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
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomButtonComponent(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RoleEditPage(roleId: state.role!.roleId))
                        );

                        if (result != null && result == true) {
                          notifier.getRoleById(widget.roleId);
                        }
                      }, 
                      text: "Edit",
                    ),
                  ),
                  Expanded(
                    child: CustomButtonComponent(
                      onTap: () {}, 
                      text: "Hapus",
                      isError: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}