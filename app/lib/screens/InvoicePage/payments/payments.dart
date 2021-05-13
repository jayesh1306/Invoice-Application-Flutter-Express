import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/models/User.dart';
import 'package:testing/screens/InvoicePage/scoped_models/Payment_Scoped_Model.dart';
import 'package:testing/screens/InvoicePage/payments/addPayment.dart';

class PaymentDetail extends StatefulWidget {
  final User user;

  const PaymentDetail({Key key, this.user}) : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

PaymentModel _paymentModel = PaymentModel();

class _PaymentDetailState extends State<PaymentDetail> {
  bool showFab = true;

  DateTime backButtonPressTime;

  @override
  void initState() {
    super.initState();
    _paymentModel.getAllPayments(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
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
                  height: MediaQuery.of(context).size.height * 0.1,
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
                                        builder: (_) => AddPayment(
                                            user: widget.user,
                                            paymentModel: _paymentModel)));
                              },
                              child: Icon(Icons.add),
                            )
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
                child: ScopedModel<PaymentModel>(
                  model: _paymentModel,
                  child: ScopedModelDescendant<PaymentModel>(
                    builder: (context, child, model) {
                      return Text(
                        'Total Payments = ${_paymentModel.payments.length}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      );
                    },
                  ),
                ),
              ),
              ScopedModel<PaymentModel>(
                  model: _paymentModel,
                  child: ScopedModelDescendant<PaymentModel>(
                    rebuildOnChange: true,
                    builder: (context, child, model) {
                      return Container(
                        margin: EdgeInsets.only(left: 12, top: 10),
                        child: model.isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text('Loading...'),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '${_paymentModel.totalPayments}/-',
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
          ScopedModel<PaymentModel>(
            model: _paymentModel,
            child: ScopedModelDescendant<PaymentModel>(
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
                          child: _paymentModel.payments.length != 0
                              ? ListView.builder(
                                  itemCount: _paymentModel.payments.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      key:
                                          Key(_paymentModel.payments[index].id),
                                      onDismissed: (direction) async {
                                        bool isDeleted =
                                            await _paymentModel.removePayment(
                                                index,
                                                _paymentModel
                                                    .payments[index].id,
                                                widget.user.id);
                                        if (isDeleted) {
                                          showSnackBar(true);
                                        } else {
                                          showSnackBar(false);
                                        }
                                      },
                                      background: Container(
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
                                        leading: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: _paymentModel
                                                      .payments[index].mode ==
                                                  'Cash'
                                              ? Icon(
                                                  Icons.money,
                                                  size: 35,
                                                )
                                              : _paymentModel.payments[index]
                                                          .mode ==
                                                      'Card'
                                                  ? Icon(
                                                      Icons.credit_card,
                                                      size: 35,
                                                    )
                                                  : Icon(
                                                      Icons
                                                          .account_balance_rounded,
                                                      size: 35,
                                                    ),
                                        ),
                                        title: Text(
                                            'Amount : ${_paymentModel.payments[index].amount.toString().split('.')[0]}'),
                                        subtitle: Text(
                                            'Mode : ${_paymentModel.payments[index].mode}'),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('No Payments founds'),
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
