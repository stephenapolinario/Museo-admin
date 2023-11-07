import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/routes.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/helpers/loading_complete.dart';
import 'package:provider/provider.dart';

import '../providers/admin.dart';

class AdminControl {
  final String name;
  final IconData icon;
  final Color? iconColor, textColor;
  final Function(BuildContext context) onTouch;

  AdminControl({
    required this.name,
    required this.icon,
    required this.onTouch,
    this.iconColor,
    this.textColor,
  });
}

final adminControlAdmin = AdminControl(
  name: 'Administradores',
  icon: Icons.admin_panel_settings,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(admin);
  },
);

final adminControlBeacon = AdminControl(
  name: 'Beacons',
  icon: Icons.bluetooth,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(beacon);
  },
);

final adminControlCoupon = AdminControl(
  name: 'Cupoms',
  icon: Icons.discount,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(couponHome);
  },
);

final adminControlEmblem = AdminControl(
  name: 'Emblemas',
  icon: Icons.badge,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(emblem);
  },
);

final adminControlMuseumInformation = AdminControl(
  name: 'Informações do museu',
  icon: Icons.info,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(homeMuseumInformation);
  },
);

final adminControlMuseumPiece = AdminControl(
  name: 'Peças de museu',
  icon: Icons.museum_outlined,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(museumPiece);
  },
);

final adminControlStore = AdminControl(
  name: 'Lojinha',
  icon: Icons.shopify_outlined,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(homeProducts);
  },
);

final adminControlQuiz = AdminControl(
  name: 'Quizzes',
  icon: Icons.quiz,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(quiz);
  },
);

final adminControlTicket = AdminControl(
  name: 'Ingressos',
  icon: CupertinoIcons.tickets,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(ticket);
  },
);

final adminControlTour = AdminControl(
  name: 'Tours',
  icon: Icons.route,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(tour);
  },
);

final adminControlUser = AdminControl(
  name: 'Usuários',
  icon: Icons.supervised_user_circle,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(user);
  },
);

final adminLogout = AdminControl(
  name: 'Sair',
  icon: Icons.logout,
  iconColor: Colors.red,
  textColor: Colors.red,
  onTouch: (BuildContext context) async {
    final navigator = Navigator.of(context);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.logout();

    await loadingMessageTime(
      title: context.loc.home_logout_title,
      subtitle: context.loc.home_logout_subtitle,
      context: context,
    );

    navigator.popAndPushNamed(login);
  },
);

final List<AdminControl> administrationControls = [
  adminControlAdmin,
  adminControlBeacon,
  adminControlCoupon,
  adminControlEmblem,
  adminControlMuseumInformation,
  adminControlMuseumPiece,
  adminControlStore,
  adminControlQuiz,
  adminControlTicket,
  adminControlTour,
  adminControlUser,
  adminLogout,
];
