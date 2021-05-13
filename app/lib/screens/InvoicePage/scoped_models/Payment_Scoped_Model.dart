import 'package:scoped_model/scoped_model.dart';

// Dio
import 'package:dio/dio.dart';
import 'package:testing/screens/InvoicePage/models/Payment.dart';

Dio dio = Dio();
String baseUrl = 'https://flutter-testing.herokuapp.com/app';
// String baseUrl = 'http://192.168.0.112:3000/app';

class PaymentModel extends Model {
  List<Payment> payments = [];
  bool isLoading = false;

  double totalPayments = 0;

  void getAllPayments(String id) async {
    isLoading = true;
    notifyListeners();
    Response response = await dio.get('$baseUrl/details/$id/payments');
    if (response.statusCode == 200) {
      List<Payment> _payments = [];
      List<dynamic> fetchedInvoices = response.data;
      for (var payment in fetchedInvoices) {
        _payments.add(Payment.fromJson(payment));
      }
      payments = _payments;
      notifyListeners();
      // isLoading = false;
      notifyListeners();
      calculateTotal();
    }
  }

  Future<bool> removePayment(int index, String id, String userId) async {
    Response response =
        await dio.get('$baseUrl/details/$userId/payments/delete/$id');
    if (response.statusCode == 200) {
      payments.removeAt(index);
      notifyListeners();
      calculateTotal();
      return true;
    }
    return false;
  }

  void addPayment(
      int amount, String date, String mode, String userId, bool send) async {
    Response response = await dio.post('$baseUrl/addPayment/$userId',
        data: {"amount": amount, "mode": mode, "date": date, "send": send});
    print(response.data);
    if (response.statusCode == 200) {
      payments.add(Payment.fromJson(response.data));
    }
    notifyListeners();
    calculateTotal();
  }

  void calculateTotal() {
    totalPayments = 0;
    notifyListeners();
    for (var i = 0; i < payments.length; i++) {
      totalPayments += payments[i].amount;
    }
    isLoading = false;
    notifyListeners();
  }
}
