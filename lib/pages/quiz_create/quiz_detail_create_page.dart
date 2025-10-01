import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
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
  TextEditingController timeController = TextEditingController(text: "0");
  String selectedCategoryId = "";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);

    return Scaffold(
      appBar: customAppbarComponent("Buat Detail Kuis"),
      body: state.isLoadingCategories
        ? Center(
            child: CircularProgressIndicator(color: Colors.blue),
          )
        : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      spacing: 15,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "Judul Kuis"
                          ),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            hintText: "Deskripsi Kuis"
                          ),
                        ),
                        TextField(
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Waktu Pengerjaan Kuis"
                          ),
                        ),
                        DropdownButton<String>(
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
                      ],
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Future.microtask(() {
                      ref.read(quizCreateProvider.notifier).createDescription(
                        selectedCategoryId,
                        titleController.text, 
                        descriptionController.text, 
                        int.parse(timeController.text)
                      );
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizQuestionCreatePage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        'Buat pertanyaan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ),
                )
              )
            ],
          ),
    );
  }
}