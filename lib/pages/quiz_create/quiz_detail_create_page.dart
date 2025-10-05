import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';
import 'package:quiz_app/pages/quiz_create/quiz_question_create_page.dart';

class QuizDetailCreatePage extends ConsumerStatefulWidget {
  const QuizDetailCreatePage({super.key});

  @override
  ConsumerState<QuizDetailCreatePage> createState() => _QuizDetailCreatePageState();
}

class _QuizDetailCreatePageState extends ConsumerState<QuizDetailCreatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppbarComponent(
        "Buat Detail Kuis",
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary
      ),
      body: state.isLoadingCategories
        ? Center(
            child: CircularProgressIndicator(color: colors.primary),
          )
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      spacing: 15,
                      children: [
                        InputComponent(
                          title: "Judul Kuis", 
                          controller: titleController
                        ),
                        InputComponent(
                          title: "Deskripsi Kuis", 
                          controller: descriptionController
                        ),
                        InputComponent(
                          title: "Waktu pengerjaan kuis (menit)", 
                          controller: timeController,
                          textInputType: TextInputType.number,
                        ),
                        state.categories.isNotEmpty
                        ? DropdownButton<String>(
                            value: selectedCategoryId,
                            items: state.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.categoryId,
                                child: Text(category.name),
                              );
                            }).toList(), 
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryId = value ?? "";
                              });
                            },
                          )
                        : SizedBox()
                      ],
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomButtonComponent(
                  onTap: () {
                    ref.read(quizCreateProvider.notifier).createDescription(
                      selectedCategoryId!,
                      titleController.text, 
                      descriptionController.text, 
                      int.parse(timeController.text)
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizQuestionCreatePage(),
                      ),
                    );
                  }, 
                  text: "Buat pertanyaan"
                )
              )
            ],
          ),
    );
  }
}