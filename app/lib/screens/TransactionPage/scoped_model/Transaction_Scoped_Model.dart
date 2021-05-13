import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/TransactionPage/models/Transaction.dart';
import 'package:dio/dio.dart';

Dio dio = new Dio();

String baseUrl = 'https://transaction-application.herokuapp.com/api';
// String baseUrl = 'http://192.168.0.112:3000/api';

class TransactionModel extends Model {
  List<Transaction> transactions;
  bool isLoading = false;
  double totalAmount = 0;

  Future<bool> getAllTransactions() async {
    this.isLoading = true;
    notifyListeners();
    List<Transaction> fetchedLists = [];

    Response response = await dio.get('$baseUrl/allTransactions');

    if (response.statusCode == 200) {
      // return true;
      for (var transaction in response.data) {
        fetchedLists.add(Transaction.fromJson(transaction));
      }
      transactions = fetchedLists;
      this.isLoading = false;
      notifyListeners();
      calculateTotal();
    } else {
      this.isLoading = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  void deleteAllTransactions() async {
    this.isLoading = true;
    notifyListeners();

    Response response = await dio.get('$baseUrl/deleteAllTransactions');

    if (response.statusCode == 200) {
      transactions = [];
      this.isLoading = false;
      notifyListeners();
      calculateTotal();
    }
    this.isLoading = false;
    notifyListeners();
  }

  void deleteOne(String id) async {
    this.isLoading = true;
    notifyListeners();

    Response response = await dio.get('$baseUrl/delete/$id');

    if (response.statusCode == 200) {
      transactions.removeWhere((element) => element.id == id);
      this.isLoading = false;
      notifyListeners();
      calculateTotal();
    }
    this.isLoading = false;
    notifyListeners();
  }

  void addTransaction(String name, String reason, String amount, String type,
      String date) async {
    Response response = await dio.post('$baseUrl/addTransaction', data: {
      "name": name,
      "reason": reason,
      "amount": amount,
      "type": type,
      "date": date
    });
    print(response.data);
    if (response.statusCode == 200) {
      transactions.add(Transaction.fromJson(response.data));
    }
    notifyListeners();
    calculateTotal();
  }

  void calculateTotal() {
    totalAmount = 0;
    notifyListeners();
    for (var i = 0; i < transactions.length; i++) {
      totalAmount = totalAmount + transactions[i].amount;
    }
    isLoading = false;
    notifyListeners();
  }
}
