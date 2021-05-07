import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import './itemPickCategoria.dart';

class AlertPickCategoria extends StatelessWidget {
  final Function seleccionar;

  const AlertPickCategoria({Key key, @required this.seleccionar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Selecciona',
        style: TextStyle(fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: FutureBuilder<List<Categoria>>(
          future: Categoria().categoriasFuture(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.isEmpty) {
              return Center(child: Text('No hay categorias aún'));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...snapshot.data.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ItemPickCategoria(
                          key: ValueKey(e.uid),
                          categoria: e,
                          function: () {
                            seleccionar(e);
                            Navigator.pop(context);
                          },
                        ),
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
