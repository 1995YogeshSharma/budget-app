class Transaction {
  String date;
  String type;
  int amount;

  Transaction({required this.date, required this.type, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        date: json['date'],
        type: json['type'],
        amount: int.parse(json['amount']));
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'amount': amount.toString(),
    };
  }
}
