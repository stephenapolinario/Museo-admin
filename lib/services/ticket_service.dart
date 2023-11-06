import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:museo_admin_application/models/ticket.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/services/endpoints.dart';

enum EnumTicket { error, success }

class TicketService {
  Future<List<Ticket>> readAll(BuildContext context) async {
    final response = await http.get(
      Api().ticket(endpoint: '/'),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body)['tickets'];

    List<Ticket> tickets = (data as List).map((object) {
      return Ticket.fromJson(object);
    }).toList();

    return tickets;
  }

  Future<EnumTicket> delete(BuildContext context, Ticket ticket) async {
    final response = await http.delete(
      Api().ticket(endpoint: ticket.id),
      headers: adminJwt(context),
    );

    if (response.statusCode != 200) {
      return EnumTicket.error;
    }

    return EnumTicket.success;
  }

  Future<EnumTicket> update(
    BuildContext context,
    Ticket ticket,
    String title,
    String subtitle,
    String description,
    double price,
  ) async {
    final response = await http.patch(
      Api().ticket(endpoint: '/${ticket.id}'),
      headers: adminJwt(context),
      body: {
        'name': title,
        'subname': subtitle,
        'description': description,
        'price': price.toString(),
      },
    );

    if (response.statusCode != 200) {
      return EnumTicket.error;
    }

    return EnumTicket.success;
  }

  Future<EnumTicket> create(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    double price,
  ) async {
    final response = await http.post(
      Api().ticket(endpoint: ''),
      body: {
        'name': title,
        'subname': subtitle,
        'description': description,
        'price': price.toString(),
      },
      headers: adminJwt(context),
    );

    if (response.statusCode != 201) {
      return EnumTicket.error;
    }

    return EnumTicket.success;
  }
}
