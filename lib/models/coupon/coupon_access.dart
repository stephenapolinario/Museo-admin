class CouponAccess {
  final String access, id;

  CouponAccess({
    required this.access,
    required this.id,
  });

  factory CouponAccess.fromJson(Map<String, dynamic> json) {
    return CouponAccess(
      access: json['access'],
      id: json['_id'],
    );
  }
}
