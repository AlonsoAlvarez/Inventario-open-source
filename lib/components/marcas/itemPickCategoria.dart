import 'package:flutter/material.dart';
import '../../models/categoria.dart';

class ItemPickCategoria extends StatelessWidget {
  final Categoria categoria;
  final Function function;

  const ItemPickCategoria(
      {Key key, @required this.categoria, @required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: function,
      child: Container(
          child: Row(
        children: [
          Container(
              height: 70,
              width: 70,
              child: Image.network(
                categoria.url,
                fit: BoxFit.contain,
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(child: Text('${categoria.name}')),
        ],
      )),
    );
  }
}
