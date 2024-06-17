import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/contacts/access_contacts_bloc.dart';
import 'package:my_app/presentation/expenses/expenses_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenses extends StatefulWidget {
  AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  String paidby = '';

  Future<String?> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('myName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          TextButton(
            onPressed: () {
              final description = descriptionController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final payer = paidby;
              if (description.isNotEmpty &&
                  amount != null &&
                  amount > 0 &&
                  payer != null) {
                final expensesBloc = context.read<ExpensesBloc>();
                expensesBloc.add(OnAddExpense(
                    description: description, amount: amount, paidby: payer));
                Navigator.pop(context);
              } else {
                throw Exception('Amount cannot be empty');
              }
            },
            child: const Icon(Icons.done),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Enter a Description'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Amount'),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder(
                future: fetchUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final name = snapshot.data ?? 'No Name';
                    return Row(
                      children: [
                        Radio<String>(
                          value: name,
                          groupValue: paidby,
                          onChanged: (value) {
                            setState(() {
                              paidby = value!;
                            });
                          },
                        ),
                        Text('Paid by $name \n and split equally'),
                      ],
                    );
                  }
                },
              ),
              // BlocBuilder<SignupBloc, SignUpState>(
              //   builder: (context, state) {
              //     if (state is SignUpSuccess) {
              //       return Row(
              //         children: [
              //           Radio<String>(
              //             value: state.name,
              //             groupValue: paidby,
              //             onChanged: (value) {
              //               setState(() {
              //                 paidby = value!;
              //               });
              //             },
              //           ),
              //           Text('Paid by ${state.name} \n and split equally'),
              //         ],
              //       );
              //     } else {
              //       return const CircularProgressIndicator();
              //     }
              //   },
              // ),
              // BlocBuilder<SignupBloc, SignUpState>(
              //   builder: (context, state) {
              //     if (state is SignUpSuccess) {
              //       return Text('Paid by ${state.name} and split equally');
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
                    return Row(
                      children: [
                        Radio<String>(
                          value: state.selectedcontactname,
                          groupValue: paidby,
                          onChanged: (value) {
                            setState(() {
                              paidby = value!;
                            });
                          },
                        ),
                        Text(
                            'Paid by ${state.selectedcontactname} \n and split equally'),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              // BlocBuilder<ContactBloc, ContactState>(
              //   builder: (context, state) {
              //     if (state is ContactSelectSuccess) {
              //       return Text(
              //           'Paid by ${state.selectedcontactname} and split equally');
              //     } else {
              //       return const CircularProgressIndicator();
              //     }
              //   },
              // ),
            ],
          )
        ],
      ),
    );
  }
}
