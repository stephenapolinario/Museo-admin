import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumMuseumEmail { error, success }

class MuseumEmailService {
  Future<List<MuseumEmail>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().museumInformation(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['museumInformations']['emailList'];

    List<MuseumEmail> emailList = (data as List).map((object) {
      return MuseumEmail.fromJson(object);
    }).toList();

    return emailList;
  }

  // Actually this is a patch on the API...
  Future<EnumMuseumEmail> delete(
    BuildContext context,
    MuseumEmail emailToDelete,
    List<MuseumEmail> currentEmailList,
    MuseumInformation museumInformation,
  ) async {
    List<Map<String, String>> emailList = [];
    for (var email in currentEmailList) {
      if (email.id != emailToDelete.id) {
        emailList.add({"email": email.email});
      }
    }
    Map<String, dynamic> body = {
      'emailList': emailList,
    };

    final response = await http.patch(
      Api().museumInformation(endpoint: museumInformation.id),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumMuseumEmail.error;
    }

    return EnumMuseumEmail.success;
  }

  Future<EnumMuseumEmail> update(
    BuildContext context,
    MuseumEmail emailToUpdate,
    List<MuseumEmail> currentEmailList,
    MuseumInformation museumInformation,
    String newEmail,
  ) async {
    List<Map<String, String>> emailList = [];
    for (var email in currentEmailList) {
      if (email.id != emailToUpdate.id) {
        emailList.add({"email": email.email});
      }
    }

    Map<String, dynamic> body = {
      'emailList': emailList,
    };

    emailList.add({"email": newEmail});

    final response = await http.patch(
      Api().museumInformation(endpoint: '/${museumInformation.id}'),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumMuseumEmail.error;
    }

    return EnumMuseumEmail.success;
  }

  // Actually this is a patch on the API...
  Future<EnumMuseumEmail> create(
    BuildContext context,
    MuseumInformation museumInformation,
    String newEmail,
  ) async {
    List<Map<String, String>> emailList = [];
    for (var email in museumInformation.emailList) {
      emailList.add({"email": email.email});
    }
    emailList.add({"email": newEmail});

    Map<String, dynamic> body = {
      'emailList': emailList,
    };

    final response = await http.patch(
      Api().museumInformation(endpoint: museumInformation.id),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumMuseumEmail.error;
    }

    return EnumMuseumEmail.success;
  }
}
