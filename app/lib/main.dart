import 'package:flutter/material.dart';
import 'package:testing/OptionMenu.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
