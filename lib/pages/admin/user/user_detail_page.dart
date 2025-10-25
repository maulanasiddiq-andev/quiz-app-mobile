import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/admin/user/user_detail_notifier.dart';

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

    Future.microtask((){
      ref.read(userDetailProvider.notifier).getUserById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(userDetailProvider);

    return Scaffold(
      appBar: customAppbarComponent(
        "Detail User",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: state.isLoading || state.user == null
      ? Center(
          child: CircularProgressIndicator(color: colors.primary),
        )
      : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                spacing: 15,
                children: [
                  ProfileImageComponent(
                    profileImage: state.user?.profileImage,
                    radius: 60,
                  ),
                  Text(
                    state.user!.name,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Text(
                    state.user!.email,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}