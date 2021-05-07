import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventario/components/productos/card_producto.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/pages/productos/agregar.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';

class PageProductos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          if (appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PageAgregarPrducto()));
              },
            )
          ]
        ],
      ),
      body: StreamBuilder<List<Producto>>(
          stream: Producto().productosStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.isEmpty) {
              return Center(child: Text('No hay productos aún'));
            }
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    ...snapshot.data.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: CardProducto(
                            producto: e,
                            function: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PageAgregarPrducto(
                                            producto: e,
                                          )));
                            },
                            key: ValueKey(e.uid.id),
                          ),
                        ))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
