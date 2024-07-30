import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/presentation/contacts/access_contacts_bloc.dart';
import 'package:my_app/presentation/expenses/expenses.dart';
import 'package:my_app/presentation/expenses/expenses_bloc.dart';
import 'package:my_app/presentation/friends/friends_bloc.dart';
import 'package:my_app/presentation/home/home_bloc.dart';
import 'package:my_app/utils/custom_flash_message.dart';
import 'package:my_app/widgets/my_background_color.dart';

class AccessContacts extends StatelessWidget {
  late ContactBloc accesscontactsbloc;
  final String groupimagepath;
  final String groupname;
  AccessContacts(
      {super.key, required this.groupimagepath, required this.groupname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => ContactBloc(groupname: groupname)
          ..add(
            InitialLoadContacts(),
          ),
        child: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ContactSelectSuccess) {
              //update the created group with member added.
              BlocProvider.of<GroupBloc>(context).add(UpdateGroupList(
                  friend: state.selectedcontactname, groupname: groupname));

              //to show it in friends tab.
              BlocProvider.of<FriendsBloc>(context)
                  .add(OnAddFriends(friend: state.selectedcontactname));

              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ExpensesBloc(groupname: groupname)
                          ..add(OnInitialLoadExpense()),
                        child: ExpensesScreen(
                          groupsModel: GroupsModel(
                            groupname: groupname,
                            imagepath: groupimagepath,
                            names: [state.selectedcontactname],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
              CustomFlashMessage.showSuccessToast(
                  context, '1 member added to this group');
            }
          },
          builder: (context, state) {
            if (state is ContactsLoadSuccess) {
              accesscontactsbloc = BlocProvider.of<ContactBloc>(context);
              final contacts = state.contacts;
              return MyBackgroundColor(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final phonenumber = contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : 'No number exists';
                    final contactname = contact.displayName;
                    return ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(contactname),
                      subtitle: Text(phonenumber),
                      onTap: () {
                        accesscontactsbloc
                            .add(OnSelectContact(contact: contact));
                      },
                    );
                  },
                ),
              );
            } else if (state is ContactSelected) {
              accesscontactsbloc = BlocProvider.of<ContactBloc>(context);
              final selectedcontactname = state.contact.displayName;
              return MyBackgroundColor(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    TextField(
                      controller:
                          TextEditingController(text: selectedcontactname),
                      readOnly: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          backgroundColor: const Color(0xff000080),
                          foregroundColor: Colors.black,
                          onPressed: () {
                            accesscontactsbloc.add(
                              OnCheckButtonClicked(
                                  selectedcontactname: selectedcontactname),
                            );
                            // final createGroupBloc = context.read<CreateGroupBloc>();
                            // createGroupBloc.add(
                            //     UpdateGroup(thirdpartyperson: selectedcontactname));
                          },
                          child: const Icon(Icons.check),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        accesscontactsbloc.isLoading
                            ? CircularProgressIndicator()
                            : Container(),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     TextField(
            //       controller: TextEditingController(text: 'Hello'),
            //       readOnly: true,
            //     ),
            //   ],
            // );
          },
        ),
      ),
    );
  }
}
