import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/models/museum_piece.dart';
import 'package:museo_admin_application/models/tour.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumMuseumPiece { error, success }

class MuseumPieceService {
  Future<List<MuseumPiece>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().museumPiece(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['museumPieces'];

    List<MuseumPiece> museumPieceList = (data as List).map((object) {
      return MuseumPiece.fromJson(object);
    }).toList();

    return museumPieceList;
  }

  Future<EnumMuseumPiece> delete(
      BuildContext context, MuseumPiece museumPiece) async {
    final response = await http.delete(
      Api().museumPiece(endpoint: museumPiece.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumMuseumPiece.error;
    }

    return EnumMuseumPiece.success;
  }

  Future<EnumMuseumPiece> update(
    BuildContext context,
    MuseumPiece museumPiece,
    String title,
    String subtitle,
    String description,
    String image,
    int rssi,
    String color,
    Beacon beacon,
    Tour tour,
  ) async {
    Map<String, dynamic> body = {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
      'rssi': rssi.toString(),
      'color': color,
      'beacon': beacon.id,
      'tour': tour.id,
    };

    final response = await http.patch(
      Api().museumPiece(endpoint: '/${museumPiece.id}'),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 200) {
      return EnumMuseumPiece.error;
    }

    return EnumMuseumPiece.success;
  }

  Future<EnumMuseumPiece> create(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    String image,
    int rssi,
    String color,
    Beacon beacon,
    Tour tour,
  ) async {
    Map<String, dynamic> body = {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
      'rssi': rssi.toString(),
      'color': color,
      'beacon': beacon.id,
      'tour': tour.id,
    };

    final response = await http.post(
      Api().museumPiece(endpoint: ''),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...adminJwt(context),
      },
    );

    if (response.statusCode != 201) {
      return EnumMuseumPiece.error;
    }

    return EnumMuseumPiece.success;
  }
}
