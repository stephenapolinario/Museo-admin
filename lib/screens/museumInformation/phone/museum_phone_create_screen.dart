import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/services/museumInformation/museum_information_address_service.dart';
import 'package:museo_admin_application/services/museumInformation/museum_phone_service.dart';

class MuseumPhoneCreateScreen extends StatefulWidget {
  final Function onUpdate;

  const MuseumPhoneCreateScreen({
    super.key,
    required this.onUpdate,
  });

  @override
  State<MuseumPhoneCreateScreen> createState() =>
      _MuseumPhoneCreateScreenState();
}

class _MuseumPhoneCreateScreenState extends State<MuseumPhoneCreateScreen> {
  final beaconCreateKey = GlobalKey<FormState>();
  late String? phoneNumber;

  late MuseumInformation museumInformation;
  late List<MuseumPhone> currentPhoneNumberList;
  // To prevent reload
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    currentPhoneNumberList = await MuseumPhoneService().readAll(context);
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
        title: Text(context.loc.create_museum_information_phone_screen_title),
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
      key: beaconCreateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          phoneNumberInput(context),
        ],
      ),
    );
  }

  Widget phoneNumberInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_information_phone_screen_phone_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: context.loc.museum_information_phone_screen_phone_hint,
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
                  .loc.museum_information_phone_screen_phone_valid_error;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            phoneNumber = newValue;
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
            context.loc.add_button,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            FocusManager.instance.primaryFocus?.unfocus();
            final isValid = beaconCreateKey.currentState!.validate();

            if (isValid) {
              beaconCreateKey.currentState!.save();
              final object = await MuseumPhoneService().create(
                context,
                museumInformation,
                phoneNumber!,
              );
              widget.onUpdate();

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumMuseumPhone.success
                      ? context
                          .loc.create_museum_information_phone_success_title
                      : context.loc.create_museum_information_phone_error_title,
                  subtitle: object == EnumMuseumPhone.success
                      ? context
                          .loc.create_museum_information_phone_success_content
                      : context
                          .loc.create_museum_information_phone_error_content,
                  context: context,
                );
                object == EnumMuseumPhone.success ? navigator.pop() : null;
              }
            }
          },
        ),
      ],
    );
  }
}
