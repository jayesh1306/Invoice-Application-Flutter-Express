import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:testing/screens/InvoicePage/scoped_models/User_Scoped_Model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/invoice/details.dart';
import 'package:testing/screens/InvoicePage/payments/payments.dart';
import 'package:testing/screens/InvoicePage/user/addUser.dart';

// Models
UserModel _userModel = UserModel();

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  ScrollController _visibleController;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    if (_userModel.users.length < 8) {
      setState(() {
        isVisible = true;
      });
    } else {
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
    }
    _userModel.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Warning'),
            content: Text('Are you sure want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.blue[300],
          shadowColor: Colors.transparent,
        ),
        floatingActionButton: Visibility(
          visible: isVisible,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddUser(
                            userModel: _userModel,
                          )));
            },
            label: Text('Add User'),
            icon: Icon(Icons.add),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      // color: Colors.blue[300],
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 30, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              'Bhupat Prajapati',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Vapi, Gujarat',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '+91 9898631960',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'bhupat203@gmail.com',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ScopedModel<UserModel>(
                            model: _userModel,
                            child: ScopedModelDescendant<UserModel>(
                              builder: (context, child, model) {
                                return Container(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    'Customers : ${model.users.length}',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12, top: 10),
              child: Text(
                'Customers',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            // FloatingActionButton(
            //     child: Icon(
            //       Icons.add,
            //       size: 40,
            //     ),
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => AddUser(userModel: _userModel)));
            //     }),
            Divider(
              color: Colors.black,
            ),
            ScopedModel<UserModel>(
              model: _userModel,
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  void showSnackBar(bool isDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            isDeleted ? Text('Deleted') : Text('Cannot Delete'),
                        backgroundColor: isDeleted ? Colors.green : Colors.red,
                        duration: Duration(milliseconds: 500),
                      ),
                    );
                  }

                  return !model.isLoading
                      ? model.users.length != 0
                          ? Expanded(
                              child: Container(
                                child: ListView.builder(
                                  controller: _visibleController,
                                  itemCount: model.users.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text('${model.users[index].name}'),
                                      subtitle:
                                          Text('${model.users[index].contact}'),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => UserDetail(
                                                      userModel: _userModel,
                                                      user: _userModel
                                                          .users[index],
                                                      name: model
                                                          .users[index].name,
                                                    )));
                                      },
                                      trailing: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.attach_money,
                                                    color: Colors.red[400],
                                                  ),
                                                  onPressed: () {
                                                    print('Pressed');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PaymentDetail(
                                                          user: _userModel
                                                              .users[index],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                // IconButton(
                                                //   icon: Icon(
                                                //     Icons.edit,
                                                //     color: Colors.green[400],
                                                //   ),
                                                //   onPressed: () {
                                                //     Scaffold.of(context)
                                                //         .showBottomSheet<void>(
                                                //       (BuildContext context) {
                                                //         return EditUser(
                                                //             id: index.toString());
                                                //       },
                                                //     );
                                                //   },
                                                // ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red[400],
                                                  ),
                                                  onPressed: () async {
                                                    bool isDeleted =
                                                        await _userModel
                                                            .removeUser(
                                                                index,
                                                                _userModel
                                                                    .users[
                                                                        index]
                                                                    .id);
                                                    if (isDeleted) {
                                                      showSnackBar(true);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Cannot send'),
                                                          backgroundColor:
                                                              Colors.red,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  500),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: Text('No User founds'),
                            )
                      : Container(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
