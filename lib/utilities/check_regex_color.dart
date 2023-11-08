bool isHexColor(String color) {
  final hexColorRegex = RegExp(r'^([A-Fa-f0-9]{6})$');
  // final hexColorRegex = RegExp(r'^([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
  return hexColorRegex.hasMatch(color);
}
