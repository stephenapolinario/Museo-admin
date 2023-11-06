import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/constants/routes.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/services/admin_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formLoginKey = GlobalKey<FormState>();
  late String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.login_screen_title),
      ),
      body: Column(
        children: [
          loginTitle(context),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  loginFields(context),
                  enterButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text(
        context.loc.login_title_content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
    );
  }

  Widget loginFields(BuildContext context) {
    return Form(
      key: formLoginKey,
      // autovalidateMode: AutovalidateMode.always,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          emailInput(context),
          const SizedBox(height: 15),
          passwordInput(context),
        ],
      ),
    );
  }

  Widget emailInput(BuildContext context) {
    return Column(
      children: [
        // Input Name
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.login_email_hint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: context.loc.login_your_email_example,
            contentPadding: const EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            errorStyle: const TextStyle(
              color: Colors.red,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value != null) {
              if (!EmailValidator.validate(value)) {
                return context.loc.login_email_not_valid;
              }
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            email = newValue;
          }),
        ),
      ],
    );
  }

  Widget passwordInput(BuildContext context) {
    return Column(
      children: [
        // Input Name
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.login_password_hint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: '******',
            contentPadding: EdgeInsets.only(left: 10),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            errorStyle: TextStyle(
              color: Colors.red,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                // width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value == '') {
              return context.loc.login_fill_password;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            password = newValue;
          }),
        ),
      ],
    );
  }

  Widget enterButton(BuildContext context) {
    return Column(
      children: [
        // Enter
        const SizedBox(height: 20),
        TextButton(
          child: Text(
            context.loc.login_enter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = formLoginKey.currentState!.validate();
            if (isValid) {
              final navigator = Navigator.of(context);
              formLoginKey.currentState!.save();
              final adminLogin = await AdminService().login(
                context: context,
                email: email!,
                password: password!,
              );
              if (context.mounted) {
                await loadingMessageTime(
                  title: adminLogin == EnumAdminStatus.success
                      ? context.loc.login_success_title
                      : context.loc.login_error_title,
                  subtitle: adminLogin == EnumAdminStatus.success
                      ? context.loc.login_success_subtitle
                      : context.loc.login_error_subtitle,
                  context: context,
                );
                navigator.popAndPushNamed(home);
              }
            }
          },
        ),
      ],
    );
  }
}
