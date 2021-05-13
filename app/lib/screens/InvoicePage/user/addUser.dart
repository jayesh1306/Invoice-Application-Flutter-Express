import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/scoped_models/User_Scoped_Model.dart';

// ignore: must_be_immutable
class AddUser extends StatefulWidget {
  final UserModel userModel;

  const AddUser({Key key, this.userModel}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();

  TextEditingController contactController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User',
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
      body: ScopedModel<UserModel>(
        model: widget.userModel,
        child: Container(
          padding: EdgeInsets.all(30),
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
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
                        hintText: "Name"),
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    // textCapitalization: TextCapitalization.words,
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
                        hintText: "Email"),
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: contactController,
                    keyboardType: TextInputType.phone,
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
                        contentPadding: EdgeInsets.only(left: 15, right: 15),
                        hintText: "Contact"),
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: addressController,
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
                        contentPadding: EdgeInsets.only(left: 15, right: 15),
                        hintText: "Address"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue[400],
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue[700]),
                        )),
                      ),
                      onPressed: () {
                        model.addUser(
                            nameController.text,
                            contactController.text,
                            addressController.text,
                            emailController.text);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
