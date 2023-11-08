import 'package:museo_admin_application/models/quiz/quiz.dart';

class Emblem {
  String id, title, image, color;
  int minPoints, maxPoints;
  Quiz quiz;

  Emblem({
    required this.id,
    required this.title,
    required this.image,
    required this.quiz,
    required this.color,
    required this.maxPoints,
    required this.minPoints,
  });

  factory Emblem.fromJson(Map<String, dynamic> json) {
    final quiz = Quiz.fromJson(json['quiz']);
    return Emblem(
      id: json['_id'],
      title: json['title'],
      image: json['image'],
      quiz: quiz,
      color: json['color'],
      maxPoints: json['maxPoints'],
      minPoints: json['minPoints'],
    );
  }
}
