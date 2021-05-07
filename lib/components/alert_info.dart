import 'package:flutter/material.dart';

class AlertInfo extends StatelessWidget {
  final String title;
  final String message;
  final Function function;

  const AlertInfo(
      {Key key,
      @required this.title,
      @required this.message,
      @required this.function})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: Text(message,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17)),
      ),
      actions: [
        RaisedButton.icon(
          color: Colors.blueGrey[700],
          onPressed: () {
            function();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          label: Text('Ok', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
