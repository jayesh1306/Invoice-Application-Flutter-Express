class BricksSupply {
  String id;
  String from;
  String to;
  String item;
  String truckNo;
  String date;
  String quantity;

  BricksSupply(this.id, this.from, this.to, this.date, this.item, this.truckNo,
      this.quantity);

  BricksSupply.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    id = json['_id'];
    date = json['date'];
    item = json['item'];
    truckNo = json['truckNo'];
    quantity = json['quantity'];
  }
}
