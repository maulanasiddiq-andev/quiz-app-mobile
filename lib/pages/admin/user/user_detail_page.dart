import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/check_module_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/detail_field_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/constants/module_constant.dart';
import 'package:quiz_app/notifiers/admin/user/user_detail_notifier.dart';
import 'package:quiz_app/pages/admin/user/user_edit_page.dart';
import 'package:quiz_app/utils/format_date.dart';

class UserDetailPage extends ConsumerStatefulWidget {
  final String userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  ConsumerState<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends ConsumerState<UserDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(userDetailProvider(widget.userId));
    final notifier = ref.read(userDetailProvider(widget.userId).notifier);

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Detail User"),
      body: state.isLoading || state.user == null
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
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ProfileImageComponent(
                                profileImage: state.user?.profileImage,
                                radius: 60,
                              ),
                            ),
                            DetailFieldComponent(
                              fieldName: "Nama",
                              content: state.user?.name,
                            ),
                            DetailFieldComponent(
                              fieldName: "Email",
                              content: state.user?.email,
                            ),
                            DetailFieldComponent(
                              fieldName: "Username",
                              content: state.user?.username,
                            ),
                            DetailFieldComponent(
                              fieldName: "Role",
                              content: state.user?.role?.name,
                            ),
                            DetailFieldComponent(
                              fieldName: "Email Diverifikasi pada",
                              content: formatDate(state.user?.emailVerifiedTime),
                            ),
                            DetailFieldComponent(
                              fieldName: "Terakhir Login",
                              content: formatDate(state.user?.lastLoginTime),
                            ),
                            DetailFieldComponent(
                              fieldName: "Deskripsi",
                              content: state.user?.description,
                            ),
                            DetailFieldComponent(
                              fieldName: "Status",
                              content: state.user?.recordStatus,
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
                        moduleNames: [ModuleConstant.editUser],
                        child: Expanded(
                          child: CustomButtonComponent(
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UserEditPage(userId: state.user!.userId),
                                ),
                              );

                              if (result != null && result == true) {
                                notifier.getUserById(widget.userId);
                              }
                            },
                            text: "Edit",
                          ),
                        ),
                      ),
                      CheckModuleComponent(
                        moduleNames: [ModuleConstant.deleteUser],
                        child: Expanded(
                          child: CustomButtonComponent(
                            onTap: () {},
                            text: "Hapus",
                            isError: true,
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
