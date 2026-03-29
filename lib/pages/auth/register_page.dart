import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/auth_container.dart';
import 'package:quiz_app/components/auth_input_component.dart';
import 'package:quiz_app/components/background_container_component.dart';
import 'package:quiz_app/notifiers/auth/register_notifier.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> onSubmitText() async {
    final email = _emailController.text;
    final name = _nameController.text;
    final password = _passwordController.text;

    return await ref.read(registerProvider.notifier).register(email, name, password);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(registerProvider);

    return BackgroundContainerComponent(
      child: Scaffold(
        backgroundColor: colors.primary,
        body: AuthContainer(
          title: "Register",
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
                      AuthInputComponent(
                        controller: _nameController, 
                        textCapitalization: TextCapitalization.sentences,
                        hinText: "Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan nama anda';
                          }
      
                          return null;
                        },
                      ),
                      AuthInputComponent(
                        controller: _passwordController, 
                        hinText: "Password",
                        isPassword: true,
                        isTextObscure: _obscureText,
                        action: TextInputAction.done,
                        isLast: true,
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan username anda';
                          }
      
                          return null;
                        }
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () async {
                    final result = await onSubmitText();
      
                    if (result == true && context.mounted) {
                      context.push("/otp");
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
                            'Register',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: colors.secondary
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go("/login");
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: colors.primary
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(child: SizedBox()),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}