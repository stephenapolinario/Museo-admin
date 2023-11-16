import 'package:flutter/material.dart';

extension StringExtension on String {
  String toCapitalizeEveryInitialWord() {
    if (isEmpty) {
      return '';
    }
    final words = split(' ');
    final formattedWords = words.map((word) {
      if (word.isEmpty) {
        return '';
      }
      final firstLetter = word[0].toUpperCase();
      final restOfWord = word.substring(1).toLowerCase();
      return firstLetter + restOfWord;
    });
    return formattedWords.join(' ');
  }

  String toCapitalizeFirstWord() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  Color fromHex() {
    String hexColor = replaceAll('#', '');

    RegExp hexRegex = RegExp(r'^([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

    if (!hexRegex.hasMatch(hexColor)) {
      return Colors.black;
    }

    int parsedColor = int.parse(hexColor, radix: 16);

    return Color(parsedColor);
  }
}
