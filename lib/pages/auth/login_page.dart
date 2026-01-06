import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/auth_container.dart';
import 'package:quiz_app/components/auth_input_component.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/auth_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    // _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmitText() {
    if (formKey.currentState!.validate()) {
      String email = _emailController.value.text;
      String password = _passwordController.value.text;

      ref.read(authProvider.notifier).login(email, password);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go("/${ResourceConstant.quiz}");
      }
    });

    final authState = ref.watch(authProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: AuthContainer(
        title: "Login",
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200
                          )
                        )
                      ),
                      child: Autocomplete(
                        optionsBuilder: (TextEditingValue value) async {
                          if (value.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          var emails = await ref.read(authProvider.notifier).showSubmittedEmails();
                    
                          return emails.where((email) {
                            return email.toLowerCase().contains(value.text.toLowerCase());
                          }).take(4);
                        },
                        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                          _emailController = textEditingController;
                    
                          return TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: colors.onSurface.withAlpha(100)
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(0)
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan email anda';
                              }

                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Masukkan email valid';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    AuthInputComponent(
                      controller: _passwordController, 
                      hinText: "Password",
                      action: TextInputAction.done,
                      isLast: true,
                      isPassword: true,
                      isTextObscure: _obscureText,
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Masukkan password anda";
                        }

                        return null;
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  _onSubmitText();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Center(
                    child: authState.isLoading 
                      ? SizedBox(
                          height: 45,
                          width: 45,
                          child: Center(
                            child: CircularProgressIndicator(color: colors.onPrimary)
                          ),
                        )
                      : Text(
                          'Login',
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
                    'Belum punya akun? ',
                    style: TextStyle(
                      color: colors.secondary
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go("/register");
                    },
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        color: colors.primary
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () async {
                  ref.read(authProvider.notifier).loginWithGoogle();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: colors.primary),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login With Google',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}