import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/presentation/contacts/access_contacts.dart';
import 'package:my_app/widgets/my_background_color.dart';

class AddContact extends StatelessWidget {
  final GroupsModel groupsModel;
  const AddContact({super.key, required this.groupsModel});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomNavBar()),
            (Route<dynamic> route) => false,
          );
        });
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Add Contact',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: MyBackgroundColor(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 110,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: groupsModel.imagepath.isNotEmpty
                      ? FileImage(File(groupsModel.imagepath))
                      : null,
                  child: groupsModel.imagepath.isEmpty
                      ? const Icon(Icons.group)
                      : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  groupsModel.groupname,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 290,
                ),
                const Center(
                  child: Text(
                    'You are the only one here!!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 300,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AccessContacts(
                            groupimagepath: groupsModel.imagepath,
                            groupname: groupsModel.groupname,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xff000080),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    ),
                    child: const Text(
                      'Add group members',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => AccessContacts(
                //           groupimagepath: groupsModel.imagepath,
                //           groupname: groupsModel.groupname,
                //         ),
                //       ),
                //     );
                //   },
                //   child: const Text('Add group members'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
