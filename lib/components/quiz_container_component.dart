import 'package:flutter/material.dart';
import 'package:quiz_app/components/profile_image_component.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';

class QuizContainerComponent extends StatelessWidget {
  final Function onTap;
  final QuizModel quiz;
  const QuizContainerComponent({
    super.key,
    required this.onTap,
    required this.quiz
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colors.onSurface),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quiz.title, style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text(
              "Kategori: ${quiz.category!.name}"
            ),
            quiz.imageUrl != null
              ? Column(
                  children: [
                    SizedBox(height: 10),
                    Image.network(
                      quiz.imageUrl!,
                      width: double.infinity,
                    ),
                    SizedBox(height: 10),
                  ],
                )
              : SizedBox(height: 10),
            Text("Dikerjakan: ${quiz.historiesCount} kali"),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Text("Oleh:"),
                ProfileImageComponent(
                  radius: 10,
                ),
                Text(quiz.user?.name ?? "Penyusun")
              ],
            )
          ],
        ),
      ),
    );
  }
}