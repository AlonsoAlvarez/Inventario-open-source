import 'package:flutter/material.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'marcas/agregar.dart';
import 'package:inventario/components/Item.dart';
import 'package:inventario/models/marca.dart';

import 'marcas/detail.dart';

class PageMarcas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Marcas'),
        actions: [
          if (appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PageAgregarMarca()));
              },
            )
          ]
        ],
      ),
      body: StreamBuilder<List<Marca>>(
          stream: Marca().marcasStream(),
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
                                          PageMarcaDetail(
                                            marca: e,
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
