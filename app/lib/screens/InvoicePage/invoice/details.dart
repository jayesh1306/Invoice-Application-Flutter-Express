import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/models/User.dart';
import 'package:testing/screens/InvoicePage/scoped_models/Invoice_Scoped_Model.dart';
import 'package:testing/screens/InvoicePage/scoped_models/User_Scoped_Model.dart';
import 'package:testing/screens/InvoicePage/invoice/addInvoice.dart';
import 'package:testing/screens/InvoicePage/invoice/allInvoices.dart';
import 'package:testing/screens/InvoicePage/invoice/download.dart';
import 'package:testing/screens/InvoicePage/invoice/invoiceDetail.dart';

class UserDetail extends StatefulWidget {
  final String name;
  final UserModel userModel;
  final User user;

  const UserDetail({Key key, this.name, this.userModel, this.user})
      : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

InvoiceModel _invoiceModel = InvoiceModel();

class _UserDetailState extends State<UserDetail> {
  bool showFab = true;

  ScrollController _visibleController;
  bool isVisible;

  @override
  void initState() {
    super.initState();
    isVisible = true;
    _visibleController = new ScrollController();
    _visibleController.addListener(() {
      if (_visibleController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true) {
          print("**** $isVisible up"); //Move IO away from setState
          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (_visibleController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds 
               */
            print("**** $isVisible down"); //Move IO away from setState
            setState(() {
              isVisible = true;
            });
          }
        }
      }
    });

    _invoiceModel.getAllInvoices(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton.extended(
          icon: Icon(
            Icons.picture_as_pdf,
          ),
          label: Text('Download PDF'),
          onPressed: () {
            print(widget.user.name);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DownloadInvoice(
                    userId: widget.user.id,
                    invoiceModel: _invoiceModel,
                    name: widget.user.name),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  // color: Colors.blue[300],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(
                    300,
                  ),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                  ),
                ),
              ),
              Container(
                child: Container(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        // padding: EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${widget.user.name}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddInvoice(
                                      invoiceModel: _invoiceModel,
                                      userId: widget.user.id,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.add),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AllInvoice(name: widget.user.name),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.file_copy_sharp,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 12, top: 10),
                child: ScopedModel<InvoiceModel>(
                  model: _invoiceModel,
                  child: ScopedModelDescendant<InvoiceModel>(
                    builder: (context, child, model) {
                      return Text(
                        'Total Invoices = ${_invoiceModel.invoices.length}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      );
                    },
                  ),
                ),
              ),
              ScopedModel<InvoiceModel>(
                  model: _invoiceModel,
                  child: ScopedModelDescendant<InvoiceModel>(
                    builder: (context, child, model) {
                      return Container(
                        margin: EdgeInsets.only(
                          left: 12,
                          top: 10,
                        ),
                        child: model.isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text('Loading...'),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '${_invoiceModel.totalBillAmount}/-',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ),
                      );
                    },
                  )),
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          ScopedModel<InvoiceModel>(
            model: _invoiceModel,
            child: ScopedModelDescendant<InvoiceModel>(
              rebuildOnChange: true,
              builder: (context, child, model) {
                showSnackBar(bool isTrue) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: isTrue ? Text('Deleted') : Text('Cannot Delete'),
                      duration: Duration(milliseconds: 500),
                      backgroundColor: isTrue ? Colors.green : Colors.red,
                    ),
                  );
                }

                return Container(
                  child: !model.isLoading
                      ? Expanded(
                          child: _invoiceModel.invoices.length != 0
                              ? ListView.builder(
                                  controller: _visibleController,
                                  itemCount: _invoiceModel.invoices.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      key:
                                          Key(_invoiceModel.invoices[index].id),
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          showDialog(
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60.0),
                                                  ),
                                                  elevation: 6,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        // height: MediaQuery.of(context)
                                                        //         .size
                                                        //         .height *
                                                        //     0.15,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              child: Text(
                                                                'Are you sure want to delete the Invoice ?',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        23,
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
                                                                      Navigator.pop(
                                                                          context);
                                                                      bool isDeleted = await _invoiceModel.removeInvoice(
                                                                          index,
                                                                          _invoiceModel
                                                                              .invoices[
                                                                                  index]
                                                                              .id,
                                                                          widget
                                                                              .user
                                                                              .id);
                                                                      if (isDeleted) {
                                                                        showSnackBar(
                                                                            true);

                                                                        return true;
                                                                      } else {
                                                                        showSnackBar(
                                                                            false);
                                                                        return false;
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      'Yes',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.green),
                                                                    )),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
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
                                        }
                                        return false;
                                      },
                                      background: Container(
                                        color: Colors.blue[600],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors.red,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Image.network(
                                            'https://pngimg.com/uploads/brick/brick_PNG3325.png'),
                                        trailing: Container(
                                          // padding: EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  '${_invoiceModel.invoices[index].rate}'),
                                              Text(
                                                  '${_invoiceModel.invoices[index].quantity}'),
                                              Text(
                                                  '${_invoiceModel.invoices[index].quantity * _invoiceModel.invoices[index].rate}')
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                            '${_invoiceModel.invoices[index].product}'),
                                        subtitle: Text(
                                            '${_invoiceModel.invoices[index].date.split('T')[0]}'),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => InvoiceDetail(
                                                      invoice: _invoiceModel
                                                          .invoices[index])));
                                        },
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('No Invoices founds'),
                                ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
