import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/services/museumInformation/museum_email_service.dart';
import 'package:museo_admin_application/services/museumInformation/museum_information_address_service.dart';

class MuseumEmailUpdateScreen extends StatefulWidget {
  final MuseumEmail emailToUpdate;
  final Function onUpdate;

  const MuseumEmailUpdateScreen({
    super.key,
    required this.emailToUpdate,
    required this.onUpdate,
  });

  @override
  State<MuseumEmailUpdateScreen> createState() =>
      _MuseumEmailUpdateScreenState();
}

class _MuseumEmailUpdateScreenState extends State<MuseumEmailUpdateScreen> {
  final emailUpdateKey = GlobalKey<FormState>();
  late String? email;

  late MuseumInformation museumInformation;
  late List<MuseumEmail> currentEmailList;
  // To prevent reload
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    currentEmailList = await MuseumEmailService().readAll(context);
    if (context.mounted) {
      museumInformation = await MuseumInformationService().readAll(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          context.loc.update_museum_information_email_screen_title
              .toCapitalizeEveryInitialWord(),
        ),
      ),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Padding(
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
            default:
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
          }
        },
      ),
    );
  }

  Widget fields(BuildContext context) {
    return Form(
      key: emailUpdateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          emailNumberInput(context),
        ],
      ),
    );
  }

  Widget emailNumberInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_information_email_screen_email_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: widget.emailToUpdate.email,
          decoration: InputDecoration(
            hintText: context.loc.museum_information_email_screen_email_hint,
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
            if (value == null || value == '') {
              return context
                  .loc.museum_information_email_screen_email_valid_error;
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

  Widget enterButton(BuildContext context) {
    return Column(
      children: [
        // Enter
        const SizedBox(height: 20),
        TextButton(
          child: Text(
            context.loc.update_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = emailUpdateKey.currentState!.validate();

            if (isValid) {
              emailUpdateKey.currentState!.save();
              final object = await MuseumEmailService().update(
                context,
                widget.emailToUpdate,
                museumInformation.emailList,
                museumInformation,
                email!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumMuseumEmail.success
                      ? context
                          .loc.update_museum_information_email_success_title
                      : context.loc.update_museum_information_email_error_title,
                  subtitle: object == EnumMuseumEmail.success
                      ? context
                          .loc.update_museum_information_email_success_content
                      : context
                          .loc.update_museum_information_email_error_content,
                  context: context,
                );
                object == EnumMuseumEmail.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
