import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/question_create_component.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';

class QuizQuestionCreatePage extends ConsumerStatefulWidget {
  const QuizQuestionCreatePage({super.key});

  @override
  ConsumerState<QuizQuestionCreatePage> createState() => _QuizQuestionCreatePageState();
}

class _QuizQuestionCreatePageState extends ConsumerState<QuizQuestionCreatePage> {
  final CarouselSliderController carouselController = CarouselSliderController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);

    return Scaffold(
      appBar: customAppbarComponent(
        "Buat pertanyaan",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: state.questions.length,
                itemBuilder: (context, index, realIndex) {
                  return QuestionCreateComponent(
                    question: state.questions[index],
                    questionIndex: index,
                    questionsCount: state.questions.length,
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  padEnds: false,
                  height: double.infinity,
                  initialPage: state.questionIndex,
                  onPageChanged: (index, reason) {
                    notifier.changeQuestionIndex(index);
                  },
                ),
              )
            ),
            state.questions.length > 1
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: CustomButtonComponent(
                    onTap: () {
                      notifier.deleteQuestion();
                      carouselController.animateToPage(state.questionIndex);
                    }, 
                    text: "Hapus Pertanyaan",
                    isError: true,
                  ),
                )
              : SizedBox(),
            Row(
              children: [
                Expanded(
                  child: QuizNavigationButtonComponent(
                    onTap: () {
                      if (state.questionIndex > 0) {
                        carouselController.animateToPage(state.questionIndex - 1);
                      }
                    }, 
                    icon: Icons.arrow_back,
                  ),
                ),
                Expanded(
                  child: QuizNavigationButtonComponent(
                    onTap: () async {
                      final result = await notifier.createQuiz();
        
                      if (result && context.mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }, 
                    icon: Icons.save
                  )
                ),
                Expanded(
                  child: QuizNavigationButtonComponent(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (state.questionIndex < state.questions.length - 1) {
                          carouselController.animateToPage(state.questionIndex + 1);
                        } else {
                          notifier.addQuestion();
                          carouselController.animateToPage(state.questionIndex + 1);
                        } 
                      }
                    }, 
                    icon: state.questionIndex < state.questions.length - 1
                      ? Icons.arrow_forward
                      : Icons.add,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}