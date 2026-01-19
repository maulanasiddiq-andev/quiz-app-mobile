import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/detail_field_component.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/notifiers/profile/profile_notifier.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Profile"),
      body: Column(
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
                          profileImage: state.token?.user?.profileImage,
                          radius: 60,
                        ),
                      ),
                      DetailFieldComponent(
                        fieldName: "Nama",
                        content: state.token?.user?.name,
                      ),
                      DetailFieldComponent(
                        fieldName: "Email",
                        content: state.token?.user?.email,
                      ),
                      DetailFieldComponent(
                        fieldName: "Username",
                        content: state.token?.user?.username,
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                DetailFieldComponent(
                                  fieldName: "Kuis Dibuat", 
                                  content: profileState.quizCount.toString()
                                ),
                                CustomButtonComponent(
                                  onTap: () {
                                    context.push('/profile/profile-quiz');
                                  }, 
                                  text: "Lihat"
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                DetailFieldComponent(
                                  fieldName: "Kuis Dikerjakan", 
                                  content: profileState.historyCount.toString()
                                ),
                                CustomButtonComponent(
                                  onTap: () {
                                    context.push('/profile/profile-history');
                                  }, 
                                  text: "Lihat"
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}