class Transaction {
  final String? id;
  final String description;
  final double amount;
  final String payername;

  Transaction({
    this.id,
    required this.description,
    required this.amount,
    required this.payername,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      description: json['description'],
      amount: json['amount'],
      payername: json['payername'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "amount": amount,
      "payername": payername,
    };
  }
}
