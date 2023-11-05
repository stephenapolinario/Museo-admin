import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/routes.dart';

class CouponControl {
  final String name;
  final IconData icon;
  final Color? iconColor, textColor;
  final Function(BuildContext context) onTouch;

  CouponControl({
    required this.name,
    required this.icon,
    required this.onTouch,
    this.iconColor,
    this.textColor,
  });
}

final couponControlCoupons = CouponControl(
  name: 'Cupoms',
  icon: CupertinoIcons.ticket,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(couponList);
  },
);

final couponControlAccessCoupons = CouponControl(
  name: 'Níveis de acesso',
  icon: Icons.security,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(couponAccess);
  },
);

final couponControlTypeCoupons = CouponControl(
  name: 'Tipos de cupom',
  icon: Icons.type_specimen,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(couponType);
  },
);

final List<CouponControl> couponControls = [
  couponControlCoupons,
  couponControlAccessCoupons,
  couponControlTypeCoupons
];
