import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/store/product_category.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumProductCategory { error, success }

class ProductCategoryService {
  Future<List<ProductCategory>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().productCategory(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['categorys'];

    List<ProductCategory> objectList = (data as List).map((object) {
      return ProductCategory.fromJson(object);
    }).toList();

    return objectList;
  }

  Future<EnumProductCategory> delete(
      BuildContext context, ProductCategory productCategory) async {
    final response = await http.delete(
      Api().productCategory(endpoint: productCategory.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumProductCategory.error;
    }

    return EnumProductCategory.success;
  }

  Future<EnumProductCategory> update(
    BuildContext context,
    ProductCategory productCategory,
    String name,
  ) async {
    final response = await http.patch(
      Api().productCategory(endpoint: '/${productCategory.id}'),
      headers: adminJwt(context),
      body: {
        'name': name,
      },
    );

    if (response.statusCode != 200) {
      return EnumProductCategory.error;
    }

    return EnumProductCategory.success;
  }

  Future<EnumProductCategory> create(
    BuildContext context,
    String name,
  ) async {
    final response = await http.post(
      Api().productCategory(endpoint: ''),
      body: {
        'name': name,
      },
      headers: adminJwt(context),
    );

    if (response.statusCode != 201) {
      return EnumProductCategory.error;
    }

    return EnumProductCategory.success;
  }
}
