import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/presentation/add_contact.dart';
import 'package:my_app/presentation/groups/create_group_bloc.dart';
import 'package:my_app/presentation/home/home_bloc.dart';
import 'package:my_app/utils/custom_flash_message.dart';
import 'package:my_app/widgets/my_background_color.dart';

class CreateGroup extends StatelessWidget {
  final TextEditingController groupname = TextEditingController();
  CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateGroupBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          // leading: const Icon(Icons.cancel),
          title: const Text(
            'Create a group',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          actions: [
            BlocBuilder<CreateGroupBloc, CreateGroupState>(
              builder: (context, state) {
                final createGroupBloc =
                    BlocProvider.of<CreateGroupBloc>(context);
                return TextButton(
                  onPressed: () {
                    createGroupBloc.add(
                      OnDoneButtonClicked(
                          name: groupname.text,
                          imagepath: createGroupBloc.imagepath),
                    );
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Color(0xff000080),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocListener<CreateGroupBloc, CreateGroupState>(
          listener: (context, state) {
            if (state is CreateGroupSuccessState) {
              // Triggering this create group event to display it in the home page
              BlocProvider.of<GroupBloc>(context).add(CreateGroupList(
                  groupname: state.name, groupimagepath: state.imagepath));
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddContact(
                        groupsModel: GroupsModel(
                            groupname: state.name,
                            imagepath: state.imagepath,
                            names: []),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ErrorState) {
              CustomFlashMessage.showErrorToast(context, state.errorMessage);
            }
          },
          child: MyBackgroundColor(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 200,
                    ),
                    BlocBuilder<CreateGroupBloc, CreateGroupState>(
                      builder: (context, state) {
                        final createGroupBloc =
                            BlocProvider.of<CreateGroupBloc>(context);
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
                                : const Icon(Icons.group),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: groupname,
                        decoration:
                            const InputDecoration(hintText: 'Group Name'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
