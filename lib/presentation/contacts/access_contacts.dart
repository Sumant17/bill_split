import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/contacts/access_contacts_bloc.dart';
import 'package:my_app/presentation/expenses/expenses.dart';
import 'package:my_app/presentation/friends/friends_bloc.dart';
import 'package:my_app/presentation/home/home_bloc.dart';

class AccessContacts extends StatelessWidget {
  late ContactBloc accesscontactsbloc;
  AccessContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ContactBloc, ContactState>(
        listener: (context, state) {
          if (state is ContactSelectSuccess) {
            //updat the created group with member added.
            BlocProvider.of<GroupBloc>(context)
                .add(UpdateGroupList(friend: state.selectedcontactname));
            //to show it friends tab.
            BlocProvider.of<FriendsBloc>(context)
                .add(OnAddFriends(friend: state.selectedcontactname));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ExpensesScreen()),
              );
            });
          }
        },
        builder: (context, state) {
          if (state is ContactsLoadSuccess) {
            accesscontactsbloc = BlocProvider.of<ContactBloc>(context);
            final contacts = state.contacts;
            return ListView.builder(
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
                    accesscontactsbloc.add(OnSelectContact(contact: contact));
                  },
                );
              },
            );
          } else if (state is ContactSelected) {
            accesscontactsbloc = BlocProvider.of<ContactBloc>(context);
            final selectedcontactname = state.contact.displayName;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: TextEditingController(text: selectedcontactname),
                  readOnly: true,
                ),
                FloatingActionButton(
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
              ],
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
    );
  }
}
