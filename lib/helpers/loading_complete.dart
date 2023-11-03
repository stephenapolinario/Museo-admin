import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_screen.dart';
import 'package:museo_admin_application/helpers/loading_screen_indicator.dart';

Future loadingMessageTime({
  required String title,
  required String subtitle,
  required BuildContext context,
}) async {
  LoadingScreen().hide();

  LoadingScreen().show(
    context: context,
    title: title,
    subtitle: subtitle,
  );

  await Future.delayed(const Duration(seconds: 2));

  LoadingScreen().hide();
}

Future loadingIndicatorTime({
  required String title,
  required BuildContext context,
}) async {
  LoadingScreenIndicator().hide();

  LoadingScreenIndicator().show(
    context: context,
    title: title,
  );

  await Future.delayed(const Duration(seconds: 2));

  LoadingScreenIndicator().hide();
}
