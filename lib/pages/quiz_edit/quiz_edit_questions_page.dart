import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/quiz_edit_component.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/quiz_edit/quiz_edit_notifier.dart';

class QuizEditQuestionsPage extends ConsumerStatefulWidget {
  final String quizId;
  const QuizEditQuestionsPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizEditQuestionsPage> createState() => _QuizEditQuestionsPageState();
}

class _QuizEditQuestionsPageState extends ConsumerState<QuizEditQuestionsPage> {
  final CarouselSliderController carouselController = CarouselSliderController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizEditProvider(widget.quizId));
    final notifier = ref.read(quizEditProvider(widget.quizId).notifier);
    final quiz = state.quiz;
    
    return Scaffold(
      appBar: CustomAppbarComponent(title: "Buat Kuis"),
      body: ConnectionCheckComponent(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: CarouselSlider.builder(
                  carouselController: carouselController,
                  itemCount: quiz!.questions.length,
                  itemBuilder: (context, index, realIndex) {
                    return QuestionEditComponent(
                      quizId: widget.quizId,
                      question: quiz.questions[index],
                      questionIndex: index,
                      questionsCount: quiz.questions.length,
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
              quiz.questions.length > 1
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
                      onTap: () {
                        // to review quiz page
                        if (formKey.currentState!.validate()) {
                          context.push("/${ResourceConstant.quiz}/${ActionConstant.edit}/${widget.quizId}/${ResourceConstant.question}/${ActionConstant.review}");
                        }
                      }, 
                      icon: Icons.save
                    )
                  ),
                  Expanded(
                    child: QuizNavigationButtonComponent(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (state.questionIndex < quiz.questions.length - 1) {
                            carouselController.animateToPage(state.questionIndex + 1);
                          } else {
                            notifier.addQuestion();
                            carouselController.animateToPage(state.questionIndex + 1);
                          } 
                        }
                      }, 
                      icon: state.questionIndex < quiz.questions.length - 1
                        ? Icons.arrow_forward
                        : Icons.add,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}