class Beacon {
  String id, name, uuid;

  Beacon({
    required this.id,
    required this.name,
    required this.uuid,
  });

  factory Beacon.fromJson(Map<String, dynamic> json) {
    return Beacon(
      id: json['_id'],
      name: json['name'],
      uuid: json['uuid'],
    );
  }
}
