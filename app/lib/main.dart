import 'package:flutter/material.dart';
import 'package:testing/OptionMenu.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:testing/screens/InvoicePage/scoped_models/Invoice_Scoped_Model.dart';
import 'package:testing/screens/InvoicePage/scoped_models/User_Scoped_Model.dart';
import 'package:testing/screens/TransactionPage/scoped_model/Transaction_Scoped_Model.dart';

TransactionModel transactionModel = new TransactionModel();
UserModel userModel = new UserModel();

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    userModel.getAllUsers();
    transactionModel.getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD APP',
      home: new SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new OptionMenu(),
          title: new Text(
            'Welcome to Rameshwar Enterprise',
            style: TextStyle(fontSize: 20),
          ),
          image: new Image.asset('assets/appLoader.gif'),
          backgroundColor: Colors.white,
          photoSize: 200,
          useLoader: false),
    );
  }
}
