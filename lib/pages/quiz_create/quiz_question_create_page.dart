import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/detail_field_component.dart';
import 'package:quiz_app/components/question_create_component.dart';
import 'package:quiz_app/components/quiz_navigation_button_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';
import 'package:quiz_app/styles/text_style.dart';

class QuizQuestionCreatePage extends ConsumerStatefulWidget {
  const QuizQuestionCreatePage({super.key});

  @override
  ConsumerState<QuizQuestionCreatePage> createState() => _QuizQuestionCreatePageState();
}

class _QuizQuestionCreatePageState extends ConsumerState<QuizQuestionCreatePage> {
  final CarouselSliderController carouselController = CarouselSliderController();
  final formKey = GlobalKey<FormState>();

  Future<void> askAIRecommendation() async {
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(0)
          ),
          child: AskAIComponent(),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);

    return Scaffold(
      appBar: CustomAppbarComponent(
        title: "Buat Kuis",
        actions: [
          IconButton(
            onPressed: askAIRecommendation, 
            icon: Icon(Icons.auto_awesome)
          )
        ],
      ),
      body: ConnectionCheckComponent(
        child: Form(
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
                      onTap: () {
                        // to review quiz page
                        context.push("/${ResourceConstant.quiz}/${ActionConstant.create}/${ResourceConstant.question}/${ActionConstant.review}");
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
      )
    );
  }
}

class AskAIComponent extends ConsumerStatefulWidget {
  const AskAIComponent({super.key});

  @override
  ConsumerState<AskAIComponent> createState() => _AskAIComponentState();
}

class _AskAIComponentState extends ConsumerState<AskAIComponent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(quizCreateProvider.notifier);
      notifier.askAIRecommendation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Text(
            "Rekomendasi AI",
            style: TextStyle(
              fontSize: 18
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.onSurface
                )
              ),
              child: SingleChildScrollView(
                child: state.isLoadingRecommendation == true || state.recommendedQuestion == null
                  ? Text("Berpikir...")
                  : Column(
                      spacing: 10,
                      children: [
                        Text(
                          state.recommendedQuestion!.text,
                          style: CustomTextStyle.defaultTextStyle,  
                        ),
                        RadioGroup(
                          groupValue: state.recommendedQuestion!.trueAnswerIndex,
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
                              for (var i = 0; i < state.recommendedQuestion!.answers.length; i++)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Radio(value: i),
                                    Expanded(
                                      child: DetailFieldComponent(
                                        fieldName: "Jawaban ${i + 1}", 
                                        content: state.recommendedQuestion!.answers[i].text
                                      )
                                    )
                                  ],
                                )
                            ],
                          ),
                        )
                      ],  
                    ),
              ),
            )
          ),
          // show the comfirmation buttons after the recommended question is generated by AI
          if (!state.isLoadingRecommendation && state.recommendedQuestion != null)
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomButtonComponent(
                    onTap: () {
                      notifier.applyAIRecommendation();
                      Navigator.of(context).pop();
                    }, 
                    text: "Terapkan"
                  ),
                ),
                Expanded(
                  child: CustomButtonComponent(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    isError: true, 
                    text: "Batalkan"
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}