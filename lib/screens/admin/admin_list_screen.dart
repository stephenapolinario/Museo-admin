import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/admin.dart';
import 'package:museo_admin_application/screens/admin/admin_create_screen.dart';
import 'package:museo_admin_application/screens/admin/admin_update_screen.dart';
import 'package:museo_admin_application/services/admin_service.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';

class AdminListScreen extends StatefulWidget {
  const AdminListScreen({super.key});

  @override
  State<AdminListScreen> createState() => _AdminListScreenState();
}

class _AdminListScreenState extends State<AdminListScreen> {
  late StreamController<List<ReadAdmin>> _adminStreamController;
  Stream<List<ReadAdmin>> get onListAdminChanged =>
      _adminStreamController.stream;

  @override
  void initState() {
    super.initState();
    _adminStreamController = StreamController<List<ReadAdmin>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _adminStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<ReadAdmin> admins = await AdminService().readAll(context);
    _adminStreamController.sink.add(admins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.loc.admin_list_title),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.person_add,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AdminCreateScreen(
                    onUpdate: () {
                      fetchData(); // Call the method to update the stream when the admin is updated.
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
        child: StreamBuilder<List<ReadAdmin>?>(
          stream: onListAdminChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ReadAdmin> adminList = snapshot.data!;
              return adminsList(adminList);
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

  Widget adminsList(List<ReadAdmin> adminList) {
    return ListView.builder(
      itemCount: adminList.length,
      itemBuilder: (context, index) {
        final currentAdmin = adminList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            iconColor: Colors.black,
            key: ValueKey(currentAdmin.id),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            tileColor: Colors.cyan.shade800,
            leading: const Icon(
              CupertinoIcons.person_solid,
              color: Colors.black,
            ),
            title: Text(
              //In the future, this can be the user of the administrador (Right now admin only have email and password)
              context.loc.admin_list_tile_title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              currentAdmin.email,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AdminUpdateScreen(
                          admin: currentAdmin,
                          onUpdate: () {
                            fetchData(); // Call the method to update the stream when the admin is updated.
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
                      title: context.loc.admin_sure_want_delete_title,
                      content: context.loc.admin_sure_want_delete_content,
                      optionsBuilder: () => {
                        context.loc.sure_want_delete_option_yes: true,
                        context.loc.sure_want_delete_option_false: false,
                      },
                    );
                    if (context.mounted && wantDelete) {
                      await AdminService().delete(context, currentAdmin);
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
