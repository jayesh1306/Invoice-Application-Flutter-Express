import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AllInvoice extends StatefulWidget {
  final String name;

  const AllInvoice({Key key, this.name}) : super(key: key);

  @override
  _AllInvoiceState createState() => _AllInvoiceState();
}

class _AllInvoiceState extends State<AllInvoice> {
  bool showFab = true;

  @override
  void initState() {
    super.initState();
    getAllFiles();
  }

  String message;
  List files = [];
  bool dirExists;
  String dir;

  void getAllFiles() async {
    dir = p.join((await getExternalStorageDirectory()).path, '${widget.name}');
    dirExists = await Directory(dir).exists();
    if (dirExists == true) {
      setState(() {
        files = Directory(dir).listSync();
      });
    } else {
      setState(() {
        message = 'No Invoices Created';
      });
    }
  }

  Future<bool> deleteFile(int index) async {
    try {
      final file = File(files[index].path);
      await file.delete();
      files.removeAt(index);
      setState(() {
        files = files;
      });
      // getAllFiles();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  showSnackBar(bool isTrue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: isTrue ? Text('Deleted') : Text('Cannot Delete'),
        duration: Duration(milliseconds: 500),
        backgroundColor: isTrue ? Colors.green : Colors.red,
      ),
    );
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
                              '${widget.name}',
                              style: TextStyle(
                                fontSize: 20,
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
            child: dirExists == false || files.length == 0
                ? Text(
                    'No Invoices Created',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              'Invoice from : ${files[index].toString().split('.')[4]}'),
                          subtitle: Text(
                            'Date: ${files[index].toString().split('.')[3]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            OpenFile.open(files[index].path);
                          },
                          trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
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
                                                      'Are you sure want to delete the Invoice ?',
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
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            bool isDeleted =
                                                                await deleteFile(
                                                                    index);
                                                            print(isDeleted);
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
                                                              color:
                                                                  Colors.red),
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
                              }),
                        );
                      },
                      itemCount: files.length,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
