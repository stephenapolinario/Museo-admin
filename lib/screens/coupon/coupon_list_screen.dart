import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/coupon/coupon.dart';
import 'package:museo_admin_application/screens/coupon/coupon_create_screen.dart';
import 'package:museo_admin_application/screens/coupon/coupon_update_screen.dart';
import 'package:museo_admin_application/services/coupon/coupon_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';

class CouponListScreen extends StatefulWidget {
  const CouponListScreen({super.key});

  @override
  State<CouponListScreen> createState() => CouponListScreenState();
}

class CouponListScreenState extends State<CouponListScreen> {
  late StreamController<List<Coupon>> _couponsStreamController;
  Stream<List<Coupon>> get onListcouponChanged =>
      _couponsStreamController.stream;

  @override
  void initState() {
    super.initState();
    _couponsStreamController = StreamController<List<Coupon>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _couponsStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<Coupon> data = await CouponService().readAll(context);
    _couponsStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.coupon_list_screen_title),
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
                  builder: (BuildContext context) => CouponCreateScreen(
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
        child: StreamBuilder<List<Coupon>?>(
          stream: onListcouponChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Coupon> data = snapshot.data!;
              return couponList(data);
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

  Widget couponList(List<Coupon> couponList) {
    return ListView.builder(
      itemCount: couponList.length,
      itemBuilder: (context, index) {
        final currentCoupon = couponList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            iconColor: Colors.black,
            key: ValueKey(currentCoupon.id),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: mainMenuItemsColor,
            leading: const Icon(
              CupertinoIcons.ticket,
              color: Colors.black,
            ),
            title: Text(
              context.loc.coupon_list_tile_title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              currentCoupon.code,
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
                        builder: (BuildContext context) => CouponUpdateScreen(
                          coupon: currentCoupon,
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
                      title: context.loc.coupon_sure_want_delete_title,
                      content: context.loc.coupon_sure_want_delete_content,
                      optionsBuilder: () => {
                        context.loc.sure_want_delete_option_yes: true,
                        context.loc.sure_want_delete_option_false: false,
                      },
                    );
                    if (context.mounted && wantDelete) {
                      await CouponService().delete(context, currentCoupon);
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
      },
    );
  }
}
