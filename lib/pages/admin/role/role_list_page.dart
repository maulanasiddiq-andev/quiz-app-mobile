import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/notifiers/admin/role/role_list_notifier.dart';
import 'package:quiz_app/pages/admin/role/role_detail_page.dart';

class RoleListPage extends ConsumerStatefulWidget {
  const RoleListPage({super.key});

  @override
  ConsumerState<RoleListPage> createState() => _RoleListPageState();
}

class _RoleListPageState extends ConsumerState<RoleListPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roleListProvider);
    final notifier = ref.read(roleListProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Daftar Role",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshRoles(),
        child: Column(
          children: [
            Expanded(
              child: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: colors.primary),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.roles.map((role) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => RoleDetailPage(roleId: role.roleId))
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: colors.onSurface
                                )
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  role.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20
                                  ),  
                                ),
                                role.isMain
                                  ? Icon(Icons.check)
                                  : SizedBox()
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}