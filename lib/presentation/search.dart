import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/presentation/add_contact.dart';
import 'package:my_app/presentation/expenses/expenses.dart';
import 'package:my_app/presentation/home/home_bloc.dart';
import 'package:my_app/widgets/my_background_color.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchQuery = '';
  late List<GroupsModel> _filteredGroups;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: TextField(
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.black54, fontSize: 18),
            border: InputBorder.none,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xff000080),
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: MyBackgroundColor(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state is InitialLoaded) {
                _filteredGroups = state.groups
                    .where((group) => group.groupname
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                if (_filteredGroups.isEmpty) {
                  return const Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                        child: Text(
                          'No groups found',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  );
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: _filteredGroups.length,
                        itemBuilder: (context, index) {
                          final filtergroup = _filteredGroups[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: filtergroup.imagepath.isNotEmpty
                                  ? FileImage(File(filtergroup.imagepath))
                                  : null,
                              child: filtergroup.imagepath.isEmpty
                                  ? const Icon(Icons.group)
                                  : null,
                            ),
                            title: Text(filtergroup.groupname),
                            onTap: () {
                              filtergroup.names.isEmpty
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => AddContact(
                                          groupsModel: filtergroup,
                                        ),
                                      ),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ExpensesScreen(
                                          groupsModel: filtergroup,
                                        ),
                                      ),
                                    );
                            },
                          );
                        }));
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      )),
    );
  }
}
