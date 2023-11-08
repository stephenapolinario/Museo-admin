import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/models/quiz/quiz_control.dart';
import 'package:museo_admin_application/providers/quiz.dart';
import 'package:museo_admin_application/screens/quiz/quiz_update_information_screen.dart';
import 'package:museo_admin_application/screens/quiz/quiz_update_question_screen.dart';
import 'package:provider/provider.dart';

class QuizUpdateHomeScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizUpdateHomeScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizUpdateHomeScreen> createState() => _QuizUpdateHomeScreenState();
}

class _QuizUpdateHomeScreenState extends State<QuizUpdateHomeScreen> {
  late QuizProvider quizProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quizProvider = Provider.of<QuizProvider>(context, listen: false);
      if (quizProvider.isUpdating) {
        quizProvider.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.quiz_update_home_screen),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: quizCreateControls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final option = quizCreateControls[index];
              return quizControlWidget(
                option: option,
                parentContext: parentContext,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget quizControlWidget({
    required QuizControl option,
    required BuildContext parentContext,
  }) {
    return InkWell(
      onTap: () async {
        switch (option.id) {
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => QuizUpdateInformationScreen(
                  currentQuiz: widget.quiz,
                ),
              ),
            );
          case 2:
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => QuizUpdateScreen(
                  currentQuiz: widget.quiz,
                ),
              ),
            );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: mainMenuItemsColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              option.name,
              style: TextStyle(
                color: option.textColor,
              ),
            ),
            Icon(
              option.icon,
              size: 50,
              color: option.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
