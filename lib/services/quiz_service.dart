import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/providers/quiz.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';
import 'package:provider/provider.dart';

enum EnumQuiz { error, success }

class QuizService {
  Future<List<Quiz>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().quiz(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['quizs'];

    List<Quiz> quizzes = (data as List).map((object) {
      return Quiz.fromJson(object);
    }).toList();

    return quizzes;
  }

  Future<EnumQuiz> delete(
    BuildContext context,
    Quiz quiz,
  ) async {
    final response = await http.delete(
      Api().quiz(endpoint: quiz.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumQuiz.error;
    }

    return EnumQuiz.success;
  }

  Future<EnumQuiz> update(
    BuildContext context,
    Quiz quiz, {
    String? title,
    Tour? tour,
    Beacon? beacon,
    double? rssi,
    List<Question>? questions,
  }) async {
    List<Map<String, dynamic>> questionsJson = [];

    if (questions != null) {
      for (Question question in questions) {
        List<Map<String, dynamic>> optionsJson = [];
        for (Option option in question.options) {
          optionsJson.add({
            'answer': option.answer,
            'isCorrect': option.isCorrect,
          });
        }
        questionsJson.add({
          'text': question.question,
          'color': question.color,
          'options': optionsJson,
        });
      }
    }

    Map<String, dynamic> body = {
      if (title != null) 'title': title,
      if (tour != null) 'tour': tour.id,
      if (beacon != null) 'beacon': beacon.id,
      if (rssi != null) 'rssi': rssi,
      if (questionsJson.isNotEmpty) 'questions': questionsJson,
    };

    final response = await http.patch(
      Api().quiz(endpoint: '/${quiz.id}'),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumQuiz.error;
    }

    return EnumQuiz.success;
  }

  Future<EnumQuiz> create(BuildContext context) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    List<Map<String, dynamic>> questionsJson = []; // Change the type to dynamic

    if (quizProvider.questions != null) {
      for (Question question in quizProvider.questions!) {
        List<Map<String, dynamic>> optionsJson = [];
        for (Option option in question.options) {
          optionsJson.add({
            'answer': option.answer,
            'isCorrect': option.isCorrect,
          });
        }
        questionsJson.add({
          'text': question.question,
          'color': question.color,
          'options': optionsJson,
        });
      }
    }

    Map<String, dynamic> body = {
      'title': quizProvider.title,
      'beacon': quizProvider.beacon?.id,
      'tour': quizProvider.tour?.id,
      'rssi': quizProvider.rssi?.toString(),
      'color': quizProvider.color,
      'questions': questionsJson,
    };

    final response = await http.post(
      Api().quiz(endpoint: ''),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 201) {
      return EnumQuiz.error;
    }

    return EnumQuiz.success;
  }
}
