import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/presentation/contacts/access_contacts.dart';
import 'package:my_app/presentation/groups/create_group_bloc.dart';

class AddContact extends StatelessWidget {
  const AddContact({super.key});

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
          appBar: AppBar(),
          body: BlocBuilder<CreateGroupBloc, CreateGroupState>(
            builder: (context, state) {
              if (state is CreateGroupSuccessState) {
                // final imagepath = state.imagepath;

                // final name = state.name;
                // print("Name is $name");
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: state.imagepath.isNotEmpty
                            ? FileImage(File(state.imagepath))
                            : null,
                        child: state.imagepath.isEmpty
                            ? const Icon(Icons.camera_alt_sharp)
                            : null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(state.name),
                      const SizedBox(
                        height: 300,
                      ),
                      const Center(
                        child: Text('You are the only one here!!'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AccessContacts()));
                        },
                        child: const Text('Add group members'),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
