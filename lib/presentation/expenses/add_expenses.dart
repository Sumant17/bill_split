import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/presentation/expenses/expenses_bloc.dart';
import 'package:my_app/utils/custom_flash_message.dart';
import 'package:my_app/widgets/my_background_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExpenses extends StatefulWidget {
  final String selectedcontactname;
  AddExpenses({super.key, required this.selectedcontactname});

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
    final friendname = widget.selectedcontactname;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Add Expense',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final description = descriptionController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final payer = paidby;
              if (description.isEmpty ||
                  amount == null ||
                  amount <= 0 ||
                  payer.isEmpty) {
                CustomFlashMessage.showErrorToast(context,
                    'You must enter the description ,\n amount and payer!');
              } else {
                final expensesBloc =
                    BlocProvider.of<ExpensesBloc>(context, listen: false);
                expensesBloc.add(
                  OnAddExpense(
                    description: description,
                    amount: amount,
                    paidby: payer,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.done,
              color: Color(0xff000080),
            ),
          ),
        ],
      ),
      body: MyBackgroundColor(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Enter a Description',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                  prefixIcon: Icon(Icons.currency_rupee_sharp),
                ),
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

                  Row(
                    children: [
                      Radio<String>(
                        value: friendname,
                        groupValue: paidby,
                        onChanged: (value) {
                          setState(() {
                            paidby = value!;
                          });
                        },
                      ),
                      Text('Paid by $friendname \n and split equally'),
                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
