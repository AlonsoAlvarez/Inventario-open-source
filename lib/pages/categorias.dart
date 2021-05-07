import 'package:flutter/material.dart';
import 'package:inventario/components/Item.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/pages/categorias/detail.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'categorias/agregar.dart';

class PageCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub categorias'),
        actions: [
          if (appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PageAgregarCategoria()));
              },
            )
          ]
        ],
      ),
      body: StreamBuilder<List<Categoria>>(
          stream: Categoria().categoriasStream(),
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
          }),
    );
  }
}
