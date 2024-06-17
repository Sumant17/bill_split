import 'package:my_app/models/transaction_model.dart';

class CalculateAmount {
  static double calculateTotalOwed(
      String username, String secondperson, List<Transaction> transactions) {
    double totalowedamount = 0;
    for (var transaction in transactions) {
      final halfamount = transaction.amount / 2;
      if (transaction.payername == username) {
        totalowedamount -= halfamount;
      } else {
        totalowedamount += halfamount;
      }
    }
    return totalowedamount;
  }
}
