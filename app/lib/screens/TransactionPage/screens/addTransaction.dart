import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/TransactionPage/scoped_model/Transaction_Scoped_Model.dart';

class AddTransaction extends StatefulWidget {
  final TransactionModel model;

  const AddTransaction({Key key, this.model}) : super(key: key);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String dropdownValue = 'Cash In';
  TextEditingController nameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String transactionDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScopedModel<TransactionModel>(
            model: widget.model,
            child: ScopedModelDescendant<TransactionModel>(
              builder: (context, child, model) {
                return SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Name'),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: reasonController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Reason'),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Amount'),
                        ),
                        ListTile(
                          trailing: transactionDate != null
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
                                                        padding:
                                                            EdgeInsets.all(20),
                                                        child: Text(
                                                          'Are you sure want to delete the image ?',
                                                          style: TextStyle(
                                                              fontSize: 23,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                transactionDate =
                                                                    null;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
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
                                                                    color: Colors
                                                                        .red),
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
                                  transactionDate = date;
                                });
                              }
                            }).catchError((onError) => {});
                          },
                          title: transactionDate == null
                              ? Text(
                                  'Select from Date',
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text(
                                  '$transactionDate',
                                  style: TextStyle(fontSize: 20),
                                ),
                        ),
                        ListTile(
                          leading: DropdownButton(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            // elevation: 1,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.blueAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['Cash In', 'Cash Out']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // margin: EdgeInsets.only(left: 15),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.blue[400],
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blue[700]),
                              )),
                            ),
                            onPressed: () {
                              if (nameController.text != null &&
                                  reasonController.text != null &&
                                  amountController.text != null &&
                                  dropdownValue != null &&
                                  transactionDate != null) {
                                model.addTransaction(
                                    nameController.text,
                                    reasonController.text,
                                    amountController.text,
                                    dropdownValue,
                                    transactionDate);
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('All Fields re required'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Add',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
