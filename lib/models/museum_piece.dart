import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/tour.dart';

class MuseumPiece {
  String id, title, subtitle, description, image, color;
  int rssi;
  Beacon? beacon;
  Tour? tour;

  MuseumPiece({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.color,
    required this.rssi,
    required this.beacon,
    required this.tour,
  });

  factory MuseumPiece.fromJson(Map<String, dynamic> json) {
    final beacon =
        json['beacon'] != null ? Beacon.fromJson(json['beacon']) : null;
    final tour = json['tour'] != null ? Tour.fromJson(json['tour']) : null;
    // final beacon = Beacon.fromJson(json['beacon']);
    // final tour = Tour.fromJson(json['tour']);

    return MuseumPiece(
      id: json['_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      image: json['image'],
      color: json['color'],
      rssi: json['rssi'],
      beacon: beacon,
      tour: tour,
    );
  }
}
