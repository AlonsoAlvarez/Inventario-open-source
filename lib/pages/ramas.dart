import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/models/rama.dart';

class PageRamas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Categorias'), actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final name = TextEditingController();
                final index = TextEditingController();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Agregar'),
                        content: SingleChildScrollView(
                          child: Column(children: [
                            TextField(
                              controller: name,
                              decoration: InputDecoration(labelText: 'NOMBRE'),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: index,
                              decoration: InputDecoration(labelText: 'INDICE'),
                              keyboardType: TextInputType.number,
                            )
                          ]),
                        ),
                        actions: [
                          RaisedButton(
                            child: Text('Guardar'),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertConfirma(
                                      title: '¿Crear?',
                                      cancel: () {},
                                      acept: () {
                                        int tmp = int.tryParse(index.text);
                                        if (tmp != null) {
                                          Rama.create({
                                            'name': name.text,
                                            'index': tmp
                                          });
                                          Fluttertoast.showToast(
                                              msg: 'Guardado');
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Datos incorrectos');
                                        }
                                      },
                                    );
                                  });
                            },
                          )
                        ],
                      );
                    });
              })
        ]),
        body: StreamBuilder<List<Rama>>(
            stream: Rama().consultarStream(),
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
                          ...snapshot.data.map(
                              (e) => ButtonRama(key: ValueKey(e.uid), rama: e))
                        ],
                      )));
            }));
  }
}

class ButtonRama extends StatelessWidget {
  final Rama rama;

  ButtonRama({
    Key key,
    this.rama,
  }) : super(key: key);

  final name = TextEditingController();
  final index = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (rama != null) {
      name.text = rama.name;
      index.text = rama.index != null ? '${rama.index}' : '0';
    }
    return RaisedButton(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertConfirma(
                title: '¿Eliminar?',
                cancel: () {},
                acept: () {
                  rama.uid.delete();
                },
              );
            });
      },
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Editar'),
                content: SingleChildScrollView(
                  child: Column(children: [
                    TextField(
                      controller: name,
                      decoration: InputDecoration(labelText: 'NOMBRE'),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: index,
                      decoration: InputDecoration(labelText: 'INDICE'),
                      keyboardType: TextInputType.number,
                    )
                  ]),
                ),
                actions: [
                  RaisedButton(
                    child: Text('Guardar'),
                    onPressed: () {
                      int tmp = int.tryParse(index.text);
                      if (tmp != null) {
                        rama.uid.update({'name': name.text, 'index': tmp});
                        Fluttertoast.showToast(msg: 'Guardado');
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(msg: 'Datos incorrectos');
                      }
                    },
                  )
                ],
              );
            });
      },
      child: Row(
        children: [
          Text('${rama.index}: '),
          Expanded(child: Text('${rama.name}'))
        ],
      ),
    );
  }
}
