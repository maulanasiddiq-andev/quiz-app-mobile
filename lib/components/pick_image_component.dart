import 'dart:io';
import 'package:flutter/material.dart';

class PickImageComponent extends StatelessWidget {
  final Function pickImage;
  final File? image;
  const PickImageComponent({super.key, required this.pickImage, this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => pickImage(),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: image == null
              ? Border.all(color: colors.onSurface)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: image == null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                ),
                child: Center(
                  child: Column(
                    spacing: 10,
                    children: [
                      Icon(Icons.image),
                      Text("Ambil Gambar"),
                    ],
                  ),
                ),
              )
            : ClipRRect(
                borderRadius:
                    BorderRadiusGeometry.circular(10),
                child: Image.file(image!),
              ),
      ),
    );
  }
}