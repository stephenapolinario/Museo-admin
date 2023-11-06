import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/quiz.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

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

// Future<EnumQuiz> delete(BuildContext context, Quiz object) async {
//   final response = await http.delete(
//   Api().quiz(endpoint: object.id),
//   headers: adminJwt(context),
//   );

//   if (response.statusCode != 200) {
//   return EnumQuiz.error;
//   }

//   return EnumQuiz.success;
// }

// Future<EnumQuiz> update(BuildContext context, Quiz object) async {
//   final response = await http.patch(
//   Api().quiz(endpoint: '/${object.id}'),
//   headers: adminJwt(context),
//   body: ?,
//   );

//   if (response.statusCode != 200) {
//   return EnumQuiz.error;
//   }

//   return EnumQuiz.success;
// }

// Future<EnumQuiz> create(
//   BuildContext context, ?) async {
//   final response = await http.post(
//   Api().quiz(endpoint: ''),
//   body: ?,
//   headers: adminJwt(context),
//   );

//   final jsonBody = jsonDecode(response.body);

//   if (response.statusCode != 201) {
//   return EnumQuiz.error;
//   }

//   return EnumQuiz.success;
// }
}
