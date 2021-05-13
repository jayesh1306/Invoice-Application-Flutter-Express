import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/TransactionPage/scoped_model/BricksSupply_Scoped_Model.dart';
import 'package:testing/screens/TransactionPage/models/BricksSupply.dart';
import 'package:testing/screens/TransactionPage/screens/addProduct.dart';

class BricksSupplyPage extends StatefulWidget {
  @override
  BricksSupplyPageState createState() => BricksSupplyPageState();
}

BricksSupplyModel model = BricksSupplyModel();

class BricksSupplyPageState extends State<BricksSupplyPage> {
  List<BricksSupply> _searchList = [];

  void initState() {
    super.initState();
    model.getAllProducts();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _searchList = model.bricksSupply;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('BricksSupply'),
        actions: [
          Container(
            child: ElevatedButton.icon(
                onPressed: () {
                  model.deleteAllProducts();
                  setState(() {
                    _searchList = [];
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[400],
                ),
                label: Text(
                  'Delete All',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddProduct(
                        model: model,
                      )));
        },
        label: Text('Add Product'),
        icon: Icon(Icons.add),
      ),
      body: ScopedModel<BricksSupplyModel>(
        model: model,
        child: ScopedModelDescendant<BricksSupplyModel>(
          builder: (context, child, model) {
            return Container(
              height: height * 1,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(hintText: 'Search'),
                        onChanged: (value) {
                          setState(() {
                            _searchList = model.bricksSupply
                                .where((element) =>
                                    element.from
                                        .toLowerCase()
                                        .contains(value) ||
                                    element.to.toLowerCase().contains(value))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: model.isLoading
                        ? Container(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _searchList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: () {
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
                                                          'Are you sure want to delete the Invoice ?',
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
                                                              onPressed:
                                                                  () async {
                                                                model.deleteOne(
                                                                    _searchList[
                                                                            index]
                                                                        .id);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'Yes',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              )),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              return false;
                                                            },
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          )
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
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${_searchList[index].to}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Product : ${_searchList[index].item}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Date : ${_searchList[index].date}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'From : ${_searchList[index].from}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'Quantity : ${_searchList[index].quantity}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showSnackBar(bool bool) {}
}
