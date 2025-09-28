import 'package:flutter/material.dart';
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
    return Center(
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
    );
  }
}