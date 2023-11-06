import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/store/product.dart';
import 'package:museo_admin_application/models/store/product_category.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumProduct { error, success }

class ProductService {
  Future<List<Product>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().product(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['products'];

    List<Product> objectList = (data as List).map((object) {
      return Product.fromJson(object);
    }).toList();

    return objectList;
  }

  Future<EnumProduct> delete(BuildContext context, Product object) async {
    final response = await http.delete(
      Api().product(endpoint: object.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumProduct.error;
    }

    return EnumProduct.success;
  }

  Future<EnumProduct> update(
    BuildContext context,
    Product product,
    String name,
    String description,
    String image,
    String size,
    double price,
    String color,
    ProductCategory productCategory,
  ) async {
    final response = await http.patch(
      Api().product(endpoint: '/${product.id}'),
      headers: adminJwt(context),
      body: {
        'name': name,
        'description': description,
        'image': image,
        'size': size,
        'price': price.toString(),
        'color': color,
        'category': productCategory.id,
      },
    );

    if (response.statusCode != 200) {
      return EnumProduct.error;
    }

    return EnumProduct.success;
  }

  Future<EnumProduct> create(
    BuildContext context,
    String name,
    String description,
    String image,
    String size,
    double price,
    String color,
    ProductCategory productCategory,
  ) async {
    final response = await http.post(
      Api().product(endpoint: ''),
      body: {
        'name': name,
        'description': description,
        'image': image,
        'size': size,
        'price': price.toString(),
        'color': color,
        'category': productCategory.id,
      },
      headers: adminJwt(context),
    );

    if (response.statusCode != 201) {
      return EnumProduct.error;
    }

    return EnumProduct.success;
  }
}
