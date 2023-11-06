import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/routes.dart';

class StoreControl {
  final String name;
  final IconData icon;
  final Color? iconColor, textColor;
  final Function(BuildContext context) onTouch;

  StoreControl({
    required this.name,
    required this.icon,
    required this.onTouch,
    this.iconColor,
    this.textColor,
  });
}

final storeControlProducts = StoreControl(
  name: 'Produtos',
  icon: CupertinoIcons.ticket,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(products);
  },
);

final storeControlAccessCategory = StoreControl(
  name: 'Categorias',
  icon: Icons.category,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(productsCategory);
  },
);

final List<StoreControl> storeControls = [
  storeControlProducts,
  storeControlAccessCategory,
];
