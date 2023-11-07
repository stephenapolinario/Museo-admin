import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/models/museumInformation/museum_information.dart';
import 'package:museo_admin_application/screens/museumInformation/email/museum_email_create.dart';
import 'package:museo_admin_application/screens/museumInformation/email/museum_email_update.dart';
import 'package:museo_admin_application/services/museumInformation/museum_email_service.dart';
import 'package:museo_admin_application/services/museumInformation/museum_information_address_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class MuseumEmailListScreen extends StatefulWidget {
  const MuseumEmailListScreen({super.key});

  @override
  State<MuseumEmailListScreen> createState() => MuseumEmailListScreenState();
}

class MuseumEmailListScreenState extends State<MuseumEmailListScreen> {
  late MuseumInformation museumInformation;

  late StreamController<List<MuseumEmail>> _emailStreamController;
  Stream<List<MuseumEmail>> get onListEmailChanged =>
      _emailStreamController.stream;

  @override
  void initState() {
    super.initState();
    _emailStreamController = StreamController<List<MuseumEmail>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _emailStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<MuseumEmail> data = await MuseumEmailService().readAll(context);
    _emailStreamController.sink.add(data);
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
        title: Text(context.loc.museum_information_email_screen_title),
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
                  builder: (BuildContext context) => MuseumEmailCreateScreen(
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
        child: StreamBuilder<List<MuseumEmail>?>(
          stream: onListEmailChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MuseumEmail> emailList = snapshot.data!;
              return emailListWidget(emailList);
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

  Widget emailListWidget(List<MuseumEmail> emailList) {
    return SingleChildScrollView(
      child: Column(
        children: emailList.map((currentMuseumInformationEmail) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentMuseumInformationEmail.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.email_rounded,
                color: Colors.black,
              ),
              title: Text(
                context.loc.museum_information_email_screen_tile,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentMuseumInformationEmail.email,
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
                              MuseumEmailUpdateScreen(
                            emailToUpdate: currentMuseumInformationEmail,
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
                            .museum_information_email_sure_want_delete_title,
                        content: context.loc
                            .museum_information_email_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await MuseumEmailService().delete(
                          context,
                          currentMuseumInformationEmail,
                          emailList,
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
