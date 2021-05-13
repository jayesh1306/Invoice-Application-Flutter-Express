class User {
  String name;
  String id;
  String contact;
  String address;

  User(this.id, this.name, this.contact, this.address);

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    contact = json['contact'];
    address = json['address'];
  }
}
