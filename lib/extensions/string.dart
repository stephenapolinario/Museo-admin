extension StringExtension on String {
  String toCapitalize() {
    return split(' ')
        .map((word) =>
            '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
    // Old
    // return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
