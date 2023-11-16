import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/color.dart';
import 'package:museo_admin_application/helpers/color_pick.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/services/emblem_service.dart';
import 'package:museo_admin_application/services/quiz_service.dart';

class EmblemCreateScreen extends StatefulWidget {
  final Function onUpdate;

  const EmblemCreateScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<EmblemCreateScreen> createState() => _EmblemCreateScreenState();
}

class _EmblemCreateScreenState extends State<EmblemCreateScreen> {
  final emblemCreateKey = GlobalKey<FormState>();

  late List<Quiz> quizzes;
  late String? title, image;
  late Quiz? selectedQuiz;
  late int? minPoints, maxPoints;
  Color? color;
  bool submit = false;

  // To prevent reload
  late Future<void> fetchDataFuture;

  late List<DropdownMenuItem<Quiz>> quizzesItems;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    quizzes = await QuizService().readAll(context);

    if (context.mounted) {
      quizzesItems = quizzes.map<DropdownMenuItem<Quiz>>((Quiz value) {
        return DropdownMenuItem<Quiz>(
          value: value,
          child: Text(value.title), // Display the appropriate value
        );
      }).toList();
    }
  }

  void onUpdateColor(Color value) {
    setState(() {
      color = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.create_emblem_screen_title),
      ),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      fields(context),
                      enterButton(context),
                    ],
                  ),
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
          }
        },
      ),
    );
  }

  Widget fields(BuildContext context) {
    return Form(
      key: emblemCreateKey,
      // autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          titleInput(context),
          const SizedBox(height: 15),
          imageInput(context),
          const SizedBox(height: 15),
          minPointsInput(context),
          const SizedBox(height: 15),
          maxPointsInput(context),
          const SizedBox(height: 15),
          colorInput(context),
          const SizedBox(height: 15),
          quizInput(context),
        ],
      ),
    );
  }

  Widget titleInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.emblem_title_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.create_emblem_title_hint,
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
            if (value == null || value == '') {
              return context.loc.emblem_title_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            title = newValue;
          }),
        ),
      ],
    );
  }

  Widget imageInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.emblem_image_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.emblem_image_hint,
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
                // width: 2,
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
            if (value != null) {
              bool validURL = Uri.tryParse(value)?.hasAbsolutePath ?? false;
              if (!validURL) {
                return context.loc.emblem_image_not_valid;
              }
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            image = newValue;
          }),
        ),
      ],
    );
  }

  Widget minPointsInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.emblem_minpoints_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: context.loc.emblem_minpoints_hint,
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
                // width: 2,
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
            final n = num.tryParse(value!);
            if (n == null || n < 0 || n > 100) {
              return context.loc.emblem_minpoints_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            minPoints = int.tryParse(newValue!);
          }),
        ),
      ],
    );
  }

  Widget maxPointsInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.emblem_maxpoints_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: context.loc.emblem_maxpoints_hint,
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
                // width: 2,
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
            final n = num.tryParse(value!);
            if (n == null || n < 0 || n > 100) {
              return context.loc.emblem_maxpoints_not_valid;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            maxPoints = int.tryParse(newValue!);
          }),
        ),
      ],
    );
  }

  Widget colorInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.emblem_color_pick_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        colorPick(
          context,
          color,
          onUpdateColor,
        ),
        if (color == null && submit)
          Text(
            context.loc.emblem_color_pick_input_error,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  Widget quizInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.emblem_quiz_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<Quiz?>(
          // value: selectedQuiz,
          onChanged: (Quiz? newValue) {
            setState(() {
              selectedQuiz = newValue;
            });
          },
          items: quizzesItems,
          decoration: InputDecoration(
            hintText: context.loc.emblem_quiz_hint,
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
            if (value == null) {
              return context.loc.emblem_quiz_not_valid;
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
            context.loc.create_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            setState(() {
              submit = true;
            });

            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = emblemCreateKey.currentState!.validate();

            if (isValid && color != null) {
              emblemCreateKey.currentState!.save();
              final variableFromService = await EmblemService().create(
                context,
                title!,
                image!,
                minPoints!,
                maxPoints!,
                selectedQuiz!,
                color!.toHex(),
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: variableFromService == EnumEmblem.success
                      ? context.loc.create_emblem_success_title
                      : context.loc.create_emblem_error_title,
                  subtitle: variableFromService == EnumEmblem.success
                      ? context.loc.create_emblem_success_content
                      : context.loc.create_emblem_error_content,
                  context: context,
                );
                variableFromService == EnumEmblem.success
                    ? navigator.pop()
                    : null;
              }
            }
          },
        ),
      ],
    );
  }
}
