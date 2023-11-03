import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/admin.dart';
import 'package:museo_admin_application/providers/admin.dart';
import 'package:museo_admin_application/services/endpoints.dart';
import 'package:provider/provider.dart';

class AdminService {
  Future login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // Return true if logged. False if something wrong happend.
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    final response = await http.post(
      Api().admin(endpoint: '/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode != 200) {
      return false;
    }

    final admin = LoggedAdmin.fromJson(jsonDecode(response.body));

    adminProvider.login(
      loginEmail: admin.email,
      loginAuthCode: admin.authCode,
    );

    return true;
  }

  Future getAllAdmin(BuildContext context) async {
    final response = await http.get(
      Api().admin(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final adminsJson = jsonDecode(response.body)['admins'];

    List<ReadAdmin> adminsList = (adminsJson as List).map((admin) {
      return ReadAdmin.fromJson(admin);
    }).toList();

    return adminsList;
  }

  Future deleteAdmin(BuildContext context, String adminID) async {
    final response = await http.delete(
      Api().admin(endpoint: adminID),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return null;
    }

    return true;
  }
}

adminJwt(BuildContext context) {
  final adminProvider = Provider.of<AdminProvider>(context, listen: false);

  return {
    'Authorization': 'Bearer ${adminProvider.authCode}',
  };
}
