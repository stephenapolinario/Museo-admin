import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/screens/beacon/beacon_create_screen.dart';
import 'package:museo_admin_application/screens/beacon/beacon_update_screen.dart';
import 'package:museo_admin_application/services/beacon_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';

// TODO: Create a filter option. Filtering by Tour

class BeaconListScreen extends StatefulWidget {
  const BeaconListScreen({super.key});

  @override
  State<BeaconListScreen> createState() => BeaconListScreenState();
}

class BeaconListScreenState extends State<BeaconListScreen> {
  late StreamController<List<Beacon>> _beaconStreamController;
  Stream<List<Beacon>> get onListbeaconChanged =>
      _beaconStreamController.stream;

  @override
  void initState() {
    super.initState();
    _beaconStreamController = StreamController<List<Beacon>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _beaconStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<Beacon> beacons = await BeaconService().readAll(context);
    _beaconStreamController.sink.add(beacons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.beacon_list_screen_title),
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
                  builder: (BuildContext context) => BeaconCreateScreen(
                    onUpdate: () {
                      fetchData(); // Call the method to update the stream when the beacon is updated.
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
        child: StreamBuilder<List<Beacon>?>(
          stream: onListbeaconChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Beacon> beaconList = snapshot.data!;
              return beaconsList(beaconList);
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

  Widget beaconsList(List<Beacon> beaconList) {
    return SingleChildScrollView(
      child: Column(
        children: beaconList.map((currentBeacon) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentBeacon.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.bluetooth,
                color: Colors.black,
              ),
              title: Text(
                context.loc.beacon_list_tile_title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentBeacon.name,
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
                          builder: (BuildContext context) => BeaconUpdateScreen(
                            beacon: currentBeacon,
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
                        title: context.loc.beacon_sure_want_delete_title,
                        content: context.loc.beacon_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await BeaconService().delete(context, currentBeacon);
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
