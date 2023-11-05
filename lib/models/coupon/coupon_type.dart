class CouponType {
  final String type, id;

  CouponType({
    required this.type,
    required this.id,
  });

  factory CouponType.fromJson(Map<String, dynamic> json) {
    return CouponType(type: json['type'], id: json['_id']);
  }
}
