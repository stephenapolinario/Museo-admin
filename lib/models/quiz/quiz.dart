import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/tour.dart';

class Quiz {
  final String id, title, color;
  final int rssi;
  final List<Question> questions;
  final Beacon? beacon;
  final Tour? tour;

  Quiz({
    required this.id,
    required this.beacon,
    required this.tour,
    required this.rssi,
    required this.title,
    required this.questions,
    required this.color,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final beacon =
        json['beacon'] != null ? Beacon.fromJson(json['beacon']) : null;
    final tour = json['tour'] != null ? Tour.fromJson(json['tour']) : null;

    return Quiz(
      id: json['_id'],
      title: json['title'],
      beacon: beacon,
      tour: tour,
      rssi: json['rssi'],
      color: json['color'],
      questions: List<Question>.from(
          json['questions'].map((question) => Question.fromJson(question))),
    );
  }
}

class Question {
  late String question, color;
  late List<Option> options;

  Question({
    required this.question,
    required this.options,
    required this.color,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['text'],
      color: json['color'],
      options: List<Option>.from(
          json['options'].map((option) => Option.fromJson(option))),
    );
  }
}

class Option {
  late String answer;
  late bool isCorrect;

  Option({
    required this.answer,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      answer: json['answer'],
      isCorrect: json['isCorrect'],
    );
  }
}
