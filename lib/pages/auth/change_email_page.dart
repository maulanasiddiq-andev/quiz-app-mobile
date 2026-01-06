import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/auth_container.dart';
import 'package:quiz_app/components/auth_input_component.dart';
import 'package:quiz_app/notifiers/auth/register_notifier.dart';

class ChangeEmailPage extends ConsumerStatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ConsumerState<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<ChangeEmailPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> onSubmitText() async {
    final email = _emailController.text;

    return await ref.read(registerProvider.notifier).changeEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var state = ref.watch(registerProvider);
    
    return Scaffold(
      backgroundColor: colors.primary,
      body: AuthContainer(
        title: "Ganti Email",
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 10)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    AuthInputComponent(
                      controller: _emailController, 
                      keyboardType: TextInputType.emailAddress,
                      hinText: "Email",
                      isLast: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan email anda';
                        }

                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Masukkan email valid';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () async {
                  final result = await onSubmitText();

                  if (result == true && context.mounted) {
                    _emailController.clear();
                    context.pop(true);
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Center(
                    child: state.isLoading 
                      ? SizedBox(
                          height: 45,
                          width: 45,
                          child: Center(
                            child: CircularProgressIndicator(color: colors.onPrimary)
                          ),
                        )
                      : Text(
                          'Ganti',
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}