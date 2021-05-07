import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/Item.dart';
import 'package:inventario/components/alert_confirmar.dart';
//import 'package:inventario/components/productos/Item.dart';
import 'package:inventario/components/alert_pick.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/models/marca.dart';
import 'package:inventario/models/rama.dart';
//import 'package:inventario/models/categoria.dart';
//import 'package:inventario/models/marca.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/utils/crop_img.dart';
import 'package:inventario/utils/scan.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:provider/provider.dart';

import 'agregar/especificaciones.dart';

class PageAgregarPrducto extends StatefulWidget {
  final Producto producto;

  PageAgregarPrducto({Key key, this.producto}) : super(key: key);

  @override
  _PageAgregarPrductoState createState() => _PageAgregarPrductoState();
}

class _PageAgregarPrductoState extends State<PageAgregarPrducto> {
  final _formKey = GlobalKey<FormState>();
  final nodeDescription = FocusNode();
  final nodeBarCode = FocusNode();
  final nodePrecioCompra = FocusNode();
  final nodePrecioVenta = FocusNode();
  final nodestack = FocusNode();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final barCodeController = TextEditingController();
  final precioCompraController = TextEditingController();
  final precioVentaController = TextEditingController();
  final stockController = TextEditingController();
  final marcaController = TextEditingController();
  final categoriaController = TextEditingController();
  final ramaController = TextEditingController();
  bool loading = false;
  File foto;
  Marca marca;
  Categoria categoria;
  Rama rama;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      nameController.text = widget.producto.name;
      descriptionController.text = widget.producto.description;
      barCodeController.text = widget.producto.barCode;
      precioCompraController.text = widget.producto.precioCompra.toString();
      precioVentaController.text = widget.producto.precioVenta.toString();
      stockController.text = widget.producto.stock.toString();
      if (widget.producto.rama != null) {
        Rama().consultarRama(widget.producto.rama).then((value) {
          rama = value;
          ramaController.text = rama.name;
        });
      } else {
        ramaController.text = "";
      }
      Marca().consultarFuture(widget.producto.marca).then((value) {
        marca = value;
        marcaController.text = marca.name;
      });
      Categoria().consultarFuture(widget.producto.categoria).then((value) {
        categoria = value;
        categoriaController.text = categoria.name;
      });
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
        title: Text(widget.producto != null ? 'Editar' : 'Agregar'),
        actions: [
          if (widget.producto != null && appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertConfirma(
                        title: '¿Eliminar?',
                        cancel: () {},
                        acept: () {
                          deleteFile(widget.producto.url);
                          Producto().delete(widget.producto.uid);
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            )
          ]
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              (widget.producto != null &&
                                  widget.producto.url != null)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertPickImage(
                                    borrar: false,
                                    url: widget.producto != null
                                        ? widget.producto.url
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
                                    : NetworkImage(widget.producto != null
                                        ? widget.producto.url
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
                        labelText: 'NOMBRE',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(nodeDescription);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Nombre del producto';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                readOnly: appState.usuario.isAdmin ? loading : true,
                controller: descriptionController,
                focusNode: nodeDescription,
                decoration: InputDecoration(
                  labelText: 'DESCRIPCION',
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(nodeBarCode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Caracteristicas del producto';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: appState.usuario.isAdmin ? loading : true,
                      controller: barCodeController,
                      focusNode: nodeBarCode,
                      decoration: InputDecoration(
                        labelText: 'BAR CODE',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(nodePrecioCompra);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Codigo de barras';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      scanBarcodeNormal()
                          .then((value) => barCodeController.text = value);
                    },
                  )
                ],
              ),
              Row(
                children: [
                  if (appState.usuario.isAdmin) ...[
                    Expanded(
                      child: TextFormField(
                        readOnly: appState.usuario.isAdmin ? loading : true,
                        controller: precioCompraController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        focusNode: nodePrecioCompra,
                        decoration: InputDecoration(
                          labelText: 'COMPRA',
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(nodePrecioVenta);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Precio compra';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                  Expanded(
                    child: TextFormField(
                      readOnly: appState.usuario.isAdmin ? loading : true,
                      controller: precioVentaController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      focusNode: nodePrecioVenta,
                      decoration: InputDecoration(
                        labelText: 'VENTA',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(nodestack);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Precio venta';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    readOnly: appState.usuario.isAdmin ? loading : true,
                    controller: stockController,
                    focusNode: nodestack,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'STOCK',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Existencias';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: marcaController,
                    decoration: InputDecoration(
                      labelText: 'MARCA',
                    ),
                    onTap: () {
                      if (appState.usuario.isAdmin) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Marcas'),
                                content: Container(
                                    child: StreamBuilder<List<Marca>>(
                                        stream: Marca().marcasStream(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.data.isEmpty) {
                                            return Center(
                                              child: Text('No hay marcas aún'),
                                            );
                                          }
                                          return Container(
                                            height: 300,
                                            child: ListView(
                                              children: [
                                                ...snapshot.data
                                                    .map((e) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          child: Item(
                                                            objeto: e,
                                                            function: () {
                                                              setState(() {
                                                                marca = e;
                                                                marcaController
                                                                        .text =
                                                                    marca.name;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ))
                                              ],
                                            ),
                                          );
                                        })),
                              );
                            });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Marca del producto';
                      }
                      return null;
                    },
                  ),
                ),
              ]),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        readOnly: true,
                        controller: ramaController,
                        decoration: InputDecoration(
                          labelText: 'CATEGORIA',
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                /*
                                List<String> ramas = [
                                  'Pisos y azulejos',
                                  'Baño',
                                  'Cosina',
                                  'Material de instalación'
                                ]; */
                                return AlertDialog(
                                    scrollable: true,
                                    title: Text('Categorias'),
                                    content: FutureBuilder<List<Rama>>(
                                        future: Rama().consultarRamas(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.data.isEmpty) {
                                            return Center(
                                              child:
                                                  Text('No hay categorias aún'),
                                            );
                                          }
                                          return Container(
                                              height: 300,
                                              child: ListView(children: [
                                                //// LAS CATEGORIAS
                                                ...snapshot.data
                                                    .map((e) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 1),
                                                          child: CardRama(
                                                              key: ValueKey(e),
                                                              title: e.name,
                                                              funcion: () =>
                                                                  setState(() {
                                                                    rama = e;
                                                                    ramaController
                                                                            .text =
                                                                        e.name;
                                                                  })),
                                                        ))
                                              ]));
                                        }));
                              });
                        }),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: categoriaController,
                      decoration: InputDecoration(
                        labelText: 'SUB CATEGORIA',
                      ),
                      onTap: () {
                        if (appState.usuario.isAdmin) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text('Sub categorias'),
                                  content: Container(
                                      child: StreamBuilder<List<Categoria>>(
                                          stream:
                                              Categoria().categoriasStream(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            if (snapshot.data.isEmpty) {
                                              return Center(
                                                child: Text(
                                                    'No hay categorias aún'),
                                              );
                                            }
                                            return Container(
                                              height: 300,
                                              child: ListView(
                                                children: [
                                                  ...snapshot.data
                                                      .map((e) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                            child: Item(
                                                              objeto: e,
                                                              function: () {
                                                                setState(() {
                                                                  categoria = e;
                                                                  categoriaController
                                                                          .text =
                                                                      categoria
                                                                          .name;
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ))
                                                ],
                                              ),
                                            );
                                          })),
                                );
                              });
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Sub categoria del producto';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (appState.usuario.isAdmin) ...[
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blueGrey[800],
                    onPressed: () async {
                      double buy = double.tryParse(precioCompraController.text);
                      double sell = double.tryParse(precioVentaController.text);
                      int stock = int.tryParse(stockController.text);
                      if (_formKey.currentState.validate() &&
                          buy != null &&
                          sell != null &&
                          stock != null &&
                          (foto != null || widget.producto != null) &&
                          categoria != null &&
                          marca != null &&
                          rama != null) {
                        void tmp() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => PagePiso(
                                        description: descriptionController.text,
                                        barCode: barCodeController.text,
                                        categoria: categoria,
                                        marca: marca,
                                        name: nameController.text,
                                        precioCompra: buy,
                                        precioVenta: sell,
                                        rama: rama,
                                        foto: foto,
                                        stock: stock,
                                        producto: widget.producto,
                                      )));
                        }

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertConfirma(
                                title: '¿Avanzar?', // widget.producto != null
                                //  ? '¿Actualizar?'
                                //  : '¿Guardar?',
                                cancel: () {},
                                acept: () {
                                  tmp();
                                  /*
                                  setState(() => loading = true);
                                  String url2 = foto != null
                                      ? await uploadPicture(
                                          foto,
                                          '${nameController.text}',
                                          Folder.productos)
                                      : widget.producto.url;
                                  Rama().agregarCategoriaRama(
                                      rama.uid, categoria.uid);
                                  Producto tmp = Producto(
                                      barCode: barCodeController.text,
                                      url: url2,
                                      stock: stock,
                                      precioVenta: sell,
                                      precioCompra: buy,
                                      name: nameController.text,
                                      description: descriptionController.text,
                                      rama: rama.uid,
                                      marca: marca.uid,
                                      categoria: categoria.uid);
                                  if (widget.producto != null) {
                                    Producto()
                                        .update(widget.producto.uid, tmp.toMap);
                                    Fluttertoast.showToast(msg: 'Actualizado');
                                  } else {
                                    Producto().create(tmp.toMap);
                                    Fluttertoast.showToast(msg: 'Guardado');
                                  }
                                  setState(() => loading = false);
                                  Navigator.pop(context); */
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
                            'Avanzar', //widget.producto != null ? 'Actualizar' : 'Guardar',
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

class CardRama extends StatelessWidget {
  final String title;
  final Function funcion;

  const CardRama({
    Key key,
    @required this.title,
    @required this.funcion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () {
          funcion();
          Navigator.pop(context);
        },
        child: Text('$title'));
  }
}
