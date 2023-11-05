import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/coupon/coupon_access.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumCouponAcces { error, success }

class CouponAccessService {
  Future readAll(BuildContext context) async {
    final response = await http.get(
      Api().couponAccess(endpoint: ''),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final couponAccessJson = jsonDecode(response.body)['couponAccesss'];

    List<CouponAccess> couponAccessList =
        (couponAccessJson as List).map((couponAccess) {
      return CouponAccess.fromJson(couponAccess);
    }).toList();

    return couponAccessList;
  }
}
