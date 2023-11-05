import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/coupon/coupon.dart';
import 'package:museo_admin_application/models/coupon/coupon_access.dart';
import 'package:museo_admin_application/models/coupon/coupon_type.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumCoupon { error, success, duplicatedCode }

class CouponService {
  Future<List<Coupon>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().coupon(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['coupons'];

    List<Coupon> objectList = (data as List).map((object) {
      return Coupon.fromJson(object);
    }).toList();

    return objectList;
  }

  Future<EnumCoupon> delete(BuildContext context, Coupon object) async {
    final response = await http.delete(
      Api().coupon(endpoint: object.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumCoupon.error;
    }

    return EnumCoupon.success;
  }

  Future<EnumCoupon> create(
    BuildContext context,
    String code,
    List<CouponType?> types,
    List<CouponAccess?> accesses,
    double? percentage,
    double? value,
  ) async {
    Map<String, dynamic> body = {
      'code': code,
      if (types.isNotEmpty) 'type': types.map((type) => type!.id).toList(),
      if (accesses.isNotEmpty)
        'access': accesses.map((access) => access!.id).toList(),
      'percentage': percentage ?? 0,
      'value': value ?? 0,
    };

    final response = await http.post(
      Api().coupon(endpoint: ''),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode != 201) {
      if (jsonBody['error'] == 'Failed! Coupon code already exists!') {
        return EnumCoupon.duplicatedCode;
      }
      return EnumCoupon.error;
    }

    return EnumCoupon.success;
  }

  Future<EnumCoupon> update(
    Coupon coupon,
    BuildContext context,
    String code,
    List<CouponType?> types,
    List<CouponAccess?> accesses,
    double? percentage,
    double? value,
  ) async {
    Map<String, dynamic> body = {
      'code': code,
      if (types.isNotEmpty) 'type': types.map((type) => type!.id).toList(),
      if (accesses.isNotEmpty)
        'access': accesses.map((access) => access!.id).toList(),
      'percentage': percentage ?? 0,
      'value': value ?? 0,
    };

    final response = await http.patch(
      Api().coupon(endpoint: '/${coupon.id}'),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode != 201) {
      if (jsonBody['error'] == 'Failed! Coupon code already exists!') {
        return EnumCoupon.duplicatedCode;
      }
      return EnumCoupon.error;
    }

    return EnumCoupon.success;
  }
}
