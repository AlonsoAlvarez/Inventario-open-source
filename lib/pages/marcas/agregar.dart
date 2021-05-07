import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/components/alert_info.dart';
import 'package:inventario/components/alert_pick.dart';
import 'package:inventario/components/marcas/itemPickCategoria.dart';
import 'package:inventario/components/marcas/alertPickCategoria.dart';
import 'package:inventario/models/marca.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/utils/crop_img.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:provider/provider.dart';

class PageAgregarMarca extends StatefulWidget {
  final Marca marca;

  const PageAgregarMarca({Key key, this.marca}) : super(key: key);

  @override
  _PageAgregarMarcaState createState() => _PageAgregarMarcaState();
}

class _PageAgregarMarcaState extends State<PageAgregarMarca> {
  final _formKey = GlobalKey<FormState>();
  final nodeDescription = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File foto;
  bool loading = false;

  List<Categoria> categorias = [];

  @override
  void initState() {
    super.initState();
    if (widget.marca != null) {
      nameController.text = widget.marca.name;
      descriptionController.text = widget.marca.description;
      if (widget.marca.categorias != null) {
        widget.marca.categorias.forEach((element) {
          Categoria()
              .consultarFuture(element)
              .then((value) => setState(() => categorias.add(value)));
        });
      }
    }
  }

  void tomarFoto() {
    pickedFile().then((value) => setState(() => foto = value));
  }

  void cortarFoto() {
    cropImage(foto).then((value) => setState(() => foto = value));
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.marca != null ? 'Editar' : 'Agregar'),
        actions: [
          if (widget.marca != null && appState.usuario.isAdmin) ...[
            loading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      List tmp = await Marca().productosMarca(widget.marca.uid);
                      setState(() => loading = false);
                      if (tmp.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertConfirma(
                                title: '¿Eliminar?',
                                cancel: () {},
                                acept: () {
                                  deleteFile(widget.marca.url);
                                  Marca().delete(widget.marca.uid);
                                  Navigator.pop(context);
                                },
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertInfo(
                                title: 'Error',
                                message:
                                    'No se puede borrar por que hay ${tmp.length} productos referenciados a la marca ${widget.marca.name}',
                                function: () {},
                              );
                            });
                      }
                    },
                  )
          ]
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (foto != null ||
                              (widget.marca != null &&
                                  widget.marca.url != null)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertPickImage(
                                    borrar: false,
                                    url: widget.marca != null
                                        ? widget.marca.url
                                        : null,
                                    tagHero: 'HeroFoto',
                                    pick: tomarFoto,
                                    crop: cortarFoto,
                                    delete: () => setState(() => foto = null),
                                    foto: foto,
                                  );
                                });
                          } else {
                            // SELECCIONAR IMAGEN
                            tomarFoto();
                          }
                        },
                        child: Hero(
                          tag: 'HeroFoto',
                          child: Container(
                              color: Colors.white,
                              child: FadeInImage(
                                image: foto != null
                                    ? FileImage(foto)
                                    : NetworkImage(widget.marca != null
                                        ? widget.marca.url
                                        : ''),
                                placeholder: AssetImage('assets/camara.png'),
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      readOnly: appState.usuario.isAdmin ? loading : true,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'MARCA',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(nodeDescription);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nombre de marca';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: appState.usuario.isAdmin ? loading : true,
                      controller: descriptionController,
                      focusNode: nodeDescription,
                      decoration: InputDecoration(
                          labelText: 'DESCRIPCION',
                          hintText: 'Ej: Azulejo, pegamento, etc.'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Productos principales de la marca';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Transform.rotate(
                      angle: pi,
                      child: Icon(
                        Icons.error_outline,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertInfo(
                              function: () {},
                              title: 'Info',
                              message:
                                  'En este apartado colocar los principales productos de la marca, Ej: girferia, tinas y espejos',
                            );
                          });
                    },
                  )
                ],
              ),
              SizedBox(height: 10),
              if (categorias.isNotEmpty) ...[
                ...categorias.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ItemPickCategoria(
                        key: ValueKey(e.uid),
                        categoria: e,
                        function: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertConfirma(
                                    title: '¿Eliminar ${e.name}?',
                                    acept: () =>
                                        setState(() => categorias.remove(e)),
                                    cancel: () {});
                              });
                        },
                      ),
                    ))
              ],
              RaisedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Agregar categoria'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertPickCategoria(
                          seleccionar: (categoria) {
                            categorias.add(categoria);
                            setState(() {});
                          },
                        );
                      });
                  // DESPLEGAR MENU CON OCIONES DE CATEGORIA
                },
              ),
              SizedBox(height: 20),
              if (appState.usuario.isAdmin) ...[
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blueGrey[800],
                    onPressed: () async {
                      if (_formKey.currentState.validate() &&
                          (foto != null || widget.marca != null)) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertConfirma(
                                title: widget.marca != null
                                    ? '¿Actualizar?'
                                    : '¿Guardar?',
                                cancel: () {},
                                acept: () async {
                                  setState(() => loading = true);
                                  String url2 = foto != null
                                      ? await uploadPicture(
                                          foto,
                                          '${nameController.text}',
                                          Folder.marcas)
                                      : widget.marca.url;
                                  List referencias = [];
                                  categorias.forEach((element) {
                                    referencias.add(element.uid);
                                  });
                                  Marca tmp = Marca(
                                      url: url2,
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      categorias: referencias);
                                  if (widget.marca != null) {
                                    Marca().update(widget.marca.uid, tmp.toMap);
                                    Fluttertoast.showToast(msg: 'Actualizado');
                                  } else {
                                    Marca().create(tmp.toMap);
                                    Fluttertoast.showToast(msg: 'Guardado');
                                  }
                                  setState(() => loading = false);
                                  Navigator.pop(context);
                                },
                              );
                            });
                      } else {
                        Fluttertoast.showToast(msg: 'Datos incompletos');
                      }
                    },
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                            widget.marca != null ? 'Actualizar' : 'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                )
              ]
            ]),
          ),
        ),
      ),
    );
  }
}
