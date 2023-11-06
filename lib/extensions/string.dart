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
}
