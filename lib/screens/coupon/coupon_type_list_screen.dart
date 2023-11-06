import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/coupon/coupon_type.dart';
import 'package:museo_admin_application/services/coupon/coupon_type_service.dart';

class CouponTypeListScreen extends StatefulWidget {
  const CouponTypeListScreen({super.key});

  @override
  State<CouponTypeListScreen> createState() => _CouponTypeListScreenState();
}

class _CouponTypeListScreenState extends State<CouponTypeListScreen> {
  late StreamController<List<CouponType>> _couponAccessStreamController;
  Stream<List<CouponType>> get onListbeaconChanged =>
      _couponAccessStreamController.stream;

  @override
  void initState() {
    super.initState();
    _couponAccessStreamController =
        StreamController<List<CouponType>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _couponAccessStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<CouponType> accessLevel = await CouponTypeService().readAll(context);
    _couponAccessStreamController.sink.add(accessLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          context.loc.coupon_type_list_title.toCapitalizeEveryInitialWord(),
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
        child: StreamBuilder<List<CouponType>?>(
          stream: onListbeaconChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CouponType> couponsTypeList = snapshot.data!;
              return couponTypeList(couponsTypeList);
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

  Widget couponTypeList(List<CouponType> couponTypeList) {
    return ListView.builder(
      itemCount: couponTypeList.length,
      itemBuilder: (context, index) {
        final currentCouponAccess = couponTypeList[index];
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
              Icons.type_specimen,
              color: Colors.black,
            ),
            title: Text(
              context.loc.coupon_type_list_tile_title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              currentCouponAccess.type.toCapitalizeEveryInitialWord(),
              style: const TextStyle(
                color: mainItemContentColor,
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
