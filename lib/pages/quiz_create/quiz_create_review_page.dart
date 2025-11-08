import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/detail_field_component.dart';
import 'package:quiz_app/components/pick_image_component.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';
import 'package:quiz_app/styles/text_style.dart';

class QuizCreateReviewPage extends ConsumerStatefulWidget {
  const QuizCreateReviewPage({super.key});

  @override
  ConsumerState<QuizCreateReviewPage> createState() => _QuizCreateReviewPageState();
}

class _QuizCreateReviewPageState extends ConsumerState<QuizCreateReviewPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Review Kuis"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    SizedBox(),
                    DetailFieldComponent(fieldName: "Judul Kuis", content: state.title),
                    DetailFieldComponent(fieldName: "Deskripsi Kuis", content: state.description),
                    DetailFieldComponent(fieldName: "Kategori Kuis", content: state.category?.name),
                    DetailFieldComponent(fieldName: "Waktu Pengerjaan Kuis", content: state.time.toString()),
                    PickImageComponent(
                      pickImage: () {},
                      image: state.image,
                    ),
                    ...state.questions.asMap().entries.map((entry) {
                      final question = entry.value;
                      final index = entry.key + 1;
                
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.onSurface),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Pertanyaan $index/${state.questions.length}",
                                style: CustomTextStyle.defaultBoldTextStyle,
                              ),
                            ),
                            Text(
                              question.text,
                              style: CustomTextStyle.defaultTextStyle,
                            ),
                            if (question.image != null)
                              PickImageComponent(
                                pickImage: () {},
                                image: question.image,
                              ),
                            RadioGroup(
                              groupValue: question.trueAnswerIndex,
                              onChanged: (int? value) {
                                // notifier.determineTrueAnswer(value);
                              },
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Jawaban",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),  
                                  ),
                                  for (var i = 0; i < question.answers.length; i++)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Radio(value: i),
                                        Expanded(
                                          child: DetailFieldComponent(
                                            fieldName: "Jawaban ${i + 1}", 
                                            content: question.answers[i].text
                                          )
                                        )
                                      ],
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    SizedBox()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomButtonComponent(
              isLoading: state.isLoadingCreate,
              onTap: () async {
                final result = await notifier.createQuiz();

                if (result == true && context.mounted) {
                  // back to list page
                  context.go("/${ResourceConstant.quiz}");
                }
              },
              text: "Buat",
            ),
          )
        ],
      ),
    );
  }
}