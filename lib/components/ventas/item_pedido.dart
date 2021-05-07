import 'package:flutter/material.dart';
import 'package:inventario/models/pedido.dart';

class ItemPedido extends StatelessWidget {
  final Pedido pedido;
  final bool isEntrada;

  const ItemPedido({Key key, @required this.pedido, @required this.isEntrada})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            if (pedido.producto == null) ...[
              Center(
                  child: Text('Producto Eliminado',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)))
            ] else ...[
              RichText(
                text: TextSpan(
                    text: '${pedido.producto.name} ',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: '${pedido.producto.description}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black))
                    ]),
              ),
              RichText(
                text: TextSpan(
                    text: 'pu: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                          text: isEntrada
                              ? '\$${pedido.producto.precioCompra}  '
                              : '\$${pedido.producto.precioVenta}  ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          )),
                      TextSpan(
                          text: 'cant: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          )),
                      TextSpan(
                          text: '${pedido.cantidad}  ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          )),
                      TextSpan(
                          text: 'net: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          )),
                      TextSpan(
                          text: isEntrada
                              ? '\$${pedido.producto.precioCompra * pedido.cantidad}'
                              : '\$${pedido.producto.precioVenta * pedido.cantidad}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ))
                    ]),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
