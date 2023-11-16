import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/color.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/helpers/color_pick.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/providers/quiz.dart';
import 'package:museo_admin_application/services/beacon_service.dart';
import 'package:museo_admin_application/services/tour_service.dart';
import 'package:provider/provider.dart';

class QuizCreateInformationScreen extends StatefulWidget {
  const QuizCreateInformationScreen({
    super.key,
  });

  @override
  State<QuizCreateInformationScreen> createState() =>
      _QuizCreateInformationScreenState();
}

class _QuizCreateInformationScreenState
    extends State<QuizCreateInformationScreen> {
  final quizInformationCreateKey = GlobalKey<FormState>();
  late String? title;
  late double? rssi;
  late QuizProvider quizProvider;

  late List<Tour> tourList;
  late List<Beacon> beaconList;
  late List<DropdownMenuItem<Tour>> tourItems;
  late List<DropdownMenuItem<Beacon>> beaconItems;
  late Tour? selectedTour;
  late Beacon? selectedBeacon;

  // To prevent reload
  late Future<void> fetchDataFuture;

  bool submit = false;
  Color? color;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    tourList = await TourService().readAll(context);

    if (context.mounted) {
      beaconList = await BeaconService().readAll(context);

      tourItems = tourList.map<DropdownMenuItem<Tour>>((Tour value) {
        return DropdownMenuItem<Tour>(
          value: value,
          child: Text(value.title),
        );
      }).toList();

      beaconItems = beaconList.map<DropdownMenuItem<Beacon>>((Beacon value) {
        return DropdownMenuItem<Beacon>(
          value: value,
          child: Text(value.name),
        );
      }).toList();

      selectedBeacon = quizProvider.beacon != null
          ? beaconList.firstWhere(
              (beacon) => beacon.id == quizProvider.beacon!.id,
            )
          : null;

      selectedTour = quizProvider.tour != null
          ? tourList.firstWhere(
              (tour) => tour.id == quizProvider.tour!.id,
            )
          : null;
    }
  }

  void onUpdateColor(Color value) {
    setState(() {
      color = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quizProvider = Provider.of<QuizProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.create_quiz_information_screen_title),
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
                      enterButton(parentContext),
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
      key: quizInformationCreateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          titleInput(context),
          const SizedBox(height: 15),
          rssiInput(context),
          const SizedBox(height: 15),
          colorInput(context),
          const SizedBox(height: 15),
          tourInput(context),
          const SizedBox(height: 15),
          beaconInput(context),
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
            context.loc.quiz_screen_title_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: quizProvider.title,
          decoration: InputDecoration(
            hintText: context.loc.quiz_screen_title_hint,
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
              return context.loc.quiz_screen_title_valid_error;
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

  Widget rssiInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.quiz_screen_rssi_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: quizProvider.rssi?.toString(),
          decoration: InputDecoration(
            hintText: context.loc.quiz_screen_rssi_hint,
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
              return context.loc.quiz_screen_rssi_valid_error;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            rssi = double.tryParse(newValue!);
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
          quizProvider.color != null ? quizProvider.color!.fromHex() : color,
          onUpdateColor,
        ),
        if (color == null && submit && quizProvider.color == null)
          Text(
            context.loc.emblem_color_pick_input_error,
            style: const TextStyle(
              color: Colors.red,
            ),
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
            context.loc.save_button,
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
            final isValid = quizInformationCreateKey.currentState!.validate();

            if (isValid && (quizProvider.color != null || color != null)) {
              quizInformationCreateKey.currentState!.save();
              quizProvider.saveBasicInformation(
                newTitle: title!,
                newColor: color != null ? color!.toHex() : quizProvider.color!,
                newRssi: rssi!,
                newBeacon: selectedBeacon!,
                newTour: selectedTour!,
              );

              await loadingMessageTime(
                title: context.loc.create_quiz_information_success_title,
                subtitle: context.loc.create_quiz_information_success_content,
                context: context,
              );

              navigator.pop();
            }
          },
        ),
      ],
    );
  }

  Widget tourInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.quiz_screen_tour_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<Tour?>(
          value: selectedTour,
          onChanged: (Tour? newValue) {
            setState(() {
              selectedTour = newValue;
            });
          },
          items: tourItems,
          decoration: InputDecoration(
            hintText: context.loc.quiz_screen_tour_hint,
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
              return context.loc.quiz_screen_tour_valid_error;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget beaconInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.quiz_screen_beacon_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        DropdownButtonFormField<Beacon?>(
          value: selectedBeacon,
          onChanged: (Beacon? newValue) {
            setState(() {
              selectedBeacon = newValue;
            });
          },
          items: beaconItems,
          decoration: InputDecoration(
            hintText: context.loc.quiz_screen_beacon_hint,
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
              return context.loc.quiz_screen_beacon_valid_error;
            }
            return null;
          },
        ),
      ],
    );
  }
}
