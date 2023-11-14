import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/museum_piece.dart';
import 'package:museo_admin_application/screens/museumPiece/museum_piece_create_screen.dart';
import 'package:museo_admin_application/screens/museumPiece/museum_piece_update.dart';
import 'package:museo_admin_application/services/museum_piece_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

class MuseumPieceListScreen extends StatefulWidget {
  const MuseumPieceListScreen({super.key});

  @override
  State<MuseumPieceListScreen> createState() => MuseumPieceListScreenState();
}

class MuseumPieceListScreenState extends State<MuseumPieceListScreen> {
  late StreamController<List<MuseumPiece>> _museumPieceStreamController;
  Stream<List<MuseumPiece>> get onListmuseumPieceChanged =>
      _museumPieceStreamController.stream;

  @override
  void initState() {
    super.initState();
    _museumPieceStreamController =
        StreamController<List<MuseumPiece>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _museumPieceStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<MuseumPiece> data = await MuseumPieceService().readAll(context);
    _museumPieceStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          context.loc.museum_piece_screen_list.toCapitalizeFirstWord(),
        ),
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
                  builder: (BuildContext context) => MuseumPieceCreateScreen(
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
        child: StreamBuilder<List<MuseumPiece>?>(
          stream: onListmuseumPieceChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MuseumPiece> museumPieceList = snapshot.data!;
              return museumPieceListWidget(museumPieceList);
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

  Widget museumPieceListWidget(List<MuseumPiece> museumPieceList) {
    return SingleChildScrollView(
      child: Column(
        children: museumPieceList.map((currentMuseumPiece) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentMuseumPiece.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.museum_outlined,
                color: Colors.black,
              ),
              title: Text(
                currentMuseumPiece.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentMuseumPiece.beacon == null
                        ? "Beacon deletado"
                        : "Beacon ${currentMuseumPiece.beacon?.name}",
                    style: TextStyle(
                      color: currentMuseumPiece.beacon == null
                          ? Colors.red
                          : mainItemContentColor,
                    ),
                  ),
                  Text(
                    currentMuseumPiece.tour == null
                        ? "Tour deletado"
                        : "Tour ${currentMuseumPiece.tour?.title}",
                    style: TextStyle(
                      color: currentMuseumPiece.tour == null
                          ? Colors.red
                          : mainItemContentColor,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              MuseumPieceUpdateScreen(
                            museumPiece: currentMuseumPiece,
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
                        title: context.loc.museum_piece_sure_want_delete_title,
                        content:
                            context.loc.museum_piece_sure_want_delete_content,
                        optionsBuilder: () => {
                          context.loc.sure_want_delete_option_yes: true,
                          context.loc.sure_want_delete_option_false: false,
                        },
                      );
                      if (context.mounted && wantDelete) {
                        await MuseumPieceService()
                            .delete(context, currentMuseumPiece);
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
