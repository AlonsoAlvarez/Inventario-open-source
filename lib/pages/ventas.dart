import 'package:flutter/material.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/pages/ventas/store.dart';
import 'package:inventario/components/ventas/Item_orden.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';

class PageVentas extends StatelessWidget {
  final bool isEntrada;

  const PageVentas({Key key, @required this.isEntrada}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(isEntrada ? 'Entradas' : 'Ventas'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PageStore(isEntrada: isEntrada)));
              },
            )
          ],
        ),
        body: StreamBuilder<List<Orden>>(
            stream: appState.usuario.isAdmin
                ? Orden().ordenesStreamDesending(isEntrada)
                : Orden().ordenesStreamDesendingEmpleado(
                    isEntrada, appState.usuario.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.isEmpty) {
                return Center(child: Text('Aun no hay ordenes'));
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(children: [
                    ...snapshot.data.map((e) => Container(
                          width: double.infinity,
                          child: ItemOrden(
                            isEntrada: isEntrada,
                            orden: e,
                            key: ValueKey('${e.uid.id}'),
                          ),
                        ))
                  ]),
                ),
              );
            }));
  }
}
