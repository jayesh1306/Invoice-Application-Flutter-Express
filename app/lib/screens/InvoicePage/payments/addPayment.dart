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

  // TextEditingController chequeController = TextEditingController();
  TextEditingController chequeBankController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();

  String dropdownValue = 'Cash';
  String invoiceDate;

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
                  ListTile(
                    trailing: invoiceDate != null
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              showDialog(
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                      ),
                                      elevation: 6,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Text(
                                                    'Are you sure want to delete the image ?',
                                                    style: TextStyle(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          invoiceDate = null;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                context: context,
                              );
                            },
                          )
                        : Text(''),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2018),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          String date = value.toString().split(' ')[0];
                          setState(() {
                            invoiceDate = date;
                          });
                          print(invoiceDate);
                        }
                      }).catchError((onError) => {});
                    },
                    title: invoiceDate == null
                        ? Text(
                            'Select from Date',
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            '$invoiceDate',
                            style: TextStyle(fontSize: 20),
                          ),
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
                      ? Column(
                          children: [
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: chequeBankController,
                              keyboardType: TextInputType.name,
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
                                  hintText: "Bank Name"),
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              controller: chequeNumberController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false),
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
                                  hintText: "Cheque Number"),
                            ),
                          ],
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
                              invoiceDate == '' &&
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
                              if (chequeBankController.text == '') {
                                model.addPayment(
                                    int.parse(amountController.text),
                                    invoiceDate,
                                    dropdownValue,
                                    widget.user.id,
                                    send);
                              } else {
                                model.addPayment(
                                    int.parse(amountController.text),
                                    invoiceDate,
                                    dropdownValue +
                                        ' - ' +
                                        chequeNumberController.text +
                                        ' - ' +
                                        chequeBankController.text,
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
