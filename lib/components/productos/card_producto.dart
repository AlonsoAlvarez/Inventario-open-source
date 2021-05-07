import 'package:flutter/material.dart';
import 'package:inventario/models/producto.dart';

class CardProducto extends StatelessWidget {
  final Producto producto;
  final Function function;

  const CardProducto({Key key, this.producto, this.function}) : super(key: key);
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
                  image: NetworkImage(producto.url),
                  placeholder: AssetImage('assets/profile.png'),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      '${producto.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    if (producto.description != null) ...[
                      Text(
                        '${producto.description}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      )
                    ]
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
