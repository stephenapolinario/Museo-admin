import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/models/ticket.dart';
import 'package:museo_admin_application/screens/ticket/ticket_create_screen.dart';
import 'package:museo_admin_application/screens/ticket/ticket_update_screen.dart';
import 'package:museo_admin_application/services/ticket_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => TicketListScreenState();
}

class TicketListScreenState extends State<TicketListScreen> {
  late StreamController<List<Ticket>> _ticketStreamController;
  Stream<List<Ticket>> get onListticketChanged =>
      _ticketStreamController.stream;

  @override
  void initState() {
    super.initState();
    _ticketStreamController = StreamController<List<Ticket>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _ticketStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<Ticket> data = await TicketService().readAll(context);
    _ticketStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.ticket_screen_list),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => TicketCreateScreen(
                    onUpdate: () {
                      fetchData();
                    },
                  ),
                ),
              )
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: StreamBuilder<List<Ticket>?>(
          stream: onListticketChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Ticket> ticketList = snapshot.data!;
              return ticketListWidget(ticketList);
            }

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget ticketListWidget(List<Ticket> ticketList) {
    return SingleChildScrollView(
      child: Column(
        children: ticketList.map((currentTicket) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentTicket.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                CupertinoIcons.ticket,
                color: Colors.black,
              ),
              title: Text(
                context.loc.ticket_item_title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentTicket.title,
                style: const TextStyle(
                  color: mainItemContentColor,
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => TicketUpdateScreen(
                            ticket: currentTicket,
                            onUpdate: () {
                              fetchData();
                            },
                          ),
                        ),
                      );
                    },
                    child: Text(context.loc.pop_menu_button_update),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      final wantDelete = await showGenericDialog(
                        context: context,
                        title: context.loc.ticket_sure_want_delete_title,
                        content: context.loc.ticket_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await TicketService().delete(context, currentTicket);
                        fetchData();
                      }
                    },
                    child: Text(
                      context.loc.pop_menu_button_delete,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
