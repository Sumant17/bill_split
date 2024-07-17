import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_app/components/intro.dart';
import 'package:my_app/presentation/friends/friends_bloc.dart';
import 'package:my_app/presentation/home/home_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  // print('Storage directory : ${directory.path}');
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: directory,
  );

  // final storageContentofgroups = await HydratedBloc.storage.read('GroupBloc');
  // print('Storage content of Groups: $storageContentofgroups');

  // final storageContentofContactname =
  //     await HydratedBloc.storage.read('ContactBloc');
  // print('Storage content of Contact Name : $storageContentofContactname');

  // final storageContentofExpense =
  //     await HydratedBloc.storage.read('ExpensesBloc');
  // print('Storage content of Expense list : $storageContentofExpense');

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => AuthBloc()
        //     ..add(
        //       OnInitialAuth(),
        //     ),
        // ),
        // BlocProvider<SignupBloc>(
        //   create: (context) => SignupBloc(),
        // ),
        BlocProvider(
          create: (context) => FriendsBloc()
            ..add(
              OnInitialLoadFriends(),
            ),
        ),
        BlocProvider(
          create: (context) => GroupBloc()
            ..add(
              InitialLoadGroup(),
            ),
        ),
        // BlocProvider<CreateGroupBloc>(
        //   create: (context) => CreateGroupBloc(),
        // ),
        // BlocProvider(
        //   create: (context) => ContactBloc()
        //     ..add(
        //       InitialLoadContacts(),
        //     ),
        // ),
        // BlocProvider(
        //   create: (context) => ExpensesBloc()
        //     ..add(
        //       OnInitialLoadExpense(),
        //     ),
        // ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Introduction(),
      ),
    );
  }
}
