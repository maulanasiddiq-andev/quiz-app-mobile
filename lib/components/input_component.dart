import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final int? maxLength;
  final TextInputAction? action;
  final Function(String value)? onChanged;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final String? Function(String? value)? validator;
  final bool enabled;

  const InputComponent({
    super.key, 
    required this.title,
    required this.controller,
    this.maxLength,
    this.action,
    this.onChanged,
    this.focusNode,
    this.validator,
    this.textInputType = TextInputType.text,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      cursorColor: colors.primary,
      maxLines: null,
      maxLength: maxLength,
      keyboardType: textInputType,
      textInputAction: action,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text(title),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.secondary
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.primary
          )
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.error
          )
        )
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      validator: validator,
    );
  }
}