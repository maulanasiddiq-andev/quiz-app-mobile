import 'package:flutter/material.dart';

class AuthInputComponent extends StatelessWidget {
  final TextEditingController controller;
  final String hinText;
  final TextInputType keyboardType;
  final TextInputAction action;
  final String? Function(String? value)? validator;
  final bool isLast;

  // for password
  final bool isPassword;
  final bool isTextObscure;
  final Function? onTap;
  const AuthInputComponent({
    super.key,
    required this.controller,
    required this.hinText,
    this.keyboardType = TextInputType.text,
    this.action = TextInputAction.next,
    this.validator,
    this.isPassword = false,
    this.isTextObscure = false,
    this.onTap,
    this.isLast = false
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        border: isLast
          ? null
          : Border(
              bottom: BorderSide(
                color: Colors.grey.shade200
              )
            )
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: action,
              obscureText: isTextObscure,
              decoration: InputDecoration(
                isDense: true,
                hintText: hinText,
                hintStyle: TextStyle(
                  color: colors.secondary
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0)
              ),
              validator: validator,
            ),
          ),
          isPassword
            ? GestureDetector(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }
                }, 
                child: Icon(isTextObscure ? Icons.visibility_off : Icons.visibility)
              )
            : SizedBox()
        ],
      ),
    );
  }
}