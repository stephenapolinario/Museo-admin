import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/store/store_control.dart';

class StoreHomeScreen extends StatelessWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.product_home_screen),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 16,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: storeControls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final option = storeControls[index];
              return couponControl(
                option: option,
                parentContext: parentContext,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget couponControl({
    required StoreControl option,
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
