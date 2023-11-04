import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/admin.dart';
import 'package:museo_admin_application/providers/admin.dart';
import 'package:museo_admin_application/services/endpoints.dart';
import 'package:provider/provider.dart';

enum EnumStatus { error, duplicatedEmail, success }

class AdminService {
  Future<EnumStatus> login({
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
      return EnumStatus.error;
    }

    final admin = LoggedAdmin.fromJson(jsonDecode(response.body));

    adminProvider.login(
      loginEmail: admin.email,
      loginAuthCode: admin.authCode,
    );

    return EnumStatus.success;
  }

  Future<List<ReadAdmin>> getAllAdmin(BuildContext context) async {
    final response = await http.get(
      Api().admin(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final adminsJson = jsonDecode(response.body)['admins'];

    List<ReadAdmin> adminsList = (adminsJson as List).map((admin) {
      return ReadAdmin.fromJson(admin);
    }).toList();

    return adminsList;
  }

  Future<EnumStatus> deleteAdmin(BuildContext context, String adminID) async {
    final response = await http.delete(
      Api().admin(endpoint: adminID),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumStatus.error;
    }

    return EnumStatus.success;
  }

  Future<EnumStatus> update(
    BuildContext context,
    ReadAdmin admin,
    String password,
    String email,
  ) async {
    Map<String, dynamic> body = {
      'email': email,
    };

    if (password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.patch(
      Api().admin(endpoint: '/${admin.id}'),
      headers: adminJwt(context),
      body: body,
    );

    if (response.statusCode != 200) {
      return EnumStatus.error;
    }

    return EnumStatus.success;
  }

  Future<EnumStatus> create(
      BuildContext context, String email, String password) async {
    final response = await http.post(
      Api().admin(endpoint: ''),
      body: {
        'email': email,
        'password': password,
      },
      headers: adminJwt(context),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode != 201) {
      if (jsonBody['error'] == 'Failed! Email is already in use') {
        return EnumStatus.duplicatedEmail;
      }
      return EnumStatus.error;
    }

    return EnumStatus.success;
  }
}

adminJwt(BuildContext context) {
  final adminProvider = Provider.of<AdminProvider>(context, listen: false);

  return {
    'Authorization': 'Bearer ${adminProvider.authCode}',
  };
}
