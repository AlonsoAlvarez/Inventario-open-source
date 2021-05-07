import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/models/especificacion.dart';

class PageAgregarEspecificaciones extends StatefulWidget {
  final Categoria categoria;

  const PageAgregarEspecificaciones({Key key, this.categoria})
      : super(key: key);

  @override
  _PageAgregarEspecificacionesState createState() =>
      _PageAgregarEspecificacionesState();
}

class _PageAgregarEspecificacionesState
    extends State<PageAgregarEspecificaciones> {
  final nameController = TextEditingController();

  List material = [];
  List comercial = [];
  List uso = [];
  List acabado = [];
  List apariencia = [];
  List color = [];
  List pei = [];
  List promocion = [];
  List pisoMuro = [];

  Especificacion esp;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.categoria.name;
    Especificacion.consultarByCategoria(widget.categoria.uid).then((value) {
      if (value != null) {
        setState(() {
          esp = value;
          material = value.material;
          comercial = value.comercial;
          uso = value.uso;
          acabado = value.acabado;
          apariencia = value.apariencia;
          color = value.color;
          pei = value.pei;
          promocion = value.promocion;
          pisoMuro = value.pisoMuro;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Especificaciones'), actions: [
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertConfirma(
                      title: esp != null ? '¿Actualizar?' : '¿Crear?',
                      cancel: () {},
                      acept: () {
                        var tmp = Especificacion(
                          uso: uso,
                          uidCategoria: widget.categoria.uid,
                          promocion: promocion,
                          pisoMuro: pisoMuro,
                          pei: pei,
                          name: widget.categoria.name,
                          material: material,
                          comercial: comercial,
                          color: color,
                          apariencia: apariencia,
                          acabado: acabado,
                        );
                        if (esp != null) {
                          // actualizar
                          Especificacion.actualizar(esp.uid, tmp.toMap);
                        } else {
                          // crear
                          Especificacion.crear(tmp.toMap);
                        }
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        Fluttertoast.showToast(
                            msg: 'Especificaciones guardadas');
                      },
                    );
                  });
            })
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: [
            TextField(
                readOnly: true,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'SUB CATEGORIA',
                )),
            RowAddEsp(
              especif: 'Tipo de material',
              funcion: (e) => setState(() => material.add(e)),
            ),
            ...material.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => material.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Comercial/Residencial',
              funcion: (e) => setState(() => comercial.add(e)),
            ),
            ...comercial.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => comercial.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Uso',
              funcion: (e) => setState(() => uso.add(e)),
            ),
            ...uso.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => uso.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Acabado',
              funcion: (e) => setState(() => acabado.add(e)),
            ),
            ...acabado.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => acabado.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Apariencia',
              funcion: (e) => setState(() => apariencia.add(e)),
            ),
            ...apariencia.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => apariencia.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Color',
              funcion: (e) => setState(() => color.add(e)),
            ),
            ...color.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => color.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'PEI',
              funcion: (e) => setState(() => pei.add(e)),
            ),
            ...pei.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => pei.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Piso o muro',
              funcion: (e) => setState(() => pisoMuro.add(e)),
            ),
            ...pisoMuro.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => pisoMuro.remove(e)))),
            Divider(),
            RowAddEsp(
              especif: 'Promocion',
              funcion: (e) => setState(() => promocion.add(e)),
            ),
            ...promocion.map((e) => ButtonEspStr(
                esp: e, funcion: () => setState(() => promocion.remove(e)))),
            Divider()
          ]),
        ),
      ),
    );
  }
}

class ButtonEspStr extends StatelessWidget {
  final String esp;
  final Function funcion;

  const ButtonEspStr({
    Key key,
    this.esp,
    this.funcion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('$esp'),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertConfirma(
                title: '¿Borrar?',
                cancel: () {},
                acept: funcion,
              );
            });
      },
    );
  }
}

class RowAddEsp extends StatelessWidget {
  final String especif;
  final Function funcion;

  RowAddEsp({
    Key key,
    this.especif,
    this.funcion,
  }) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text('$especif')),
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Agregar campo'),
                    content: TextField(
                      controller: controller,
                      /* decoration: InputDecoration(
                        labelText: 'NOMBRE',
                      ), */
                    ),
                    actions: [
                      RaisedButton(
                        child: Text('Agregar'),
                        onPressed: () {
                          Navigator.pop(context);
                          funcion(controller.text);
                        },
                      )
                    ],
                  );
                });
          })
    ]);
  }
}
