import 'dart:async';

import 'package:flutter/material.dart';
import 'package:museo_admin_application/extensions/string.dart';
import 'package:museo_admin_application/models/user.dart';
import 'package:museo_admin_application/services/user_service.dart';
import 'package:museo_admin_application/extensions/buildcontext/loc.dart';
import 'package:museo_admin_application/constants/colors.dart';

// TODO: 1. Create a pagination
// TODO: 2. Delete and update user?

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  late StreamController<List<User>> _userStreamController;
  Stream<List<User>> get onListuserChanged => _userStreamController.stream;

  @override
  void initState() {
    super.initState();
    _userStreamController = StreamController<List<User>>.broadcast();
    fetchData();
  }

  @override
  void dispose() {
    _userStreamController.close();
    super.dispose();
  }

  void fetchData() async {
    List<User> data = await UserService().readAll(context);
    _userStreamController.sink.add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(context.loc.user_screen_list_title),
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.add,
        //       color: Colors.black,
        //       size: 35,
        //     ),
        //     onPressed: () => {
        //       // Navigator.of(context).push(
        //       //   MaterialPageRoute<void>(
        //       //     builder: (BuildContext context) => UserCreateScreen(
        //       //       onUpdate: () {
        //       //         fetchData();
        //       //       },
        //       //     ),
        //       //   ),
        //       // )
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        child: StreamBuilder<List<User>?>(
          stream: onListuserChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<User> userList = snapshot.data!;
              return userListWidget(userList);
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

  Widget userListWidget(List<User> userList) {
    return SingleChildScrollView(
      child: Column(
        children: userList.map((currentUser) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: ListTile(
              iconColor: Colors.black,
              key: ValueKey(currentUser.id),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: mainMenuItemsColor,
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                '${currentUser.name} ${currentUser.lastName}'
                    .toCapitalizeEveryInitialWord(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                currentUser.email,
                style: const TextStyle(
                  color: mainItemContentColor,
                ),
              ),
              // trailing: PopupMenuButton(
              //   itemBuilder: (context) => [
              //     PopupMenuItem(
              //       onTap: () {
              //         // Navigator.of(context).push(
              //         //   MaterialPageRoute<void>(
              //         //     builder: (BuildContext context) => TourUpdateScreen(
              //         //       tour: currentTour,
              //         //       onUpdate: () {
              //         //         fetchData();
              //         //       },
              //         //     ),
              //         //   ),
              //         // );
              //       },
              //       child: Text(context.loc.pop_menu_button_update),
              //     ),
              //     PopupMenuItem(
              //       onTap: () async {
              //         // final wantDelete = await showGenericDialog(
              //         //   context: context,
              //         //   title: 'sureWantDeleteTitle',
              //         //   content: 'sureWantDeleteContent',
              //         //   optionsBuilder: () => {
              //         //     context.loc.sure_want_delete_option_yes: true,
              //         //     context.loc.sure_want_delete_option_false: false,
              //         //   },
              //         // );
              //         // if (context.mounted && wantDelete) {
              //         //   await UserService().delete(context, currentUser);
              //         //   fetchData();
              //         // }
              //       },
              //       child: Text(
              //         context.loc.pop_menu_button_delete,
              //         style: const TextStyle(
              //           color: Colors.red,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
