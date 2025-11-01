import 'package:flutter/material.dart';

class DetailFieldComponent extends StatelessWidget {
  final String fieldName;
  final String? content;
  const DetailFieldComponent({
    super.key,
    required this.fieldName,
    required this.content  
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          content == null || content!.isEmpty ? "-" : content!,
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ],
    );
  }
}