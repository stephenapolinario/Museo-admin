import 'package:museo_admin_application/models/coupon/coupon_access.dart';
import 'package:museo_admin_application/models/coupon/coupon_type.dart';

class Coupon {
  final String code, id;
  final List<CouponType> type;
  final List<CouponAccess> access;
  final double percentage, value;

  Coupon({
    required this.id,
    required this.code,
    required this.access,
    required this.type,
    required this.percentage,
    required this.value,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    var typeListData = json['type'] as List<dynamic>;
    var accessListData = json['access'] as List<dynamic>;

    List<CouponType> typeList = typeListData
        .map(
          (coupon) => CouponType(type: coupon['type'], id: coupon['_id']),
        )
        .toList();

    List<CouponAccess> accessList = accessListData
        .map(
          (coupon) => CouponAccess(
            access: coupon['access'],
            id: coupon['_id'],
          ),
        )
        .toList();

    return Coupon(
      id: json['_id'],
      percentage: json['percentage'].toDouble(),
      value: json['value'].toDouble(),
      code: json['code'],
      access: accessList,
      type: typeList,
    );
  }
}
