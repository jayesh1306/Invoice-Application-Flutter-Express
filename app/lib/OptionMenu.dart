import 'package:flutter/material.dart';
import 'package:testing/screens/InvoicePage/InvoicePage.dart';
import 'package:testing/screens/TransactionPage/mainPage.dart';

class OptionMenu extends StatefulWidget {
  @override
  _OptionMenuState createState() => _OptionMenuState();
}

class _OptionMenuState extends State<OptionMenu> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      height: screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.values[5],
        children: [
          Container(
            // height: screenHeight * 0.4,
            child: Image.asset(
              'assets/om.png',
              scale: 5,
            ),
          ),
          Container(
            // padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (contaxt) => InvoicePage()));
                  },
                  child: Container(
                    width: screenWidth * 0.7,
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      trailing: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Invoice Application',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (contaxt) => TransactionHomePage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: screenWidth * 0.7,
                    child: ListTile(
                      trailing: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Transactions',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
