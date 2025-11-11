import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/check_module_component.dart';
import 'package:quiz_app/components/confirm_dialog.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/components/search_sort_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/module_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/admin/user/user_list_notifier.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
        final notifier = ref.read(userListProvider.notifier);
        notifier.loadMoreDatas();
      }
    });
  }

  Future<bool> confirmDelete(String name) async {
    final result = confirmDialog(
      context: context, 
      title: "Perhatian", 
      content: "Apakah anda yakin ingin menghapus user $name?"
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListProvider);
    final notifier = ref.read(userListProvider.notifier);

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbarComponent(title: "Daftar User"),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshUsers(),
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
                feature: "User", 
                search: state.search, 
                sortDir: state.sortDir, 
                onSearchChanged: (value) {
                  notifier.searchUsers(value);
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
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  children: [
                    ...state.users.map((user) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: colors.onSurface
                            )
                          )
                        ),
                        child: ListTile(
                          onTap: () {
                            context.push("/${ResourceConstant.user}/${ActionConstant.detail}/${user.userId}");
                          },
                          leading: ProfileImageComponent(
                            profileImage: user.profileImage,
                          ),
                          title: Text(
                            "${user.name} | ${user.username}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              switch (value) {
                                case 'view':
                                  context.push("/${ResourceConstant.user}/${ActionConstant.detail}/${user.userId}");
                                  break;
                                case 'edit':
                                  final result = await context.push("/${ResourceConstant.user}/${ActionConstant.edit}/${user.userId}");
                
                                  if (result != null && result == true) {
                                    notifier.refreshUsers();
                                  }
                                  break;
                                case 'delete':
                                  final deleteConfirmed = await confirmDelete(user.name);

                                  if (deleteConfirmed == true) {
                                    notifier.deleteUser(user.userId);
                                  }
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
                        )
                      );
                    }),
                    if (state.isLoadingMore)
                      Center(
                        child: CircularProgressIndicator(
                          color: colors.primary,
                        ),
                      )
                  ],
                )
            ),
          ],
        ),
      ),
      floatingActionButton: CheckModuleComponent(
        moduleNames: [ModuleConstant.createUser],
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.create),  
        ),
      ),
    );
  }
}