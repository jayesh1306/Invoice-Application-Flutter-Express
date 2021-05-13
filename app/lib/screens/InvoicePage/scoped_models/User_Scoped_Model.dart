import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/models/User.dart';
import 'package:dio/dio.dart';

Dio dio = Dio();
String baseUrl = 'https://flutter-testing.herokuapp.com/app';
// String baseUrl = 'http://192.168.0.112:3000/app';

class UserModel extends Model {
  List<User> users = [];

  bool isLoading = false;

  Future<bool> getAllUsers() async {
    isLoading = true;
    notifyListeners();
    Response response = await dio.get('$baseUrl/details');
    List<User> _users = [];
    List<dynamic> fetchedUsers = response.data;

    for (var fetchedData in fetchedUsers) {
      _users.add(User.fromJson(fetchedData));
    }

    users = _users;
    notifyListeners();
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> sendSms(String id) async {
    Response response = await dio.get('$baseUrl/sendSms/$id');
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  void addUser(
      String name, String contact, String address, String email) async {
    isLoading = true;
    notifyListeners();
    Response response = await dio.post('$baseUrl/addCustomer', data: {
      "name": name,
      "email": email,
      "contact": contact,
      "address": address
    });

    users.add(User.fromJson(response.data));
    notifyListeners();
    isLoading = false;
    notifyListeners();
  }

  Future<bool> removeUser(int index, String id) async {
    isLoading = true;
    notifyListeners();
    Response response = await dio.get('$baseUrl/details/delete/customer/$id');
    if (response.statusCode == 200) {
      users.removeAt(index);
      notifyListeners();
      isLoading = false;
      notifyListeners();
      return true;
    }
    isLoading = false;
    notifyListeners();
    return false;
  }
}
