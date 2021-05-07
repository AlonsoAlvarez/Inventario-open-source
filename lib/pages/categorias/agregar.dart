import 'package:flutter/material.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/utils/crop_img.dart';
import 'dart:io';
import 'dart:math';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/components/alert_info.dart';
import 'package:inventario/components/alert_pick.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'especificaciones/agregar.dart';

class PageAgregarCategoria extends StatefulWidget {
  final Categoria categoria;

  const PageAgregarCategoria({Key key, this.categoria}) : super(key: key);
  @override
  _PageAgregarCategoriaState createState() => _PageAgregarCategoriaState();
}

class _PageAgregarCategoriaState extends State<PageAgregarCategoria> {
  final _formKey = GlobalKey<FormState>();
  final nodeDescription = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File foto;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      nameController.text = widget.categoria.name;
      descriptionController.text = widget.categoria.description;
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
        title: Text(widget.categoria != null ? 'Editar' : 'Agregar'),
        actions: [
          if (widget.categoria != null && appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () async {
                List tmp =
                    await Categoria().productosCategoria(widget.categoria.uid);
                if (tmp.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertConfirma(
                          title: '¿Eliminar?',
                          cancel: () {},
                          acept: () {
                            deleteFile(widget.categoria.url);
                            Categoria().delete(widget.categoria.uid);
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
                              'No se puede borrar por que hay ${tmp.length} productos referenciados a la categoria ${widget.categoria.name}',
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
                              (widget.categoria != null &&
                                  widget.categoria.url != null)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertPickImage(
                                    borrar: false,
                                    url: widget.categoria != null
                                        ? widget.categoria.url
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
                                    : NetworkImage(widget.categoria != null
                                        ? widget.categoria.url
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
                        labelText: 'CATEGORIA',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(nodeDescription);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nombre de categoria';
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
                          return 'Descripcion de categoría';
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
                                  'En este apartado colocar descripcion de la categoria, Ej: Azulejos, Exteriores, Grest',
                            );
                          });
                    },
                  )
                ],
              ),
              if (appState.usuario.isAdmin) ...[
                SizedBox(height: 10),
                RaisedButton(
                    child: Text('Ir a especificaciones'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PageAgregarEspecificaciones(
                                    categoria: widget.categoria,
                                  )));
                    }),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blueGrey[800],
                    onPressed: () async {
                      if (_formKey.currentState.validate() &&
                          (foto != null || widget.categoria != null)) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertConfirma(
                                title: widget.categoria != null
                                    ? '¿Actualizar?'
                                    : '¿Guardar?',
                                cancel: () {},
                                acept: () async {
                                  setState(() => loading = true);
                                  String url2 = foto != null
                                      ? await uploadPicture(
                                          foto,
                                          '${nameController.text}',
                                          Folder.categorias)
                                      : widget.categoria.url;
                                  Categoria tmp = Categoria(
                                    url: url2,
                                    name: nameController.text,
                                    description: descriptionController.text,
                                  );
                                  if (widget.categoria != null) {
                                    Categoria().update(
                                        widget.categoria.uid, tmp.toMap);
                                    Fluttertoast.showToast(msg: 'Actualizado');
                                  } else {
                                    Categoria().create(tmp.toMap);
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
                            widget.categoria != null ? 'Actualizar' : 'Guardar',
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
