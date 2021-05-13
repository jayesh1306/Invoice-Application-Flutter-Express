class Transaction {
  String name;
  String id;
  String date;
  String reason;
  double amount;
  String type;

  Transaction(
      this.id, this.amount, this.date, this.name, this.reason, this.type);

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    date = json['date'];
    reason = json['reason'];
    amount = json['amount'].toDouble();
    type = json['type'];
  }
}
