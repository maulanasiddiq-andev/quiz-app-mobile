import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/admin/user/user_list_notifier.dart';
import 'package:quiz_app/pages/admin/user/user_detail_page.dart';

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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ...state.users.map((user) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => UserDetailPage(userId: user.userId))
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
                              spacing: 15,
                              children: [
                                ProfileImageComponent(
                                  profileImage: user.profileImage,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${user.name} | ${user.username}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16
                                        ),  
                                      ),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          color: colors.secondary
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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