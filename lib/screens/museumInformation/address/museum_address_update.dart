import 'package:flutter/material.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/services/museumInformation/museum_information_address_service.dart';

class MuseumAddress extends StatefulWidget {
  const MuseumAddress({
    super.key,
  });

  @override
  State<MuseumAddress> createState() => _MuseumAddressState();
}

class _MuseumAddressState extends State<MuseumAddress> {
  final museumInformationAddresUpdateKey = GlobalKey<FormState>();
  late String? country, state;
  late MuseumInformation museumInformation;

  // To prevent reload
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
    museumInformation = await MuseumInformationService().readAll(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.update_museum_information_address_screen_title),
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
      key: museumInformationAddresUpdateKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          countryInput(context),
          const SizedBox(height: 15),
          stateInput(context),
        ],
      ),
    );
  }

  Widget countryInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_information_address_screen_country_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: museumInformation.country,
          decoration: InputDecoration(
            hintText:
                context.loc.museum_information_address_screen_country_hint,
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
                  .loc.museum_information_address_screen_country_valid_error;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            country = newValue;
          }),
        ),
      ],
    );
  }

  Widget stateInput(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            context.loc.museum_information_address_screen_estate_input,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextFormField(
          initialValue: museumInformation.state,
          decoration: InputDecoration(
            hintText: context.loc.museum_information_address_screen_estate_hint,
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
                // width: 2,
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
                  .loc.museum_information_address_screen_estate_valid_error;
            }
            return null;
          },
          onSaved: (newValue) => setState(() {
            state = newValue;
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
            final isValid =
                museumInformationAddresUpdateKey.currentState!.validate();

            if (isValid) {
              museumInformationAddresUpdateKey.currentState!.save();
              final object = await MuseumInformationService().update(
                context,
                museumInformation,
                country!,
                state!,
              );

              if (context.mounted) {
                await loadingMessageTime(
                  title: object == EnumMuseumInformation.success
                      ? context
                          .loc.update_museum_information_address_success_title
                      : context
                          .loc.update_museum_information_address_error_title,
                  subtitle: object == EnumMuseumInformation.success
                      ? context
                          .loc.update_museum_information_address_success_content
                      : context
                          .loc.update_museum_information_address_error_content,
                  context: context,
                );
                object == EnumMuseumInformation.success
                    ? navigator.pop()
                    : null;
              }
            }
          },
        ),
      ],
    );
  }
}
