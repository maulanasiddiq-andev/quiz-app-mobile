import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/search_sort_component.dart';
import 'package:quiz_app/notifiers/admin/role/role_list_notifier.dart';
import 'package:quiz_app/pages/admin/role/role_detail_page.dart';
import 'package:quiz_app/pages/admin/role/role_edit_page.dart';

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
      appBar: CustomAppbarComponent(title: "Daftar Role"),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshRoles(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.onSurface)
                )
              ),
              child: SearchSortComponent(
                feature: "Role", 
                search: state.search, 
                sortDir: state.sortDir, 
                onSearchChanged: (value) {
                  notifier.searchRoles(value);
                },
                onSortDirChanged: (value) {
                  notifier.changeSortDir(value);
                },
              ),
            ),
            Expanded(
              child: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: colors.primary),
                )
              : ListView(
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
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colors.onSurface
                              )
                            )
                          ),
                          child: ListTile(
                            title: Text(role.name),
                            subtitle: role.isMain
                              ? Text("default")
                              : null,
                            trailing: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) async {
                                switch (value) {
                                  case 'view':
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => RoleDetailPage(roleId: role.roleId))
                                    );
                                    break;
                                  case 'edit':
                                    final result = await Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => RoleEditPage(roleId: role.roleId))
                                    );
                  
                                    if (result != null && result == true) {
                                      notifier.refreshRoles();
                                    }
                                    break;
                                  case 'delete':
                                    // handle delete action
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Text('Lihat Detail'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}