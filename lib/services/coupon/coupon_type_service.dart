import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/coupon/coupon_type.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumCouponType { error, success }

class CouponTypeService {
  Future readAll(BuildContext context) async {
    final response = await http.get(
      Api().couponType(endpoint: ''),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final couponTypeJson = jsonDecode(response.body)['couponsType'];

    List<CouponType> couponTypeList =
        (couponTypeJson as List).map((couponType) {
      return CouponType.fromJson(couponType);
    }).toList();

    return couponTypeList;
  }
}
