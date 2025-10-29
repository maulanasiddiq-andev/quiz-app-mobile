import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/admin/user/user_list_notifier.dart';
import 'package:quiz_app/pages/admin/user/user_detail_page.dart';
import 'package:quiz_app/pages/admin/user/user_edit_page.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListProvider);
    final notifier = ref.read(userListProvider.notifier);

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: customAppbarComponent(
        "Daftar User",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshUsers(),
        child: Column(
          children: [
            Expanded(
              child: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(color: colors.primary),
                )
              : ListView(
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
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => UserDetailPage(userId: user.userId))
                            );
                          },
                          leading: ProfileImageComponent(
                            profileImage: user.profileImage,
                          ),
                          title: Text(
                            "${user.name} | ${user.username}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(user.email),
                          trailing: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) async {
                              switch (value) {
                                case 'view':
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => UserDetailPage(userId: user.userId))
                                  );
                                  break;
                                case 'edit':
                                  final result = await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => UserEditPage(userId: user.userId))
                                  );
                
                                  if (result != null && result == true) {
                                    notifier.refreshUsers();
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
                        )
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