import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {
  late bool logged = false;
  late String? email;
  late String? authCode;

  void login({
    required String loginEmail,
    required String loginAuthCode,
  }) {
    email = loginEmail;
    authCode = loginAuthCode;
    logged = true;
    notifyListeners();
  }

  void logout() {
    email = null;
    authCode = null;
    logged = false;
  }
}
