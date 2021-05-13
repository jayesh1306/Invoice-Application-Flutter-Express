import 'package:scoped_model/scoped_model.dart';
import 'package:dio/dio.dart';
import 'package:testing/screens/TransactionPage/models/BricksSupply.dart';

String baseUrl = 'https://transaction-application.herokuapp.com/api';
// String baseUrl = 'http://192.168.0.112:3000/api';

Dio dio = new Dio();

class BricksSupplyModel extends Model {
  List<BricksSupply> bricksSupply = [];
  bool isLoading = false;

  void getAllProducts() async {
    isLoading = true;
    notifyListeners();
    List<BricksSupply> _fetchedData = [];

    Response response = await dio.get('$baseUrl/allProducts');
    if (response.statusCode == 200) {
      for (var item in response.data) {
        _fetchedData.add(BricksSupply.fromJson(item));
      }
      bricksSupply = _fetchedData;
      notifyListeners();
      isLoading = false;
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  void deleteOne(String id) async {
    this.isLoading = true;
    notifyListeners();

    Response response = await dio.get('$baseUrl/deleteProduct/$id');

    if (response.statusCode == 200) {
      bricksSupply.removeWhere((element) => element.id == id);
      this.isLoading = false;
      notifyListeners();
    }
    this.isLoading = false;
    notifyListeners();
  }

  void deleteAllProducts() async {
    this.isLoading = true;
    notifyListeners();

    Response response = await dio.get('$baseUrl/deleteAllProducts');

    if (response.statusCode == 200) {
      bricksSupply = [];
      this.isLoading = false;
      notifyListeners();
    }
    this.isLoading = false;
    notifyListeners();
  }

  void addProduct(String from, String to, String item, String truckNo,
      String date, String quantity) async {
    Response response = await dio.post('$baseUrl/addProduct', data: {
      "from": from,
      "to": to,
      "item": item,
      "truckNo": truckNo,
      "date": date,
      "quantity": quantity
    });
    print(response.data);
    if (response.statusCode == 200) {
      bricksSupply.add(BricksSupply.fromJson(response.data));
    }
    notifyListeners();
  }
}
