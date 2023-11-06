import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/user.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumUser { error, success }

class UserService {
  Future<List<User>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().user(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['users'];

    List<User> objectList = (data as List).map((object) {
      return User.fromJson(object);
    }).toList();

    return objectList;
  }

// Future<EnumUser> delete(BuildContext context, User object) async {
//   final response = await http.delete(
//   Api().user(endpoint: object.id),
//   headers: adminJwt(context),
//   );

//   if (response.statusCode != 200) {
//   return EnumUser.error;
//   }

//   return EnumUser.success;
// }

// Future<EnumUser> update(BuildContext context, User object) async {
//   final response = await http.patch(
//   Api().user(endpoint: '/${object.id}'),
//   headers: adminJwt(context),
//   body: ?,
//   );

//   if (response.statusCode != 200) {
//   return EnumUser.error;
//   }

//   return EnumUser.success;
// }

// Future<EnumUser> create(
//   BuildContext context, ?) async {
//   final response = await http.post(
//   Api().user(endpoint: ''),
//   body: ?,
//   headers: adminJwt(context),
//   );

//   final jsonBody = jsonDecode(response.body);

//   if (response.statusCode != 201) {
//   return EnumUser.error;
//   }

//   return EnumUser.success;
// }
}
