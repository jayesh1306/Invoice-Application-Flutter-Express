import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:testing/screens/InvoicePage/scoped_models/Invoice_Scoped_Model.dart';

// ignore: must_be_immutable
class AddInvoice extends StatefulWidget {
  final InvoiceModel invoiceModel;
  final String userId;

  const AddInvoice({Key key, this.invoiceModel, this.userId}) : super(key: key);

  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  final cloudinary =
      Cloudinary('567221595234463', '8tF1Av0aTnp_HzkdwQGD17Va474', 'diksrk8se');

  File _image;
  String _imageUrl;
  final picker = ImagePicker();
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  // TextEditingController dateController = TextEditingController();

  String invoiceDate;

  TextEditingController rateController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  Future getImage(String source) async {
    PickedFile pickedFile;
    if (source == 'Gallery') {
      pickedFile = await picker.getImage(
          source: (ImageSource.gallery), imageQuality: 10);
    } else {
      pickedFile =
          await picker.getImage(source: (ImageSource.camera), imageQuality: 10);
    }
    setState(() {
      isLoading = true;
    });
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cloudinary
          .uploadFile(
        filePath: _image.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'Invoices',
      )
          .then((value) {
        print(value.secureUrl);
        setState(() {
          _imageUrl = value.secureUrl;
          isLoading = false;
        });
      }).catchError((onError) {
        print(onError);
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> deleteImage(url) async {
    final response = await cloudinary.deleteFile(
      url: url,
      resourceType: CloudinaryResourceType.image,
      invalidate: false,
    );
    print('Delete from Cloudinary');
    print(response.isSuccessful);
    return response.isSuccessful;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Add Invoice',
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
      body: ScopedModel<InvoiceModel>(
        model: widget.invoiceModel,
        child: Container(
          // padding: EdgeInsets.all(30),
          child: ScopedModelDescendant<InvoiceModel>(
            builder: (context, child, model) {
              return SingleChildScrollView(
                child: Column(
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
                          hintText: "Product Name"),
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: rateController,
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
                          hintText: "Rate"),
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: quantityController,
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
                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                          hintText: "Quantity"),
                    ),
                    // TextFormField(
                    //   cursorColor: Colors.black,
                    //   controller: dateController,
                    //   keyboardType: TextInputType.datetime,
                    //   textInputAction: TextInputAction.done,
                    //   textCapitalization: TextCapitalization.words,
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //   ),
                    //   decoration: new InputDecoration(
                    //       border: InputBorder.none,
                    //       focusedBorder: InputBorder.none,
                    //       enabledBorder: InputBorder.none,
                    //       errorBorder: InputBorder.none,
                    //       disabledBorder: InputBorder.none,
                    //       contentPadding: EdgeInsets.only(left: 15, right: 15),
                    //       hintText: "Date"),
                    // ),
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
                                                          Navigator.pop(
                                                              context);
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
                    Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.camera,
                          color: Colors.black,
                        ),
                        onTap: () {
                          getImage('Camera');
                        },
                        title: Text('Capture from Camera'),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.photo,
                          color: Colors.black,
                        ),
                        onTap: () {
                          getImage('Gallery');
                        },
                        title: Text('Select from Gallery'),
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.camera),
                    //   onPressed: ,
                    // ),
                    // IconButton(
                    //   icon: Icon(Icons.photo),
                    //   onPressed: () {
                    //     getImage('Gallery');
                    //   },
                    // ),
                    Container(
                      child: _image != null
                          ? ListTile(
                              leading: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              title: Text('Delete Uploaded Image'),
                              onTap: () {
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
                                                          deleteImage(
                                                              _imageUrl);
                                                          setState(() {
                                                            _image = null;
                                                          });
                                                          Navigator.pop(
                                                              context);
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
                          : Container(),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: isLoading
                          ? Text('Uploading Image ... ')
                          : _image == null
                              ? Center(child: Text('No Image Selected'))
                              : Center(
                                  child: Image.file(
                                    _image,
                                    scale: 5,
                                  ),
                                ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        onPressed: nameController.text == '' &&
                                rateController.text == '' &&
                                quantityController.text == '' &&
                                invoiceDate == null
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please fill all the details'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            : () {
                                print(nameController.text);
                                model.addInvoice(
                                    nameController.text,
                                    rateController.text,
                                    quantityController.text,
                                    invoiceDate,
                                    _imageUrl,
                                    widget.userId);
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
