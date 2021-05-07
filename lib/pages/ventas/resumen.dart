import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/ventas/item_pedido.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/providers/venta_state.dart';
import 'package:provider/provider.dart';

class PageOrdenResumen extends StatelessWidget {
  final bool isEntrada;

  const PageOrdenResumen({Key key, @required this.isEntrada}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final viajeState = Provider.of<VentaState>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(isEntrada ? 'Agregar a inventario' : 'Resumen de orden')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              ...viajeState.pedidos.map((e) => Column(
                    children: [
                      ItemPedido(pedido: e, isEntrada: isEntrada),
                      Divider()
                    ],
                  )),
              RichText(
                  text: TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                    TextSpan(
                        text: isEntrada
                            ? '\$${viajeState.totalEntrada}'
                            : '\$${viajeState.totalVenta}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w300,
                        ))
                  ])),
              Divider(),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blueGrey[800],
                  child: Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    List<DocumentReference> tmp = [];
                    double total = 0;
                    for (int i = 0; i < viajeState.pedidos.length; i++) {
                      total += (isEntrada
                              ? viajeState.pedidos[i].producto.precioCompra
                              : viajeState.pedidos[i].producto.precioVenta) *
                          viajeState.pedidos[i].cantidad;
                      tmp.add(await Pedido()
                          .createPedido(viajeState.pedidos[i].toMap));
                      Producto().update(viajeState.pedidos[i].producto.uid, {
                        'stock': isEntrada
                            ? (viajeState.pedidos[i].producto.stock +
                                viajeState.pedidos[i].cantidad)
                            : (viajeState.pedidos[i].producto.stock -
                                viajeState.pedidos[i].cantidad)
                      });
                    }
                    Orden().createOrden(Orden(
                            uidEncargado: appState.usuario.uid,
                            isEntrada: isEntrada,
                            total: total,
                            uidPedidos: tmp,
                            fecha: DateTime.now())
                        .toMap);
                    viajeState.reset();
                    Fluttertoast.showToast(msg: 'Orden creada');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
