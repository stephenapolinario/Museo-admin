import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/routes.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/providers/quiz.dart';
import 'package:museo_admin_application/services/quiz_service.dart';
import 'package:museo_admin_application/utilities/check_regex_color.dart';
import 'package:provider/provider.dart';

bool isAtLeastOneOptionChecked(List<Option> options) {
  return options.any((option) => option.isCorrect);
}

class QuizCreateQuestionScreen extends StatefulWidget {
  const QuizCreateQuestionScreen({
    super.key,
  });

  @override
  State<QuizCreateQuestionScreen> createState() =>
      _QuizCreateQuestionScreenState();
}

class _QuizCreateQuestionScreenState extends State<QuizCreateQuestionScreen> {
  final quizInformationCreateKey = GlobalKey<FormState>();
  late String? question, color;
  late double? rssi;
  late QuizProvider quizProvider;

  final List<Question> questions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quizProvider = Provider.of<QuizProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.create_quiz_question_screen_title),
      ),
      body: body(),
      floatingActionButton: floatingButtons(),
    );
  }

  Widget body() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: quizInformationCreateKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return _buildQuizForm(questions[index]);
          },
        ),
      ),
    );
  }

  Row floatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedOpacity(
          opacity: questions.isNotEmpty ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (questions.isNotEmpty) {
                    questions.removeLast();
                  }
                });
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.remove),
            ),
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              questions.add(
                Question(
                  question: '',
                  color: '',
                  options: [
                    Option(
                      answer: '',
                      isCorrect: false,
                    )
                  ],
                ),
              );
            });
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildQuizForm(Question quiz) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        questionInput(context, quiz),
        const SizedBox(height: 15),
        colorInput(context, quiz),
        const SizedBox(height: 10),
        optionInputs(quiz),
        addOption(quiz),
        quiz == questions.last
            ? Center(child: enterButton(context))
            : const SizedBox.shrink(),
      ],
    );
  }

  TextButton addOption(Question quiz) {
    return TextButton(
      onPressed: () {
        setState(() {
          quiz.options.add(
            Option(
              answer: '',
              isCorrect: false,
            ),
          );
        });
      },
      child: Text(
        context.loc.quiz_screen_add_option_input,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget optionInputs(Question quiz) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: quiz.options.asMap().entries.map((entry) {
        final int optionIndex = entry.key;
        return _buildOptionField(quiz, optionIndex);
      }).toList(),
    );
  }

  Widget _buildOptionField(Question quiz, int optionIndex) {
    // Create a FocusNode for the TextFormField
    final screenWidth = MediaQuery.of(context).size.width;
    final inputWidth = screenWidth * 0.62;

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${context.loc.quiz_screen_option_color_input} ${optionIndex + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: inputWidth,
              child: TextFormField(
                initialValue: quiz.options[optionIndex].answer,
                decoration: InputDecoration(
                  hintText: context.loc.quiz_screen_option_color_hint,
                  contentPadding: const EdgeInsets.only(left: 10),
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    quiz.options[optionIndex].answer = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.loc.quiz_screen_option_color_valid_error;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10), // Add this line for additional space
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        context.loc.quiz_screen_correct_option_input,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Checkbox(
                        value: quiz.options[optionIndex].isCorrect,
                        onChanged: (value) {
                          setState(() {
                            for (var i = 0; i < quiz.options.length; i++) {
                              if (i == optionIndex) {
                                quiz.options[i].isCorrect = true;
                              } else {
                                quiz.options[i].isCorrect = false;
                              }
                            }
                          });
                        },
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.blue;
                          }
                          return Colors.white;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                      width: 10), // Add this line for additional space
                  Column(
                    children: [
                      Text(
                        context.loc.quiz_screen_delete_option_input,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors
                              .red, // Change the color of the delete icon to red
                        ),
                        onPressed: () {
                          setState(() {
                            if (quiz.options.length > 1) {
                              quiz.options.removeAt(optionIndex);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget questionInput(BuildContext context, Question quiz) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.quiz_screen_question_question_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: quiz.question,
          decoration: InputDecoration(
            hintText: context.loc.quiz_screen_question_question_hint,
            contentPadding: const EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return context.loc.quiz_screen_question_question_valid_error;
            }
            return null;
          },
          onChanged: (value) {
            quiz.question = value;
          },
        ),
      ],
    );
  }

  Widget colorInput(BuildContext context, Question quiz) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.quiz_screen_question_color_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: quiz.color,
          decoration: InputDecoration(
            hintText: context.loc.quiz_screen_question_color_hint,
            contentPadding: const EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            quiz.color = value;
          },
          validator: (value) {
            if (value != null) {
              if (!isHexColor(value)) {
                return context.loc.quiz_screen_question_color_valid_error;
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget enterButton(BuildContext context) {
    return Column(
      children: [
        // Enter
        const SizedBox(height: 20),
        TextButton(
          child: Text(
            context.loc.quiz_screen_create_quiz_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = quizInformationCreateKey.currentState!.validate();

            if (isValid) {
              if (isAtLeastOneOptionChecked(questions.last.options)) {
                quizProvider.saveQuestion(newQuestions: questions);
                final response = await QuizService().create(context);

                if (context.mounted) {
                  await loadingMessageTime(
                    title: response == EnumQuiz.success
                        ? context.loc.create_quiz_question_success_title
                        : context.loc.create_quiz_question_error_title,
                    subtitle: response == EnumQuiz.success
                        ? context.loc.create_quiz_question_success_content
                        : context.loc.create_quiz_question_error_content,
                    context: context,
                  );
                  response == EnumQuiz.success
                      ? navigator.popAndPushNamed(quiz)
                      : null;
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.loc.quiz_screen_none_correct_valid_error,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
