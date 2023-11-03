import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/models/admin.dart';
import 'package:museo_admin_application/services/admin.dart';
import 'package:museo_admin_application/utilities/generic_dialog.dart';

class AdminListView extends StatefulWidget {
  const AdminListView({super.key});

  @override
  State<AdminListView> createState() => _AdminListViewState();
}

class _AdminListViewState extends State<AdminListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.loc.admin_list_title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: FutureBuilder(
          future: AdminService().getAllAdmin(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.data == false || snapshot.data == null) {
                  return Center(
                    child: Text(
                      context.loc.adminn_list_error_retreiving_admins,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                List<ReadAdmin> adminList = snapshot.data;
                return adminsList(adminList);

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
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
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            tileColor: Colors.cyan.shade800,
            leading: const Icon(
              CupertinoIcons.person_solid,
              color: Colors.black,
            ),
            //In the future, this can be the user of the administrador (Right now admin only have email and password)
            title: Text(
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
                  child: Text(context.loc.pop_menu_button_update),
                ),
                PopupMenuItem(
                  onTap: () async {
                    final wantDelete = await showGenericDialog(
                      context: context,
                      title: context.loc.sure_want_delete_title,
                      content: context.loc.sure_want_delete_content,
                      optionsBuilder: () => {
                        context.loc.sure_want_delete_option_yes: true,
                        context.loc.sure_want_delete_option_false: false,
                      },
                    ).then((value) => value);
                    if (context.mounted && wantDelete) {
                      await AdminService()
                          .deleteAdmin(context, currentAdmin.id);
                    }
                  },
                  child: Text(context.loc.pop_menu_button_delete),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
