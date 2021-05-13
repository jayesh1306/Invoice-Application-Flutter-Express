import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/models/Invoice.dart';

// Dio
import 'package:dio/dio.dart';

Dio dio = Dio();
String baseUrl = 'https://flutter-testing.herokuapp.com/app';
// String baseUrl = 'http://192.168.0.112:3000/app';

class InvoiceModel extends Model {
  List<Invoice> invoices = [];
  bool isLoading = false;

  double totalBillAmount = 0;

  void getAllInvoices(String id) async {
    isLoading = true;
    notifyListeners();
    Response response = await dio.get('$baseUrl/details/$id');
    if (response.statusCode == 200) {
      List<Invoice> _invoices = [];
      List<dynamic> fetchedInvoices = response.data;
      for (var invoice in fetchedInvoices) {
        _invoices.add(Invoice.fromJson(invoice));
      }
      invoices = _invoices;
      notifyListeners();
      // isLoading = false;
      notifyListeners();
      calculateTotal();
    }
  }

  Future<bool> removeInvoice(int index, String id, String userId) async {
    Response response = await dio.get('$baseUrl/details/$userId/$id/delete');
    if (response.statusCode == 200) {
      invoices.removeAt(index);
      notifyListeners();
      calculateTotal();
      return true;
    }
    return false;
  }

  addInvoice(String name, String rate, String quantity, String date,
      String imageUrl, String userId) async {
    Response response = await dio.post('$baseUrl/create/$userId', data: {
      "products": name,
      "rate": rate,
      "quantity": quantity,
      "invoiceDate": date,
      "imageUrl": imageUrl
    });
    if (response.statusCode == 200) {
      invoices.add(Invoice.fromJson(response.data));
      notifyListeners();
    }
    calculateTotal();
  }

  Future<bool> downloadInvoice(
      String fromDate, String toDate, String userId, String creator) async {
    isLoading = true;
    notifyListeners();
    Response response;
    try {
      response = await dio.post('$baseUrl/details/$userId/getPDF',
          data: {"fromDate": fromDate, "toDate": toDate, "creator": creator});
    } catch (e) {
      if (e is DioError) {
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
    if (response.statusCode == 200) {
      isLoading = false;
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      isLoading = false;
      notifyListeners();
      return false;
    } else {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void calculateTotal() {
    totalBillAmount = 0;
    notifyListeners();
    for (var i = 0; i < invoices.length; i++) {
      totalBillAmount =
          totalBillAmount + (invoices[i].rate * invoices[i].quantity);
    }
    isLoading = false;
    notifyListeners();
  }
}
