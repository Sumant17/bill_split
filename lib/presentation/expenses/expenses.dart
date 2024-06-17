import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/presentation/contacts/access_contacts_bloc.dart';
import 'package:my_app/presentation/expenses/add_expenses.dart';
import 'package:my_app/presentation/expenses/expenses_bloc.dart';
import 'package:my_app/presentation/groups/create_group_bloc.dart';
import 'package:my_app/utils/calculate_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesScreen extends StatelessWidget {
  late ExpensesBloc expensesBloc;
  String myName = '';
  String selectedContactName = '';
  ExpensesScreen({super.key});

  Future<String?> fetchusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('myName');
  }

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
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddExpenses()));
          },
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            BlocBuilder<CreateGroupBloc, CreateGroupState>(
              builder: (context, state) {
                if (state is CreateGroupSuccessState) {
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: state.imagepath.isNotEmpty
                            ? FileImage(File(state.imagepath))
                            : null,
                        radius: 30,
                        child: state.imagepath.isEmpty
                            ? const Icon(Icons.camera_alt_sharp)
                            : null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(state.name),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                FutureBuilder(
                  future: fetchusername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final name = snapshot.data ?? 'No Name';
                      myName = name;
                      return Text(name);
                    }
                  },
                ),
                // BlocBuilder<SignupBloc, SignUpState>(
                //   builder: (context, state) {
                //     if (state is SignUpSuccess) {
                //       myName = state.name;
                //       return Text(state.name);
                //     } else {
                //       return const CircularProgressIndicator();
                //     }
                //   },
                // ),
                const SizedBox(
                  width: 10,
                ),
                BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) {
                    if (state is ContactSelectSuccess) {
                      selectedContactName = state.selectedcontactname;
                      return Text(state.selectedcontactname);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text('are added in this group'),
              ],
            ),
            const SizedBox(
              height: 50,
            ),

            BlocBuilder<ExpensesBloc, ExpensesState>(
              builder: (context, state) {
                expensesBloc = BlocProvider.of<ExpensesBloc>(context);
                if (state is InitialAddExpenseState) {
                  if (state.transactions.isEmpty) {
                    return const Column(
                      children: [
                        Center(
                          child: const Text('No Expenses yet!'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: const Text(
                              'Add an expense to start the party!!!'),
                        )
                      ],
                    );
                  }

                  final totalowedmoney = CalculateAmount.calculateTotalOwed(
                      myName, selectedContactName, state.transactions);
                  String balancetext;
                  if (totalowedmoney == 0) {
                    balancetext = 'All Settled Up!!';
                  } else if (totalowedmoney > 0) {
                    balancetext =
                        'You owe $totalowedmoney to $selectedContactName';
                  } else {
                    balancetext =
                        '$selectedContactName owes you ${-totalowedmoney}';
                  }
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(balancetext),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = state.transactions[index];
                              final owingamount = transaction.amount / 2;
                              final owingtext = transaction.payername == myName
                                  ? 'You paid ${transaction.amount}'
                                  : '${transaction.payername} paid ${transaction.amount}';

                              return ListTile(
                                leading: Icon(Icons.list_alt),
                                title: Text(transaction.description),
                                subtitle: Text(owingtext),
                                trailing: Text(transaction.payername == myName
                                    ? 'you lent $owingamount'
                                    : 'you borrowed $owingamount'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            // Center(
            //   child: Text('No expenses here yet.'),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Center(
            //   child: Text('Add an expesne to get thid party started.'),
            // )
          ],
        ),
      ),
    );
  }
}
