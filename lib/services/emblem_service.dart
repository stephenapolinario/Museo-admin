import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/emblem.dart';
import 'package:museo_admin_application/models/quiz/quiz.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumEmblem { error, success }

class EmblemService {
  Future<List<Emblem>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().emblem(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['emblems'];

    List<Emblem> emblemList = (data as List).map((object) {
      return Emblem.fromJson(object);
    }).toList();

    return emblemList;
  }

  Future<EnumEmblem> delete(BuildContext context, Emblem object) async {
    final response = await http.delete(
      Api().emblem(endpoint: object.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumEmblem.error;
    }

    return EnumEmblem.success;
  }

  Future<EnumEmblem> update(
    BuildContext context,
    String title,
    String image,
    int minPoints,
    int maxPoints,
    Quiz quiz,
    String color,
    Emblem emblem,
  ) async {
    Map<String, dynamic> body = {
      'title': title,
      'image': image,
      'minPoints': minPoints,
      'maxPoints': maxPoints,
      'quiz': quiz.id,
      'color': color,
    };

    final response = await http.patch(
      Api().emblem(endpoint: '/${emblem.id}'),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumEmblem.error;
    }

    return EnumEmblem.success;
  }

  Future<EnumEmblem> create(
    BuildContext context,
    String title,
    String image,
    int minPoints,
    int maxPoints,
    Quiz quiz,
    String color,
  ) async {
    Map<String, dynamic> body = {
      'title': title,
      'image': image,
      'minPoints': minPoints,
      'maxPoints': maxPoints,
      'quiz': quiz.id,
      'color': color,
    };

    final response = await http.post(
      Api().emblem(endpoint: ''),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 201) {
      return EnumEmblem.error;
    }

    return EnumEmblem.success;
  }
}
