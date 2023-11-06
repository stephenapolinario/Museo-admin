class Tour {
  String id, title, subtitle, image;

  Tour({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
    );
  }
}
