import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/TransactionPage/scoped_model/BricksSupply_Scoped_Model.dart';

class AddProduct extends StatefulWidget {
  final BricksSupplyModel model;

  const AddProduct({Key key, this.model}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController truckNoController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  String productDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScopedModel<BricksSupplyModel>(
            model: widget.model,
            child: ScopedModelDescendant<BricksSupplyModel>(
              builder: (context, child, model) {
                return SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: fromController,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'From (Default : R.J.K)'),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: toController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'To'),
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: itemController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Item'),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          controller: truckNoController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Truck Number'),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          controller: quantityController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Quantity'),
                        ),
                        ListTile(
                          trailing: productDate != null
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
                                                                productDate =
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
                                  productDate = date;
                                });
                              }
                            }).catchError((onError) => {});
                          },
                          title: productDate == null
                              ? Text(
                                  'Select from Date',
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text(
                                  '$productDate',
                                  style: TextStyle(fontSize: 20),
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
                              if (toController.text != null &&
                                  itemController.text != null &&
                                  truckNoController.text != null &&
                                  productDate != null &&
                                  quantityController.text != null) {
                                model.addProduct(
                                    fromController.text,
                                    toController.text,
                                    itemController.text,
                                    truckNoController.text,
                                    productDate,
                                    quantityController.text);
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
