import 'package:flutter/material.dart';
import 'package:inventario/components/ventas/store/alert_buscar.dart';
import 'package:inventario/components/ventas/store/card_pedido.dart';
import 'package:inventario/providers/venta_state.dart';
import 'package:provider/provider.dart';

import 'resumen.dart';

class PageStore extends StatelessWidget {
  final bool isEntrada;

  const PageStore({Key key, @required this.isEntrada}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ventaState = Provider.of<VentaState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden'),
        actions: [
          if (ventaState.pedidos.isNotEmpty) ...[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PageOrdenResumen(isEntrada: isEntrada)));
              },
            ),
          ],
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertBuscar();
                  });
            },
          )
        ],
      ),
      body: ventaState.pedidos.isEmpty
          ? Center(child: Text('No hay productos seleccionados'))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    ...ventaState.pedidos.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CardPedido(
                            isEntrada: isEntrada,
                            key: ValueKey(e.producto.uid.id),
                            pedido: e,
                          ),
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}
