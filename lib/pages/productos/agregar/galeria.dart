import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/components/alert_pick.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/models/marca.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/models/rama.dart';
import 'package:inventario/utils/crop_img.dart';
import 'package:inventario/utils/subir_file.dart';

class PageGaleria extends StatefulWidget {
  final File foto;
  final Producto producto;
  final String name;
  final String description;
  final String barCode;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final Marca marca;
  final Rama rama;
  final Categoria categoria;
  final String material;
  final String comercialResidencial;
  final String uso;
  final String muroPiso;
  final String acabado;
  final String apariencia;
  final String color;
  final String pei;
  final String promocion;

  const PageGaleria(
      {Key key,
      @required this.producto,
      @required this.foto,
      @required this.name,
      @required this.barCode,
      @required this.precioCompra,
      @required this.precioVenta,
      @required this.stock,
      @required this.marca,
      @required this.rama,
      @required this.categoria,
      @required this.material,
      @required this.comercialResidencial,
      @required this.uso,
      @required this.muroPiso,
      @required this.acabado,
      @required this.apariencia,
      @required this.color,
      @required this.pei,
      @required this.promocion,
      @required this.description})
      : super(key: key);

  @override
  _PageGaleriaState createState() => _PageGaleriaState();
}

class _PageGaleriaState extends State<PageGaleria> {
  List<File> fotos = [];
  List urls = [];
  List<String> removidos = [];

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      urls = widget.producto.urlsFotos;
    }
  }

  void borrarUrl(String url) {
    removidos.add(url);
    setState(() => urls.remove(url));
  }

  void borrarFile(File foto) {
    setState(() => fotos.remove(foto));
  }

  void cortarFile(File foto) {
    cropImage(foto).then((value) => setState(() {
          fotos.add(value);
          fotos.remove(foto);
        }));
  }

  void tomarFotoUrl(String url) {
    pickedFile().then((value) => setState(() {
          fotos.add(value);
          urls.remove(url);
        }));
  }

  void tomarFotoFile(File foto) {
    pickedFile().then((value) => setState(() {
          fotos.add(value);
          fotos.remove(foto);
        }));
  }

  int contador = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.producto != null ? 'Editar' : 'Agregar'),
          actions: [
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () async {
                File tmp = await pickedFile();
                setState(() => fotos.add(tmp));
              },
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertConfirma(
                        title:
                            widget.producto != null ? 'Actualizar' : 'Agregar',
                        cancel: () {},
                        acept: () async {
                          setState(() => loading = true);
                          removidos.forEach((e) async {
                            await deleteFile(e);
                          });
                          if (0 < fotos.length) {
                            for (int i = 0; i < fotos.length; i++) {
                              urls.add(await uploadPicture(
                                  fotos[i],
                                  '${widget.name}_galery_$i',
                                  Folder.productos));
                              setState(() => contador = i);
                            }
                          }
                          Rama().agregarCategoriaRama(
                              widget.rama.uid, widget.categoria.uid);
                          String url2 = widget.foto != null
                              ? uploadPicture(widget.foto, '${widget.name}',
                                  Folder.productos)
                              : widget.producto.url;
                          Producto tmpProd = Producto(
                              barCode: widget.barCode,
                              url: url2,
                              stock: widget.stock,
                              precioVenta: widget.precioVenta,
                              precioCompra: widget.precioCompra,
                              name: widget.name,
                              description: widget.description,
                              rama: widget.rama.uid,
                              marca: widget.marca.uid,
                              categoria: widget.categoria.uid,
                              uso: widget.uso,
                              acabado: widget.acabado,
                              apariencia: widget.apariencia,
                              color: widget.color,
                              comercial: widget.comercialResidencial,
                              material: widget.material,
                              pei: widget.pei,
                              pisoMuro: widget.muroPiso,
                              promocion: widget.promocion,
                              urlsFotos: urls);
                          if (widget.producto != null) {
                            Producto()
                                .update(widget.producto.uid, tmpProd.toMap);
                            Fluttertoast.showToast(msg: 'Actualizado');
                          } else {
                            Producto().create(tmpProd.toMap);
                            Fluttertoast.showToast(msg: 'Guardado');
                          }
                          setState(() => loading = false);
                          Navigator.pop(context);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    });
              },
            )
          ],
        ),
        body: loading
            ? Center(
                child: Column(children: [
                SizedBox(height: 150),
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Subiendo galeria: $contador de ${fotos.length}'),
              ]))
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(children: [
                      ...urls.map((e) => ButtonImagen(
                          key: ValueKey(e),
                          url: e,
                          borrarUrl: () => borrarUrl(e),
                          pick: () => tomarFotoUrl(e))),
                      ...fotos.map((e) => ButtonImagen(
                            key: ValueKey(e.path),
                            borrarFile: () => borrarFile(e),
                            foto: e,
                            cortar: () => cortarFile(e),
                            pick: () => tomarFotoFile(e),
                          ))
                    ]),
                  ),
                ),
              ));
  }
}

class ButtonImagen extends StatelessWidget {
  final File foto;
  final String url;
  final Function borrarUrl;
  final Function borrarFile;
  final Function cortar;
  final Function pick;

  const ButtonImagen({
    Key key,
    this.foto,
    this.url,
    this.borrarUrl,
    this.borrarFile,
    this.cortar,
    this.pick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        child: Hero(
          tag: url ?? foto.path,
          child: Container(
              height: 150,
              color: Colors.white,
              child: FadeInImage(
                image: foto != null ? FileImage(foto) : NetworkImage(url),
                placeholder: AssetImage('assets/camara.png'),
              )),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertPickImage(
                    borrar: true,
                    crop: cortar,
                    delete: url != null ? borrarUrl : borrarFile,
                    foto: foto,
                    pick: pick,
                    tagHero: url ?? foto.path,
                    url: url);
              });
        },
      ),
    );
  }
}
