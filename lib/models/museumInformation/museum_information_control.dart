import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/routes.dart';

class MuseumInformationControl {
  final String name;
  final IconData icon;
  final Color? iconColor, textColor;
  final Function(BuildContext context) onTouch;

  MuseumInformationControl({
    required this.name,
    required this.icon,
    required this.onTouch,
    this.iconColor,
    this.textColor,
  });
}

final museumInformationControlAddress = MuseumInformationControl(
  name: 'Endereço',
  icon: Icons.location_on_outlined,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(museumAddress);
  },
);

final museumInformationControlPhone = MuseumInformationControl(
  name: 'Telefones',
  icon: Icons.phone,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(museumPhone);
  },
);

final museumInformationControlEmail = MuseumInformationControl(
  name: 'Emails',
  icon: Icons.email_rounded,
  onTouch: (BuildContext context) {
    Navigator.of(context).pushNamed(museumEmail);
  },
);

final List<MuseumInformationControl> museumInformationControls = [
  museumInformationControlAddress,
  museumInformationControlPhone,
  museumInformationControlEmail
];
