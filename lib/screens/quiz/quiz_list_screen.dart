import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/screens/quiz/quiz_create_home_screen.dart';
import 'package:museo_admin_application/screens/quiz/quiz_update_home_screen.dart';
import 'package:museo_admin_application/services/quiz_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class QuisListScreen extends StatefulWidget {
  const QuisListScreen({super.key});

  @override
  State<QuisListScreen> createState() => QuisListScreenState();
}

class QuisListScreenState extends State<QuisListScreen> {
  late Quiz quiz;

  late StreamController<List<Quiz>> _quizStreamController;
  Stream<List<Quiz>> get onListQuizChanged => _quizStreamController.stream;

  @override
  void initState() {
    super.initState();
    _quizStreamController = StreamController<List<Quiz>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _quizStreamController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  void fetchData() async {
    List<Quiz> data = await QuizService().readAll(context);
    _quizStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.quiz_screen_title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => QuizCreateHomeScreen(
                    onUpdate: () {
                      fetchData();
                    },
                  ),
                ),
              )
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: StreamBuilder<List<Quiz>?>(
          stream: onListQuizChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Quiz> quizList = snapshot.data!;
              return quizListWidget(quizList);
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget quizListWidget(List<Quiz> quizList) {
    return SingleChildScrollView(
      child: Column(
        children: quizList.map((currentQuiz) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentQuiz.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.quiz,
                color: Colors.black,
              ),
              title: Text(
                currentQuiz.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuiz.beacon == null
                        ? "Beacon deletado"
                        : "Beacon ${currentQuiz.beacon?.name.toCapitalizeEveryInitialWord()}",
                    style: TextStyle(
                      color: currentQuiz.beacon == null
                          ? Colors.red
                          : mainItemContentColor,
                    ),
                  ),
                  Text(
                    currentQuiz.tour == null
                        ? "Tour deletado"
                        : "Tour ${currentQuiz.tour?.title.toCapitalizeFirstWord()}",
                    style: TextStyle(
                      color: currentQuiz.tour == null
                          ? Colors.red
                          : mainItemContentColor,
                    ),
                  ),
                ],
              ),
              // subtitle: Text(
              //   'Tour ${currentQuiz.tour.title.toCapitalizeFirstWord()}\nBeacon ${currentQuiz.beacon.name.toCapitalizeEveryInitialWord()}',
              //   style: const TextStyle(
              //     color: mainItemContentColor,
              //   ),
              // ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              QuizUpdateHomeScreen(
                            quiz: currentQuiz,
                          ),
                        ),
                      );
                    },
                    child: Text(context.loc.pop_menu_button_update),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      final wantDelete = await showGenericDialog(
                        context: context,
                        title: context.loc.quiz_sure_want_delete_title,
                        content: context.loc.quiz_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await QuizService().delete(
                          context,
                          currentQuiz,
                        );
                        fetchData();
                      }
                    },
                    child: Text(
                      context.loc.pop_menu_button_delete,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
