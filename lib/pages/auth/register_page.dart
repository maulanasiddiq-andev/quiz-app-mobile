import 'package:flutter/material.dart';
import 'package:quiz_app/components/auth_input_component.dart';
import 'package:quiz_app/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 45
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'MS Developer video app',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 20
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)
                    )
                  ),
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
                                hinText: "Name",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan nama anda';
                                  }

                                  return null;
                                },
                              ),
                              AuthInputComponent(
                                controller: _usernameController, 
                                hinText: "Username",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukkan username anda';
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
                          onTap: () {
                            // _onSubmitText();
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(
                              child: Text(
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
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => LoginPage())
                                );
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
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}