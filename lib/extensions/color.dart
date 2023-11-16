import 'package:flutter/material.dart';

extension ColorExtension on Color {
  String toHex() {
    return value.toRadixString(16);
  }
}
