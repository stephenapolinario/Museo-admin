import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/screens/tour/tour_create_screen.dart';
import 'package:museo_admin_application/screens/tour/tour_update_screen.dart';
import 'package:museo_admin_application/services/tour_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';

class TourListScreen extends StatefulWidget {
  const TourListScreen({super.key});

  @override
  State<TourListScreen> createState() => TourListScreenState();
}

class TourListScreenState extends State<TourListScreen> {
  late StreamController<List<Tour>> _tourStreamController;
  Stream<List<Tour>> get onListTourChanged => _tourStreamController.stream;

  @override
  void initState() {
    super.initState();
    _tourStreamController = StreamController<List<Tour>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _tourStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<Tour> data = await TourService().readAll(context);
    _tourStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.tour_screen_list),
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
                  builder: (BuildContext context) => TourCreateScreen(
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
        child: StreamBuilder<List<Tour>?>(
          stream: onListTourChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Tour> tourList = snapshot.data!;
              return tourListWidget(tourList);
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

  Widget tourListWidget(List<Tour> tourList) {
    return SingleChildScrollView(
      child: Column(
        children: tourList.map((currentTour) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentTour.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.route,
                color: Colors.black,
              ),
              title: Text(
                currentTour.title.toCapitalizeEveryInitialWord(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentTour.subtitle.toCapitalizeFirstWord(),
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
                          builder: (BuildContext context) => TourUpdateScreen(
                            tour: currentTour,
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
                        title: context.loc.tour_sure_want_delete_title,
                        content: context.loc.tour_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await TourService().delete(context, currentTour);
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
