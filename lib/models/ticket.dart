class Ticket {
  String id, title, subtitle, description;
  double price;

  Ticket({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'],
      title: json['name'],
      subtitle: json['subname'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}
