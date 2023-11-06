import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/coupon/coupon_control.dart';

class CouponHomeScreen extends StatelessWidget {
  const CouponHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.coupon_home_screen),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: couponControls.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            final option = couponControls[index];
            return couponControl(
              option: option,
              parentContext: parentContext,
            );
          },
        ),
      ),
    );
  }

  Widget couponControl({
    required CouponControl option,
    required BuildContext parentContext,
  }) {
    return InkWell(
      onTap: () => option.onTouch(parentContext),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: mainMenuItemsColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              option.name,
              style: TextStyle(
                color: option.textColor,
              ),
            ),
            Icon(
              option.icon,
              size: 50,
              color: option.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
