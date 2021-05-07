import 'package:flutter/material.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/pages/productos/agregar.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:provider/provider.dart';

class PageProductoDetail extends StatelessWidget {
  final Producto producto;

  const PageProductoDetail({Key key, @required this.producto})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        actions: [
          if (appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PageAgregarPrducto(
                              producto: producto,
                            )));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertConfirma(
                        title: '¿Eliminar?',
                        cancel: () {},
                        acept: () {
                          deleteFile(producto.url);
                          Producto().delete(producto.uid);
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            )
          ]
        ],
      ),
    );
  }
}
