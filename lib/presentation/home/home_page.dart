import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/add_contact.dart';
import 'package:my_app/presentation/expenses/expenses.dart';
import 'package:my_app/presentation/groups/create_group.dart';
import 'package:my_app/presentation/home/home_bloc.dart';

class HomePage extends StatelessWidget {
  // late CreateGroupBloc createGroupBloc;
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateGroup()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          BlocConsumer<GroupBloc, GroupState>(
            listener: (context, state) {},
            builder: (context, state) {
              // createGroupBloc = BlocProvider.of<CreateGroupBloc>(context);
              if (state is InitialLoaded) {
                if (state.groups.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('No Groups created yet!'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text('Add a group to start the party!!!'),
                        )
                      ],
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.groups.length,
                    itemBuilder: (context, index) {
                      final group = state.groups[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: group.imagepath.isNotEmpty
                              ? FileImage(File(group.imagepath))
                              : null,
                          child: group.imagepath.isEmpty
                              ? const Icon(Icons.person_2)
                              : null,
                        ),
                        title: Text(group.groupname),
                        onTap: () {
                          group.names.isEmpty
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AddContact(),
                                  ),
                                )
                              : Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ExpensesScreen(),
                                  ),
                                );
                        },
                      );
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
