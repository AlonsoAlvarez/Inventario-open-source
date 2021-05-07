import 'package:flutter/material.dart';

class AlertConfirma extends StatelessWidget {
  final String title;
  final Function acept;
  final Function cancel;

  const AlertConfirma(
      {Key key,
      @required this.title,
      @required this.acept,
      @required this.cancel})
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
        child: Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      acept();
                    },
                    icon: Icon(Icons.check),
                    label: Text('Sí',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic)),
                    color: Colors.blueGrey[200])),
            SizedBox(width: 5.0),
            Expanded(
                child: RaisedButton.icon(
              onPressed: () {
                cancel();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              label: Text('No',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic)),
              color: Colors.redAccent[200],
            ))
          ],
        ),
      ),
    );
  }
}
