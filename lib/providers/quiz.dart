import 'package:flutter/material.dart';
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/models/tour.dart';

class QuizProvider with ChangeNotifier {
  bool isUpdating = false;
  String? title;
  double? rssi;
  String? color;
  Beacon? beacon;
  Tour? tour;
  List<Question>? questions;

  void saveBasicInformation({
    required String newTitle,
    required String newColor,
    required double newRssi,
    required Beacon newBeacon,
    required Tour newTour,
  }) {
    isUpdating = true;
    title = newTitle;
    color = newColor;
    rssi = newRssi;
    beacon = newBeacon;
    tour = newTour;
    notifyListeners();
  }

  void saveQuestion({
    required List<Question>? newQuestions,
  }) {
    questions = newQuestions;
    notifyListeners();
  }

  void clear() {
    isUpdating = false;
    title = null;
    color = null;
    rssi = null;
    beacon = null;
    tour = null;
    questions = null;
    notifyListeners();
  }
}
