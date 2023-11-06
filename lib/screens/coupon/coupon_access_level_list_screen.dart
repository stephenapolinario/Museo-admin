// TODO: Create a filter option. Filtering by Tour

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
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
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          context.loc.coupon_access_list_title.toCapitalizeEveryInitialWord(),
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
    return SingleChildScrollView(
      child: Column(
        children: couponsAccessList.map((currentCouponAccess) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentCouponAccess.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.security,
                color: Colors.black,
              ),
              title: Text(
                context.loc.coupon_access_list_tile_title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentCouponAccess.access.toCapitalizeEveryInitialWord(),
                style: const TextStyle(
                  color: mainItemContentColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
