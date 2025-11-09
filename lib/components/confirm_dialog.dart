import 'package:flutter/material.dart';

Future<bool> confirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  Function? onConfirm,
  Function? onDecline
}) async {
  final result = await showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (onDecline != null) {
                onDecline();
              }
              // close the dialog
              Navigator.of(context).pop(false);
            },
            child: Text("Tidak", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              // close the dialog
              Navigator.of(context).pop(true);
            },
            child: Text("Ya", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    }
  );

  return result ?? false;
}