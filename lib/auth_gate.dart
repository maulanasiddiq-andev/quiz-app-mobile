import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';
import 'package:quiz_app/pages/auth/login_page.dart';
import 'package:quiz_app/pages/root_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }
    
    if (authState.isAuthenticated) {
      return RootPage();
    } else {
      return LoginPage();
    }
  }
}