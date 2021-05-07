import 'package:flutter/material.dart';
import 'package:inventario/components/productos/card_producto.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/pages/productos/agregar.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'agregar.dart';

class PageCategoriaDetail extends StatelessWidget {
  final Categoria categoria;

  const PageCategoriaDetail({Key key, this.categoria}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria.name),
        actions: [
          if (appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PageAgregarCategoria(
                              categoria: categoria,
                            )));
              },
            )
          ]
        ],
      ),
      body: StreamBuilder<List<Producto>>(
          stream: Producto().productosCategoriaStream(categoria.uid),
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
