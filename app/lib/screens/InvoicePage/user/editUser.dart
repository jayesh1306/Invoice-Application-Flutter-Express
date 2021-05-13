import 'package:flutter/material.dart';

class EditUser extends StatelessWidget {
  final String id;

  const EditUser({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: Container(
        color: Colors.blue[100],
        height: 400,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(),
              TextFormField(),
              TextFormField(),
              TextFormField()
            ]),
      ),
    );
  }
}
