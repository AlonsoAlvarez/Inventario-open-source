import 'package:flutter/material.dart';
import 'package:inventario/models/usuario.dart';

class Item extends StatelessWidget {
  final dynamic objeto;
  final Function function;

  const Item({Key key, @required this.objeto, @required this.function})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: function,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration:
              BoxDecoration(color: Colors.grey[100], border: Border.all()),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: FadeInImage(
                    image: NetworkImage(objeto.url),
                    placeholder: AssetImage('assets/profile.png'),
                  )),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      '${objeto.name}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    if (objeto.runtimeType == Usuario
                        ? objeto.email != null
                        : objeto.description != null) ...[
                      Text(
                        objeto.runtimeType == Usuario
                            ? '${objeto.email}'
                            : '${objeto.description}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
