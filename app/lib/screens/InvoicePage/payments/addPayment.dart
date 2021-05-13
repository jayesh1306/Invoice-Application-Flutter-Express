import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/models/User.dart';
import 'package:testing/screens/InvoicePage/scoped_models/Payment_Scoped_Model.dart';

// ignore: must_be_immutable
class AddPayment extends StatefulWidget {
  final PaymentModel paymentModel;
  final User user;

  const AddPayment({Key key, this.paymentModel, this.user}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  bool isLoading = false;
  bool send = false;
  TextEditingController amountController = TextEditingController();

  TextEditingController dateController = TextEditingController();

  TextEditingController modeController = TextEditingController();

  TextEditingController chequeController = TextEditingController();

  String dropdownValue = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Add Payment',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          color: Colors.blue,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ScopedModel<PaymentModel>(
        model: widget.paymentModel,
        child: Container(
          padding: EdgeInsets.all(30),
          child: ScopedModelDescendant<PaymentModel>(
            builder: (context, child, model) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: amountController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        // focusedBorder: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        // disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, right: 15),
                        hintText: "Amount"),
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: dateController,
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, right: 15),
                        hintText: "Date (format : yyyy-mm-dd)"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Cash', 'Card', 'Cheque']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  dropdownValue == 'Cheque'
                      ? TextFormField(
                          cursorColor: Colors.black,
                          controller: chequeController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, right: 15),
                              hintText: "Cheque Number (Optional)"),
                        )
                      : Container(),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('Send Sms'),
                    onChanged: (_) {
                      setState(() {
                        send = !send;
                      });
                      print(send);
                    },
                    value: send,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: ElevatedButton(
                      onPressed: amountController.text == '' &&
                              dateController.text == '' &&
                              dropdownValue == ''
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill all the details'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
                          : () {
                              if (chequeController.text == '') {
                                model.addPayment(
                                    int.parse(amountController.text),
                                    dateController.text,
                                    dropdownValue,
                                    widget.user.id,
                                    send);
                              } else {
                                model.addPayment(
                                    int.parse(amountController.text),
                                    dateController.text,
                                    dropdownValue +
                                        ' - ' +
                                        chequeController.text,
                                    widget.user.id,
                                    send);
                              }
                              Navigator.pop(context);
                            },
                      child: isLoading
                          ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                // strokeWidth: 3,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Text(
                              'Add',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
