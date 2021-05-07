import 'package:flutter/material.dart';
import 'package:inventario/components/productos/card_producto.dart';
import 'package:inventario/models/marca.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/pages/productos/agregar.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:inventario/components/Item.dart';
import 'package:inventario/pages/categorias/detail.dart';

import 'agregar.dart';

class PageMarcaDetail extends StatefulWidget {
  final Marca marca;

  const PageMarcaDetail({Key key, this.marca}) : super(key: key);

  @override
  _PageMarcaDetailState createState() => _PageMarcaDetailState();
}

class _PageMarcaDetailState extends State<PageMarcaDetail> {
  bool showProductos = true;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.marca.name),
        actions: [
          if (appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PageAgregarMarca(
                              marca: widget.marca,
                            )));
              },
            )
          ]
        ],
      ),
      floatingActionButton: widget.marca.categorias != null
          ? FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blueGrey[800],
              child: Icon(!showProductos ? Icons.book : Icons.category),
              tooltip: showProductos ? 'Ver categorias' : 'Ver productos',
              onPressed: () => setState(() => showProductos = !showProductos),
            )
          : Container(),
      body: showProductos
          ? StreamBuilder<List<Producto>>(
              stream: Producto().productosMarcaStream(widget.marca.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.isEmpty) {
                  return Center(child: Text('No hay productos aún'));
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
              })
          : widget.marca.categorias != null
              ? FutureBuilder<List<Categoria>>(
                  future:
                      Categoria().consultarListFuture(widget.marca.categorias),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data.isEmpty) {
                      return Center(child: Text('No hay categorias aún'));
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            ...snapshot.data.map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Item(
                                    objeto: e,
                                    function: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PageCategoriaDetail(
                                                    categoria: e,
                                                  )));
                                    },
                                    key: ValueKey(e.uid.id),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  })
              : Center(child: Text('No hay categorias aún')),
    );
  }
}
