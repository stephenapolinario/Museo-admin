import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/screens/museumInformation/phone/museum_phone_create_screen.dart';
import 'package:museo_admin_application/screens/museumInformation/phone/museum_phone_update_screen.dart';
import 'package:museo_admin_application/services/museumInformation/museum_information_address_service.dart';
import 'package:museo_admin_application/services/museumInformation/museum_phone_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class MuseumPhoneListScreen extends StatefulWidget {
  const MuseumPhoneListScreen({super.key});

  @override
  State<MuseumPhoneListScreen> createState() => MuseumPhoneListScreenState();
}

class MuseumPhoneListScreenState extends State<MuseumPhoneListScreen> {
  late MuseumInformation museumInformation;

  late StreamController<List<MuseumPhone>> _phoneStreamController;
  Stream<List<MuseumPhone>> get onListphoneChanged =>
      _phoneStreamController.stream;

  @override
  void initState() {
    super.initState();
    _phoneStreamController = StreamController<List<MuseumPhone>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _phoneStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<MuseumPhone> data = await MuseumPhoneService().readAll(context);
    _phoneStreamController.sink.add(data);
    if (mounted) {
      museumInformation = await MuseumInformationService().readAll(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.museum_information_phone_screen_title),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MuseumPhoneCreateScreen(
                    onUpdate: () {
                      fetchData();
                    },
                  ),
                ),
              )
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: StreamBuilder<List<MuseumPhone>?>(
          stream: onListphoneChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MuseumPhone> phoneList = snapshot.data!;
              return phoneListWidget(phoneList);
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget phoneListWidget(List<MuseumPhone> phoneList) {
    return SingleChildScrollView(
      child: Column(
        children: phoneList.map((currentMuseumInformationPhone) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentMuseumInformationPhone.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
              title: Text(
                context.loc.museum_information_phone_screen_tile,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentMuseumInformationPhone.phoneNumber,
                style: const TextStyle(
                  color: mainItemContentColor,
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              MuseumPhoneUpdateScreen(
                            phoneToUpdate: currentMuseumInformationPhone,
                            onUpdate: () {
                              fetchData();
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(context.loc.pop_menu_button_update),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      final wantDelete = await showGenericDialog(
                        context: context,
                        title: context.loc
                            .museum_information_phone_sure_want_delete_title,
                        content: context.loc
                            .museum_information_phone_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await MuseumPhoneService().delete(
                          context,
                          currentMuseumInformationPhone,
                          phoneList,
                          museumInformation,
                        );
                        fetchData();
                      }
                    },
                    child: Text(
                      context.loc.pop_menu_button_delete,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
