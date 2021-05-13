class Payment {
  String date;
  int amount;
  String mode;
  String id;

  Payment(this.amount, this.date, this.mode, this.id);

  Payment.fromJson(Map<String, dynamic> json) {
    date = json['date'].toString();
    amount = json['amount'];
    mode = json['mode'].toString();
    id = json['_id'];
  }
}
