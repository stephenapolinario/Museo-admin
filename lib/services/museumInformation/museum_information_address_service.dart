import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumMuseumInformation { error, success }

class MuseumInformationService {
  Future<MuseumInformation> readAll(BuildContext context) async {
    final response = await http.get(
      Api().museumInformation(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load data from API');
    }

    final data = jsonDecode(response.body)['museumInformations'];

    MuseumInformation museumInfo = MuseumInformation.fromJson(data);

    return museumInfo;
  }

// Future<EnumMuseumInformation> delete(BuildContext context, MuseumInformation object) async {
//   final response = await http.delete(
//   Api().museumInformation(endpoint: object.id),
//   headers: adminJwt(context),
//   );

//   if (response.statusCode != 200) {
//   return EnumMuseumInformation.error;
//   }

//   return EnumMuseumInformation.success;
// }

  Future<EnumMuseumInformation> update(
    BuildContext context,
    MuseumInformation museumInformation,
    String country,
    String state,
  ) async {
    final response = await http.patch(
      Api().museumInformation(endpoint: '/${museumInformation.id}'),
      headers: adminJwt(context),
      body: {
        'country': country,
        'state': state,
      },
    );

    if (response.statusCode != 200) {
      return EnumMuseumInformation.error;
    }

    return EnumMuseumInformation.success;
  }

// Future<EnumMuseumInformation> create(
//   BuildContext context, ?) async {
//   final response = await http.post(
//   Api().museumInformation(endpoint: ''),
//   body: ?,
//   headers: adminJwt(context),
//   );

//   final jsonBody = jsonDecode(response.body);

//   if (response.statusCode != 201) {
//   return EnumMuseumInformation.error;
//   }

//   return EnumMuseumInformation.success;
// }
}
