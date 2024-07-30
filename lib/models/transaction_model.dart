class Transactions {
  final String? id;
  final String description;
  final double amount;
  final String payername;

  Transactions({
    this.id,
    required this.description,
    required this.amount,
    required this.payername,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
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
