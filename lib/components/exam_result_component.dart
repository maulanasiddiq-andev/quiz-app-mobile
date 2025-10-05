import 'package:flutter/material.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/models/quiz_exam/quiz_exam_model.dart';
import 'package:quiz_app/utils/format_time.dart';

class ExamResultComponent extends StatefulWidget {
  final QuizExamModel quizExam;
  const ExamResultComponent({super.key, required this.quizExam});

  @override
  State<ExamResultComponent> createState() => _ExamResultComponentState();
}

class _ExamResultComponentState extends State<ExamResultComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Jawaban benar: "),
                    Text(widget.quizExam.trueAnswers.toString())
                  ],
                ),
                Row(
                  children: [
                    Text("Nilai: "),
                    Text(widget.quizExam.score.toString())
                  ],
                ),
                Row(
                  children: [
                    Text("Durasi Pengerjaan: "),
                    Text(formatTime(widget.quizExam.duration))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomButtonComponent(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              text: "Kembali"
            )
          )
        ],
      ),
    );
  }
}