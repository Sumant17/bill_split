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
  ExpensesBloc() : super(InitialLoadingState()) {
    on<OnInitialLoadExpense>((event, emit) {
      final storedData = HydratedBloc.storage.read('ExpensesBloc');
      if (storedData != null && storedData is Map) {
        final storedexpenselist =
            fromJson(Map<String, dynamic>.from(storedData as Map));
        if (storedexpenselist != null) {
          emit(storedexpenselist);
        } else {
          emit(InitialAddExpenseState(transactions: []));
        }
      } else {
        emit(InitialAddExpenseState(transactions: []));
      }
    });

    on<OnAddExpense>((event, emit) {
      final currentstate = state as InitialAddExpenseState;
      final transactions = currentstate.transactions;
      final newTransaction = Transaction(
          description: event.description,
          amount: event.amount,
          payername: event.paidby);

      emit(InitialAddExpenseState(
          transactions: [newTransaction, ...transactions]));
    });
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
}
