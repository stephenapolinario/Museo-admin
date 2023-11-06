import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/constants/colors.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/emblem.dart';
import 'package:museo_admin_application/screens/emblem/emblem_create_screen.dart';
import 'package:museo_admin_application/screens/emblem/emblem_update_screen.dart';
import 'package:museo_admin_application/services/emblem_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';

// TODO: 1. Create a search by quiz/tour
// TODO: 2. Create an image upload to the emblem instead of using URL for the image.

class EmblemListScreen extends StatefulWidget {
  const EmblemListScreen({super.key});

  @override
  State<EmblemListScreen> createState() => EmblemListScreenState();
}

class EmblemListScreenState extends State<EmblemListScreen> {
  late StreamController<List<Emblem>> _emblemStreamController;
  Stream<List<Emblem>> get onListemblemChanged =>
      _emblemStreamController.stream;

  @override
  void initState() {
    super.initState();
    _emblemStreamController = StreamController<List<Emblem>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _emblemStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<Emblem> data = await EmblemService().readAll(context);
    _emblemStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.emblem_list_screen_title
            .toCapitalizeEveryInitialWord()),
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
                  builder: (BuildContext context) => EmblemCreateScreen(
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
        child: StreamBuilder<List<Emblem>?>(
          stream: onListemblemChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Emblem> emblemList = snapshot.data!;
              return emblemListView(emblemList);
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

  Widget emblemListView(List<Emblem> emblemList) {
    return ListView.builder(
      itemCount: emblemList.length,
      itemBuilder: (context, index) {
        final currentEmblem = emblemList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            iconColor: Colors.black,
            key: ValueKey(currentEmblem.id),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: mainMenuItemsColor,
            leading: const Icon(
              Icons.badge,
              color: Colors.black,
            ),
            title: Text(
              currentEmblem.title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              currentEmblem.quiz.title,
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
                        builder: (BuildContext context) => EmblemUpdateScreen(
                          emblem: currentEmblem,
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
                      title: context.loc.emblem_sure_want_delete_title,
                      content: context.loc.emblem_sure_want_delete_content,
                      optionsBuilder: () => {
                        context.loc.sure_want_delete_option_yes: true,
                        context.loc.sure_want_delete_option_false: false,
                      },
                    );
                    if (context.mounted && wantDelete) {
                      await EmblemService().delete(context, currentEmblem);
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
      },
    );
  }
}
