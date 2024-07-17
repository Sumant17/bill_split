import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/add_contact.dart';
import 'package:my_app/presentation/expenses/expenses.dart';
import 'package:my_app/presentation/home/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'DashBoard',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isGridView = !isGridView;
                });
              },
              icon: Icon(isGridView ? Icons.view_list : Icons.grid_on))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Color.fromARGB(47, 196, 200, 214)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            BlocConsumer<GroupBloc, GroupState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is InitialLoaded) {
                  if (state.groups.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 100),
                          Text(
                            'No Groups created yet!',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add a group to start the party!!!',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: isGridView
                        ? GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: state.groups.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemBuilder: (context, index) {
                              final group = state.groups[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Color.fromARGB(47, 196, 200, 214)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: InkWell(
                                    onTap: () {
                                      group.names.isEmpty
                                          ? Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddContact(
                                                  groupsModel: group,
                                                ),
                                              ),
                                            )
                                          : Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ExpensesScreen(
                                                  groupsModel: group,
                                                ),
                                              ),
                                            );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              group.imagepath.isNotEmpty
                                                  ? FileImage(
                                                      File(group.imagepath),
                                                    )
                                                  : null,
                                          child: group.imagepath.isEmpty
                                              ? const Icon(
                                                  Icons.group,
                                                  size: 30,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          group.groupname,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '${group.names.length + 1} members',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: state.groups.length,
                            itemBuilder: (context, index) {
                              final group = state.groups[index];
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Color.fromARGB(47, 196, 200, 214)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16.0),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          group.imagepath.isNotEmpty
                                              ? FileImage(File(group.imagepath))
                                              : null,
                                      child: group.imagepath.isEmpty
                                          ? const Icon(Icons.group, size: 30)
                                          : null,
                                    ),
                                    title: Text(
                                      group.groupname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${group.names.length + 1} members',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black),
                                    onTap: () {
                                      group.names.isEmpty
                                          ? Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddContact(
                                                  groupsModel: group,
                                                ),
                                              ),
                                            )
                                          : Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ExpensesScreen(
                                                  groupsModel: group,
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ),
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
      ),
    );
  }
}
