import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/add_contact.dart';
import 'package:my_app/presentation/groups/create_group_bloc.dart';
import 'package:my_app/presentation/home/home_bloc.dart';

class CreateGroup extends StatelessWidget {
  late CreateGroupBloc createGroupBloc;
  final TextEditingController groupname = TextEditingController();
  CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: const Icon(Icons.cancel),
        title: Text('Create a group'),
        actions: [
          BlocConsumer<CreateGroupBloc, CreateGroupState>(
            listener: (context, state) {},
            builder: (context, state) {
              createGroupBloc = BlocProvider.of<CreateGroupBloc>(context);
              return TextButton(
                onPressed: () {
                  createGroupBloc.add(
                    OnDoneButtonClicked(
                        name: groupname.text,
                        imagepath: createGroupBloc.imagepath),
                  );

                  // createGroupBloc.add(
                  //   CreateGroupList(
                  //       name: groupname.text,
                  //       imagepath: createGroupBloc.imagepath),
                  // );
                  // print('Triggering the create group list here');
                },
                child: const Text('Done'),
              );
            },
          ),
        ],
      ),
      body: BlocListener<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) {
          if (state is CreateGroupSuccessState) {
            //triggering this create group event to display it in home page
            BlocProvider.of<GroupBloc>(context).add(CreateGroupList(
                groupname: state.name, groupimagepath: state.imagepath));
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddContact()),
              );
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlocConsumer<CreateGroupBloc, CreateGroupState>(
                listener: (context, state) {},
                builder: (context, state) {
                  createGroupBloc = BlocProvider.of<CreateGroupBloc>(context);
                  final imagepath = createGroupBloc.imagepath;
                  return GestureDetector(
                    onTap: () {
                      createGroupBloc
                          .add(OnGroupPicClicked(imagepath: imagepath));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imagepath.isNotEmpty
                          ? FileImage(
                              File(imagepath),
                            )
                          : null,
                      child: imagepath.isNotEmpty
                          ? null
                          : const Icon(Icons.camera_alt),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: groupname,
                  decoration: const InputDecoration(hintText: 'Group Name'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
