import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/quiz/quiz_control.dart';
import 'package:museo_admin_application/providers/quiz.dart';
import 'package:provider/provider.dart';

class QuizCreateHomeScreen extends StatefulWidget {
  final Function onUpdate;

  const QuizCreateHomeScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<QuizCreateHomeScreen> createState() => _QuizCreateHomeScreenState();
}

class _QuizCreateHomeScreenState extends State<QuizCreateHomeScreen> {
  late QuizProvider quizProvider;

  @override
  void initState() {
    quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.isUpdating ? quizProvider.clear() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.quiz_create_home_screen),
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
        if (option.id == 2 && !quizProvider.isUpdating) {
          await loadingMessageTime(
            title: context.loc.quiz_create_information_first_title,
            subtitle: context.loc.quiz_create_information_first_content,
            context: context,
          );
        } else {
          option.onTouch(parentContext);
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
