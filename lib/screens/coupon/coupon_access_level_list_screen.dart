// TODO: Create a filter option. Filtering by Tour

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/coupon/coupon_access.dart';
import 'package:museo_admin_application/services/coupon/coupon_access_service.dart';

class CouponAccessLevelListScreen extends StatefulWidget {
  const CouponAccessLevelListScreen({super.key});

  @override
  State<CouponAccessLevelListScreen> createState() =>
      CouponAccessLevelListScreenState();
}

class CouponAccessLevelListScreenState
    extends State<CouponAccessLevelListScreen> {
  late StreamController<List<CouponAccess>> _couponAccessStreamController;
  Stream<List<CouponAccess>> get onListbeaconChanged =>
      _couponAccessStreamController.stream;

  @override
  void initState() {
    super.initState();
    _couponAccessStreamController =
        StreamController<List<CouponAccess>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _couponAccessStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<CouponAccess> accessLevel =
        await CouponAccessService().readAll(context);
    _couponAccessStreamController.sink.add(accessLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          context.loc.coupon_access_list_title,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        // actions: [
        // IconButton(
        //   icon: const Icon(
        //     Icons.add,
        //     color: Colors.black,
        //     size: 35,
        //   ),
        //   onPressed: () => {
        // Navigator.of(context).push(
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) => BeaconCreateScreen(
        //       onUpdate: () {
        //         fetchData(); // Call the method to update the stream when the beacon is updated.
        //       },
        //     ),
        //   ),
        // )
        // },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: StreamBuilder<List<CouponAccess>?>(
          stream: onListbeaconChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CouponAccess> couponsAccessList = snapshot.data!;
              return couponAccessList(couponsAccessList);
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

  Widget couponAccessList(List<CouponAccess> couponsAccessList) {
    return ListView.builder(
      itemCount: couponsAccessList.length,
      itemBuilder: (context, index) {
        final currentCouponAccess = couponsAccessList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            iconColor: Colors.black,
            key: ValueKey(currentCouponAccess.id),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            tileColor: Colors.cyan.shade800,
            leading: const Icon(
              Icons.bluetooth,
              color: Colors.black,
            ),
            title: Text(
              context.loc.coupon_access_list_tile_title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              currentCouponAccess.access.toCapitalize(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            // trailing: PopupMenuButton(
            //   itemBuilder: (context) => [
            //     PopupMenuItem(
            //       onTap: () {
            //         // Navigator.of(context).push(
            //         //   MaterialPageRoute<void>(
            //         //     builder: (BuildContext context) => BeaconUpdateScreen(
            //         //       beacon: currentCouponAccess,
            //         //       onUpdate: () {
            //         //         fetchData();
            //         //       },
            //         //     ),
            //         //   ),
            //         // );
            //       },
            //       child: Text(context.loc.pop_menu_button_update),
            //     ),
            //     PopupMenuItem(
            //       onTap: () async {
            //         final wantDelete = await showGenericDialog(
            //           context: context,
            //           title: context.loc.beacon_sure_want_delete_title,
            //           content: context.loc.beacon_sure_want_delete_content,
            //           optionsBuilder: () => {
            //             context.loc.sure_want_delete_option_yes: true,
            //             context.loc.sure_want_delete_option_false: false,
            //           },
            //         );
            //         if (context.mounted && wantDelete) {
            //           // await BeaconService().delete(context, currentCouponAccess);
            //           // fetchData();
            //         }
            //       },
            //       child: Text(
            //         context.loc.pop_menu_button_delete,
            //         style: const TextStyle(
            //           color: Colors.red,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        );
      },
    );
  }
}
