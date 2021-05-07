import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/providers/venta_state.dart';
import 'package:inventario/screens/show_img.dart';
import 'package:provider/provider.dart';

class CardPedido extends StatelessWidget {
  final Pedido pedido;
  final bool isEntrada;

  const CardPedido({Key key, @required this.pedido, @required this.isEntrada})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ventaState = Provider.of<VentaState>(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300],
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(2, 2))
        ],
      ),
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: RaisedButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ShowImage(
                                          tagHero: pedido.producto.url,
                                          place: 'assets/camara.png',
                                          url: pedido.producto.url,
                                          foto: null,
                                        )));
                          },
                          child: Hero(
                            tag: pedido.producto.url,
                            child: Container(
                                height: 150,
                                color: Colors.white,
                                child: FadeInImage(
                                  image: NetworkImage(pedido.producto.url),
                                  placeholder: AssetImage('assets/camara.png'),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            pedido.producto.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          Text(
                            pedido.producto.description,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            isEntrada
                                ? '\$${pedido.producto.precioCompra}'
                                : '\$${pedido.producto.precioVenta}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Column(
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                color: pedido.cantidad == 0
                    ? Colors.redAccent
                    : Colors.blueGrey[800],
                child: Icon(
                  pedido.cantidad == 0 ? Icons.delete : Icons.remove,
                  color: Colors.white,
                ),
                onLongPress: () {
                  if (10 < pedido.cantidad) {
                    ventaState.cambiarCantidad(pedido, pedido.cantidad - 10);
                  } else {
                    ventaState.cambiarCantidad(pedido, 0);
                  }
                },
                onPressed: () {
                  if (0 < pedido.cantidad) {
                    ventaState.cambiarCantidad(pedido, pedido.cantidad - 1);
                  } else {
                    ventaState.remover(pedido);
                  }
                },
              ),
              Container(
                height: 20,
                child: RaisedButton(
                  padding: const EdgeInsets.all(0),
                  elevation: 0,
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final numero =
                              TextEditingController(text: '${pedido.cantidad}');
                          return AlertDialog(
                              title: Text('Selecciona cantidad'),
                              content: Container(
                                  child: TextField(
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                controller: numero,
                              )),
                              actions: [
                                RaisedButton.icon(
                                    color: Colors.blueGrey[800],
                                    icon:
                                        Icon(Icons.check, color: Colors.white),
                                    label: Text('Ok',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      int numeroNuevo =
                                          int.tryParse(numero.text);
                                      if (numeroNuevo != null &&
                                          -1 < numeroNuevo) {
                                        ventaState.cambiarCantidad(
                                            pedido, numeroNuevo);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Numero invalido');
                                      }
                                      Navigator.pop(context);
                                    })
                              ]);
                        });
                  },
                  child: Text('${pedido.cantidad}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                color: Colors.blueGrey[800],
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onLongPress: () {
                  ventaState.cambiarCantidad(pedido, pedido.cantidad + 10);
                },
                onPressed: () {
                  ventaState.cambiarCantidad(pedido, pedido.cantidad + 1);
                },
              )
            ],
          ),
        )
      ]),
    );
  }
}
