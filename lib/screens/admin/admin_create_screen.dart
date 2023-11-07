import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/services/admin_service.dart';

class AdminCreateScreen extends StatefulWidget {
  final Function onUpdate;

  const AdminCreateScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<AdminCreateScreen> createState() => _AdminCreateScreenState();
}

class _AdminCreateScreenState extends State<AdminCreateScreen> {
  final adminCreateKey = GlobalKey<FormState>();
  late String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.admin_create_screen_title
            .toCapitalizeEveryInitialWord()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: Column(
          children: [
            fields(context),
            enterButton(context),
          ],
        ),
      ),
    );
  }

  Widget fields(BuildContext context) {
    return Form(
      key: adminCreateKey,
      autovalidateMode: AutovalidateMode.always,
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
            context.loc.admin_update_screen_email_hint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: context.loc.create_admin_email_hint,
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
                return context.loc.admin_update_screen_email_not_valid;
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
            context.loc.admin_update_screen_password_hint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: '*****************',
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
              return context.loc.create_admin_no_password;
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
            context.loc.admin_create_screen_create_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = adminCreateKey.currentState!.validate();

            if (isValid) {
              adminCreateKey.currentState!.save();
              final createAdmin = await AdminService().create(
                context,
                email!,
                password!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: createAdmin == EnumAdminStatus.success
                      ? context.loc.admin_created_successful_title
                      : context.loc.admin_create_error_title,
                  subtitle: createAdmin == EnumAdminStatus.success
                      ? context.loc.admin_created_successful_subtitle
                      : createAdmin == EnumAdminStatus.duplicatedEmail
                          ? context.loc.admin_create_duplicate_email_content
                          : context.loc.admin_create_error_subtitle,
                  context: context,
                );
                createAdmin == EnumAdminStatus.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
