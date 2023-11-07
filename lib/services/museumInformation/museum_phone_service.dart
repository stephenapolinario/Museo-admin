import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumMuseumPhone { error, success }

class MuseumPhoneService {
  Future<List<MuseumPhone>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().museumInformation(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data =
        jsonDecode(response.body)['museumInformations']['phoneNumberList'];

    List<MuseumPhone> objectList = (data as List).map((object) {
      return MuseumPhone.fromJson(object);
    }).toList();

    return objectList;
  }

  // Actually this is a patch on the API...
  Future<EnumMuseumPhone> delete(
    BuildContext context,
    MuseumPhone phoneToDelete,
    List<MuseumPhone> currentPhoneNumbers,
    MuseumInformation museumInformation,
  ) async {
    List<Map<String, String>> phoneList = [];
    for (var phone in currentPhoneNumbers) {
      if (phone.id != phoneToDelete.id) {
        phoneList.add({"phoneNumber": phone.phoneNumber});
      }
    }
    Map<String, dynamic> body = {
      'phoneNumberList': phoneList,
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
      return EnumMuseumPhone.error;
    }

    return EnumMuseumPhone.success;
  }

  Future<EnumMuseumPhone> update(
    BuildContext context,
    MuseumPhone phoneToUpdate,
    List<MuseumPhone> currentPhoneNumbers,
    MuseumInformation museumInformation,
    String newNumber,
  ) async {
    List<Map<String, String>> phoneList = [];
    for (var phone in currentPhoneNumbers) {
      if (phone.id != phoneToUpdate.id) {
        phoneList.add({"phoneNumber": phone.phoneNumber});
      }
    }

    Map<String, dynamic> body = {
      'phoneNumberList': phoneList,
    };

    phoneList.add({"phoneNumber": newNumber});

    final response = await http.patch(
      Api().museumInformation(endpoint: '/${museumInformation.id}'),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumMuseumPhone.error;
    }

    return EnumMuseumPhone.success;
  }

  // Actually this is a patch on the API...
  Future<EnumMuseumPhone> create(
    BuildContext context,
    MuseumInformation museumInformation,
    String phoneNumber,
  ) async {
    List<Map<String, String>> phoneList = [];
    for (var phone in museumInformation.phoneList) {
      phoneList.add({"phoneNumber": phone.phoneNumber});
    }
    phoneList.add({"phoneNumber": phoneNumber});

    Map<String, dynamic> body = {
      'phoneNumberList': phoneList,
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
      return EnumMuseumPhone.error;
    }

    return EnumMuseumPhone.success;
  }
}
