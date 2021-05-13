class Invoice {
  String id;
  String product;
  double rate;
  double quantity;
  String challan;
  String date;

  Invoice(
      this.id, this.product, this.rate, this.quantity, this.challan, this.date);

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    product = json['products'];
    rate = json['rate'].toDouble();
    quantity = json['quantity'].toDouble();
    challan = json['challan'];
    date = json['date'].toString();
  }
}
