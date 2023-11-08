import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/routes.dart';

class QuizControl {
  final int id;
  final String name;
  final IconData icon;
  final Color? iconColor, textColor;
  final Function(BuildContext context) onTouch;

  QuizControl({
    required this.id,
    required this.name,
    required this.icon,
    required this.onTouch,
    this.iconColor,
    this.textColor,
  });
}

quizControlInformation(String route) {
  return QuizControl(
    id: 1,
    name: 'Informações básicas',
    icon: Icons.info,
    onTouch: (BuildContext context) {
      Navigator.of(context).pushNamed(route);
    },
  );
}

quizControlQuestions(String route) {
  return QuizControl(
    id: 2,
    name: 'Questões',
    icon: Icons.question_answer_outlined,
    onTouch: (BuildContext context) {
      Navigator.of(context).pushNamed(route);
    },
  );
}

final List<QuizControl> quizCreateControls = [
  quizControlInformation(quizCreateInformation),
  quizControlQuestions(quizCreateQuestions),
];

final List<QuizControl> quizUpdateControls = [
  quizControlInformation(quizUpdateInformation),
  quizControlQuestions(quizUpdateQuestions),
];
