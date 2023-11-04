import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/beacon.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumBeaconStatus { error, success, duplicatedUUID }

class BeaconService {
  Future<List<Beacon>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().beacon(endpoint: ''),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final beaconsJson = jsonDecode(response.body)['beacons'];

    List<Beacon> beaconsList = (beaconsJson as List).map((beacon) {
      return Beacon.fromJson(beacon);
    }).toList();

    return beaconsList;
  }

  Future<EnumBeaconStatus> create(
    BuildContext context,
    String name,
    String uuid,
  ) async {
    final response = await http.post(
      Api().beacon(endpoint: ''),
      body: {
        'name': name,
        'uuid': uuid,
      },
      headers: adminJwt(context),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode != 201) {
      if (jsonBody['error'] == 'There is already an beacon with this UUID') {
        return EnumBeaconStatus.duplicatedUUID;
      }
      return EnumBeaconStatus.error;
    }

    return EnumBeaconStatus.success;
  }

  Future<EnumBeaconStatus> update(
    BuildContext context,
    String id,
    String name,
    String uuid,
  ) async {
    final response = await http.patch(
      Api().beacon(endpoint: '/$id'),
      body: {
        'name': name,
        'uuid': uuid,
      },
      headers: adminJwt(context),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode != 200) {
      if (jsonBody['error'] == 'There is already an beacon with this UUID') {
        return EnumBeaconStatus.duplicatedUUID;
      }
      return EnumBeaconStatus.error;
    }

    return EnumBeaconStatus.success;
  }

  Future<EnumBeaconStatus> delete(
    BuildContext context,
    Beacon beacon,
  ) async {
    final response = await http.delete(
      Api().beacon(endpoint: '/${beacon.id}'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumBeaconStatus.error;
    }

    return EnumBeaconStatus.success;
  }
}
