import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/components/connection_check_component.dart';
import 'package:quiz_app/components/custom_appbar_component.dart';
import 'package:quiz_app/components/custom_button_component.dart';
import 'package:quiz_app/components/input_component.dart';
import 'package:quiz_app/components/pick_image_component.dart';
import 'package:quiz_app/components/select_data_component.dart';
import 'package:quiz_app/constants/action_constant.dart';
import 'package:quiz_app/constants/resource_constant.dart';
import 'package:quiz_app/constants/select_data_constant.dart';
import 'package:quiz_app/notifiers/quiz/quiz_create_notifier.dart';
import 'package:quiz_app/states/quiz/quiz_create_state.dart';

class QuizDetailCreatePage extends ConsumerStatefulWidget {
  const QuizDetailCreatePage({super.key});

  @override
  ConsumerState<QuizDetailCreatePage> createState() =>
      _QuizDetailCreatePageState();
}

class _QuizDetailCreatePageState extends ConsumerState<QuizDetailCreatePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void _syncControllers(QuizCreateState? previous, QuizCreateState next) {
    final updates = {
      titleController: next.title,
      descriptionController: next.description,
      timeController: next.time != 0 ? next.time.toString() : '',
    };

    for (final entry in updates.entries) {
      final controller = entry.key;
      final newText = entry.value;
      if (controller.text != newText) {
        controller.text = newText;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizCreateProvider);
    final notifier = ref.read(quizCreateProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    ref.listen(quizCreateProvider, (previous, next) {
      if (previous != next) _syncControllers(previous, next);
    });

    return Scaffold(
      appBar: CustomAppbarComponent(title: "Buat Kuis"),
      body: ConnectionCheckComponent(
        child: state.isLoadingCategories
            ? Center(child: CircularProgressIndicator(color: colors.primary))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            spacing: 15,
                            children: [
                              InputComponent(
                                title: "Judul Kuis",
                                controller: titleController,
                                action: TextInputAction.next,
                                onChanged: (value) => notifier.updateTitle(value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Judul kuis harus diisi";
                                  }

                                  return null;
                                },
                              ),
                              InputComponent(
                                title: "Deskripsi Kuis",
                                controller: descriptionController,
                                action: TextInputAction.next,
                                onChanged: (value) => notifier.updateDescription(value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Deskripsi kuis harus diisi";
                                  }

                                  return null;
                                },
                              ),
                              InputComponent(
                                title: "Waktu pengerjaan kuis (menit)",
                                controller: timeController,
                                textInputType: TextInputType.number,
                                action: TextInputAction.next,
                                onChanged: (value) => notifier.updateTime(int.parse(value)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Waktu pengerjaan kuis harus diisi";
                                  }

                                  return null;
                                },
                              ),
                              SelectDataComponent(
                                title: "Kategori",
                                data: SelectDataConstant.category,
                                selectedData: state.category,
                                onSelected: (value) {
                                  notifier.selectCategory(value);
                                },
                              ),
                              PickImageComponent(
                                pickImage: () => notifier.pickDescriptionImage(
                                  colors.primary,
                                  colors.onPrimary,
                                ),
                                image: state.image,
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: CustomButtonComponent(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          context.push("/${ResourceConstant.quiz}/${ActionConstant.create}/${ResourceConstant.question}");
                        }
                      },
                      text: "Buat pertanyaan",
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
