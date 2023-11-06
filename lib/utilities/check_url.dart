bool isUrl(String url) {
  return Uri.tryParse(url)?.hasAbsolutePath ?? false;
}
