import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/emblem.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/screens/quiz/quiz_create_home_screen.dart';
import 'package:museo_admin_application/screens/quiz/quiz_update_home_screen.dart';
import 'package:museo_admin_application/services/emblem_service.dart';
import 'package:museo_admin_application/services/quiz_service.dart';
import 'package:museo_admin_application/utilities/check_quiz_emblems.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class CommonData {
  List<Quiz> quizzes;
  List<Emblem> emblems;

  CommonData({
    required this.quizzes,
    required this.emblems,
  });
}

class QuisListScreen extends StatefulWidget {
  const QuisListScreen({super.key});

  @override
  State<QuisListScreen> createState() => QuisListScreenState();
}

class QuisListScreenState extends State<QuisListScreen> {
  late StreamController<List<Quiz>> _quizStreamController;
  Stream<List<Quiz>> get onListQuizChanged => _quizStreamController.stream;

  late StreamController<List<Emblem>> _emblemStreamController;
  Stream<List<Emblem>> get onListemblemChanged =>
      _emblemStreamController.stream;

  @override
  void initState() {
    super.initState();
    _quizStreamController = StreamController<List<Quiz>>.broadcast();
    _emblemStreamController = StreamController<List<Emblem>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _quizStreamController.close();
    _emblemStreamController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  void fetchData() async {
    List<Quiz> quizzes = await QuizService().readAll(context);
    _quizStreamController.sink.add(quizzes);

    if (context.mounted) {
      List<Emblem> emblems = await EmblemService().readAll(context);
      _emblemStreamController.sink.add(emblems);
    }
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
        child: StreamBuilder<List<Quiz>>(
          stream: onListQuizChanged,
          builder: (context, quizSnapshot) {
            if (!quizSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            List<Quiz> quizzes = quizSnapshot.data ?? [];

            return StreamBuilder<List<Emblem>>(
              stream: onListemblemChanged,
              builder: (context, emblemSnapshot) {
                if (!emblemSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                List<Emblem> emblems = emblemSnapshot.data ?? [];
                CommonData commonData =
                    CommonData(quizzes: quizzes, emblems: emblems);

                return quizListWidget(commonData.quizzes, commonData.emblems);
              },
            );
          },
        ),
      ),
    );
  }

  Widget quizListWidget(List<Quiz> quizList, List<Emblem> emblemList) {
    return SingleChildScrollView(
      child: Column(
        children: quizList.map((currentQuiz) {
          List<Emblem> matchingEmblems = emblemList.where((emblem) {
            return currentQuiz.id == emblem.quiz?.id;
          }).toList();

          bool emblemsCoverPoints = checkEmblemRanges(matchingEmblems);
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
                  !emblemsCoverPoints
                      ? const Text(
                          'ATENÇÃO: Quiz faltando emblemas!',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )
                      : const SizedBox.shrink()
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
