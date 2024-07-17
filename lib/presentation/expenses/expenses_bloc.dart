import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_app/models/transaction_model.dart';

// Events
abstract class ExpensesEvent {}

class OnInitialLoadExpense extends ExpensesEvent {}

class OnAddExpense extends ExpensesEvent {
  final String description;
  final double amount;
  final String paidby;

  OnAddExpense({
    required this.description,
    required this.amount,
    required this.paidby,
  });
}

// States
abstract class ExpensesState {}

class InitialAddExpenseState extends ExpensesState {
  final List<Transaction> transactions;

  InitialAddExpenseState({required this.transactions});

  factory InitialAddExpenseState.fromJson(Map<String, dynamic> json) {
    return InitialAddExpenseState(
      transactions: (json['transactions'] as List)
          .map((transaction) =>
              Transaction.fromJson(transaction as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }
}

class InitialLoadingState extends ExpensesState {}

// Bloc
class ExpensesBloc extends HydratedBloc<ExpensesEvent, ExpensesState> {
  final String groupname;
  ExpensesBloc({required this.groupname}) : super(InitialLoadingState()) {
    on<OnInitialLoadExpense>((event, emit) {
      final storedData = HydratedBloc.storage.read('ExpensesBloc_$groupname');
      print('Group name: $groupname');
      print('Stored data: $storedData');
      print('Stored data type: ${storedData.runtimeType}');

      if (storedData != null) {
        try {
          final storedMap = _convertToStringKeyedMap(storedData);
          final storedExpenseList = fromJson(storedMap);
          print('Stored expense list: $storedExpenseList');

          if (storedExpenseList != null) {
            emit(storedExpenseList);
          } else {
            emit(InitialAddExpenseState(transactions: []));
          }
        } catch (e) {
          print('Error in casting stored data: $e');
          emit(InitialAddExpenseState(transactions: []));
        }
      } else {
        emit(InitialAddExpenseState(transactions: []));
      }
    });

    on<OnAddExpense>((event, emit) {
      final currentState = state as InitialAddExpenseState;
      final transactions = currentState.transactions;
      final newTransaction = Transaction(
        description: event.description,
        amount: event.amount,
        payername: event.paidby,
      );

      final updatedTransactions = [newTransaction, ...transactions];
      emit(InitialAddExpenseState(transactions: updatedTransactions));
      persistState(InitialAddExpenseState(transactions: updatedTransactions));
    });
  }

  dynamic _convertToStringKeyedMap(dynamic data) {
    if (data is Map) {
      return data.map((key, value) {
        final newKey =
            key.toString(); // Convert key to string if it's not already
        final newValue = _convertToStringKeyedMap(
            value); // Recursively handle nested maps/lists
        return MapEntry(newKey, newValue);
      });
    } else if (data is List) {
      return data.map((item) => _convertToStringKeyedMap(item)).toList();
    }
    return data;
  }

  @override
  ExpensesState? fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('transactions')) {
        return InitialAddExpenseState.fromJson(json);
      }
    } catch (e) {
      print('Error in deserializing Json: $e');
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(ExpensesState state) {
    if (state is InitialAddExpenseState) {
      return state.toJson();
    }
    return null;
  }

  @override
  Future<void> persistState(ExpensesState state) async {
    final stateJson = toJson(state);
    if (stateJson != null) {
      await HydratedBloc.storage.write('ExpensesBloc_$groupname', stateJson);
    }
  }
}
