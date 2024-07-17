import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/components/bottom_nav.dart';
import 'package:my_app/models/groups_model.dart';
import 'package:my_app/presentation/expenses/add_expenses.dart';
import 'package:my_app/presentation/expenses/expenses_bloc.dart';
import 'package:my_app/utils/calculate_amount.dart';
import 'package:my_app/widgets/my_background_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesScreen extends StatelessWidget {
  final GroupsModel groupsModel;
  String selectedContactName = '';

  ExpensesScreen({super.key, required this.groupsModel});

  Future<String?> fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('myName');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpensesBloc(groupname: groupsModel.groupname)
        ..add(OnInitialLoadExpense()),
      child: PopScope(
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
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Expenses',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                backgroundColor: const Color(0xff000080),
                foregroundColor: Colors.black,
                child: const Icon(Icons.add),
                onPressed: () {
                  final expensesBloc = BlocProvider.of<ExpensesBloc>(context);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: expensesBloc,
                        child: AddExpenses(
                          selectedcontactname: groupsModel.names.first,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          body: MyBackgroundColor(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: groupsModel.imagepath.isNotEmpty
                          ? FileImage(File(groupsModel.imagepath))
                          : null,
                      radius: 30,
                      child: groupsModel.imagepath.isEmpty
                          ? const Icon(Icons.group)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      groupsModel.groupname,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    FutureBuilder(
                      future: fetchUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final name = snapshot.data ?? 'No Name';
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 5),
                    Text(
                      groupsModel.names.first,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'are added in this group',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                FutureBuilder(
                  future: fetchUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error : ${snapshot.error}');
                    } else {
                      final myName = snapshot.data ?? 'No Name';
                      return BlocBuilder<ExpensesBloc, ExpensesState>(
                        builder: (context, state) {
                          if (state is InitialAddExpenseState) {
                            if (state.transactions.isEmpty) {
                              return const Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'No Expenses yet!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      'Add an expense to start the party!!!',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              );
                            }

                            final totalOwedMoney =
                                CalculateAmount.calculateTotalOwed(myName,
                                    selectedContactName, state.transactions);
                            Widget balanceTextWidget;
                            Color balanceColor;
                            if (totalOwedMoney == 0) {
                              balanceTextWidget =
                                  const Text('All Settled Up!!');
                              balanceColor = Colors.black;
                            } else if (totalOwedMoney > 0) {
                              balanceTextWidget = RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'You owe ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '\u20B9$totalOwedMoney ',
                                      style:
                                          const TextStyle(color: Colors.orange),
                                    ),
                                    TextSpan(
                                      text: 'to ${groupsModel.names.first}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                              // 'You owe \u20B9$totalOwedMoney to ${groupsModel.names.first}';
                              // balanceColor = Colors.orange;
                            } else {
                              balanceTextWidget = RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${groupsModel.names.first} owes you',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '\u20B9${-totalOwedMoney}',
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              );
                              // '${groupsModel.names.first} owes you \u20B9${-totalOwedMoney}';
                              // balanceColor = Colors.green;
                            }
                            return Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: balanceTextWidget,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.transactions.length,
                                      itemBuilder: (context, index) {
                                        final transaction =
                                            state.transactions[index];
                                        final owingAmount =
                                            transaction.amount / 2;
                                        final owingText = transaction
                                                    .payername ==
                                                myName
                                            ? 'You paid \u20B9${transaction.amount}'
                                            : '${groupsModel.names.first} paid \u20B9${transaction.amount}';

                                        return ListTile(
                                          leading: const Icon(Icons.list_alt),
                                          title: Text(transaction.description),
                                          subtitle: Text(owingText),
                                          trailing: Text(
                                            transaction.payername == myName
                                                ? 'you lent \u20B9$owingAmount'
                                                : 'you borrowed \u20B9$owingAmount',
                                            style: TextStyle(
                                                color: transaction.payername ==
                                                        myName
                                                    ? Colors.green
                                                    : Colors.orange),
                                          ),
                                          onLongPress: () {},
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
