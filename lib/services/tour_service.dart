import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumTour { error, success }

class TourService {
  Future<List<Tour>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().tour(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['tours'];

    List<Tour> tourList = (data as List).map((object) {
      return Tour.fromJson(object);
    }).toList();

    return tourList;
  }

  Future<EnumTour> delete(BuildContext context, Tour tour) async {
    final response = await http.delete(
      Api().tour(endpoint: tour.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumTour.error;
    }

    return EnumTour.success;
  }

  Future<EnumTour> update(
    BuildContext context,
    Tour tour,
    String title,
    String subtitle,
    String image,
  ) async {
    final response = await http.patch(
      Api().tour(endpoint: '/${tour.id}'),
      headers: adminJwt(context),
      body: {
        'title': title,
        'subtitle': subtitle,
        'image': image,
      },
    );

    if (response.statusCode != 200) {
      return EnumTour.error;
    }

    return EnumTour.success;
  }

  Future<EnumTour> create(
    BuildContext context,
    String title,
    String subtitle,
    String image,
  ) async {
    final response = await http.post(
      Api().tour(endpoint: ''),
      body: {
        'title': title,
        'subtitle': subtitle,
        'image': image,
      },
      headers: adminJwt(context),
    );

    if (response.statusCode != 201) {
      return EnumTour.error;
    }

    return EnumTour.success;
  }
}
