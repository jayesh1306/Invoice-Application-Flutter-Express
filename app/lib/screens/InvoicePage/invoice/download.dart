import 'package:flutter/material.dart';
import 'package:testing/screens/InvoicePage/scoped_models/Invoice_Scoped_Model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class DownloadInvoice extends StatefulWidget {
  final String userId;
  final String name;
  final InvoiceModel invoiceModel;
  const DownloadInvoice({Key key, this.userId, this.invoiceModel, this.name})
      : super(key: key);
  @override
  _DownloadInvoiceState createState() => _DownloadInvoiceState();
}

class _DownloadInvoiceState extends State<DownloadInvoice> {
  TextEditingController fromController = new TextEditingController();
  TextEditingController toController = new TextEditingController();

  String pathOfDownloadDir;
  double downloadMessage;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    createDir();
  }

  void createDir() async {
    Directory appDocDirectory = await getExternalStorageDirectory();
    new Directory(appDocDirectory.path + '/' + '${widget.name}')
        .create(recursive: true)
        .then((Directory directory) {
      setState(() {
        pathOfDownloadDir = directory.path;
      });
    });
  }

  String _fromDate;
  String _toDate;
  String dropdownValue = 'Bhupat Prajapati';
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
                              'Download Invoice',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      trailing: _fromDate != null
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
                                                            _fromDate = null;
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
                              _fromDate = date;
                            });
                          }
                        }).catchError((onError) => {});
                      },
                      title: _fromDate == null
                          ? Text('Select from Date')
                          : Text('From Date : $_fromDate'),
                    ),
                    ListTile(
                      trailing: _toDate != null
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
                                                      'Are you sure want to delete the date ?',
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
                                                            _toDate = null;
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
                              _toDate = date;
                            });
                          }
                        }).catchError((onError) => {});
                      },
                      title: _toDate == null
                          ? Text('Select to Date')
                          : Text('To Date : $_toDate'),
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
                        items: <String>[
                          'Bhupat Prajapati',
                          'Rameshwar Enterprise'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isDownloading = true;
                      });
                      PermissionStatus status =
                          await Permission.storage.request();
                      if (status == PermissionStatus.granted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Download starting. Please wait'),
                          backgroundColor: Colors.orangeAccent,
                          duration: Duration(milliseconds: 300),
                        ));
                        if (_fromDate != null && _toDate != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Started Download'),
                            duration: Duration(milliseconds: 100),
                          ));
                          widget.invoiceModel
                              .downloadInvoice(_fromDate, _toDate,
                                  widget.userId, dropdownValue)
                              .then((value) async {
                            if (value == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('No Invoice Created'),
                              ));
                              setState(() {
                                _isDownloading = false;
                              });
                            } else {
                              dio.download(
                                  'https://flutter-testing.herokuapp.com/report.pdf',
                                  // 'http://192.168.0.112:3000/report.pdf',
                                  '$pathOfDownloadDir/${widget.name}.$_fromDate - $_toDate.$dropdownValue.pdf',
                                  deleteOnError: true,
                                  onReceiveProgress: (actualBytes, totalBytes) {
                                if (actualBytes == totalBytes) {
                                  setState(() {
                                    _isDownloading = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Download Complete'),
                                    action: SnackBarAction(
                                      label: 'Open',
                                      onPressed: () {
                                        OpenFile.open(
                                            '$pathOfDownloadDir/${widget.name}.$_fromDate - $_toDate.$dropdownValue.pdf');
                                      },
                                    ),
                                  ));
                                }
                                setState(() {
                                  downloadMessage =
                                      actualBytes / totalBytes * 100;
                                  _isDownloading = false;
                                });
                              });
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('All fields are required'),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Permission not granted'),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    },
                    child: _isDownloading
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.height * 0.02,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ))
                        : Text('Download'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
