import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/components/productos/button_especificacion.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/models/marca.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/models/rama.dart';
import 'package:inventario/models/especificacion.dart';

import 'galeria.dart';

class PagePiso extends StatefulWidget {
  final File foto;
  final Producto producto;
  final String description;
  final String name;
  final String barCode;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final Marca marca;
  final Rama rama;
  final Categoria categoria;

  PagePiso(
      {Key key,
      this.foto,
      this.producto,
      @required this.name,
      @required this.barCode,
      @required this.precioCompra,
      @required this.precioVenta,
      @required this.stock,
      @required this.marca,
      @required this.rama,
      @required this.categoria,
      @required this.description})
      : super(key: key);

  @override
  _PagePisoState createState() => _PagePisoState();
}

class _PagePisoState extends State<PagePiso> {
  final material = TextEditingController();
  final comercialResidencial = TextEditingController();
  final uso = TextEditingController();
  final muroPiso = TextEditingController();
  final acabado = TextEditingController();
  final apariencia = TextEditingController();
  final color = TextEditingController();
  final pei = TextEditingController();
  final promocion = TextEditingController();

  Especificacion espe;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      material.text = widget.producto.material;
      comercialResidencial.text = widget.producto.comercial;
      uso.text = widget.producto.uso;
      muroPiso.text = widget.producto.pisoMuro;
      acabado.text = widget.producto.acabado;
      apariencia.text = widget.producto.apariencia;
      color.text = widget.producto.color;
      pei.text = widget.producto.pei;
      promocion.text = widget.producto.promocion;
    }
    Especificacion.consultarByCategoria(widget.categoria.uid)
        .then((value) => setState(() => (espe = value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto != null ? 'Editar' : 'Agregar'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertConfirma(
                      title: 'Avanzar',
                      cancel: () {},
                      acept: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => PageGaleria(
                                      acabado: acabado.text,
                                      apariencia: apariencia.text,
                                      barCode: widget.barCode,
                                      categoria: widget.categoria,
                                      color: color.text,
                                      comercialResidencial:
                                          comercialResidencial.text,
                                      foto: widget.foto,
                                      marca: widget.marca,
                                      material: material.text,
                                      muroPiso: muroPiso.text,
                                      name: widget.name,
                                      pei: pei.text,
                                      precioCompra: widget.precioCompra,
                                      precioVenta: widget.precioVenta,
                                      producto: widget.producto,
                                      promocion: promocion.text,
                                      rama: widget.rama,
                                      stock: widget.stock,
                                      uso: uso.text,
                                      description: widget.description,
                                    )));
                      },
                    );
                  });
            },
          )
        ],
      ),
      body: espe == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                child: Column(children: [
                  ButtonEspecificacion(
                    controller: material,
                    categoria: espe,
                    especificacion: 'Tipo de material',
                    funcion: (e) => setState(() => material.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: comercialResidencial,
                    categoria: espe,
                    especificacion: 'Comercial/Residencial',
                    funcion: (e) =>
                        setState(() => comercialResidencial.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: uso,
                    categoria: espe,
                    especificacion: 'Uso',
                    funcion: (e) => setState(() => uso.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: muroPiso,
                    categoria: espe,
                    especificacion: 'Piso o muro',
                    funcion: (e) => setState(() => muroPiso.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: acabado,
                    categoria: espe,
                    especificacion: 'Acabado',
                    funcion: (e) => setState(() => acabado.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: apariencia,
                    categoria: espe,
                    especificacion: 'Apariencia',
                    funcion: (e) => setState(() => apariencia.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: color,
                    categoria: espe,
                    especificacion: 'Color',
                    funcion: (e) => setState(() => color.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: pei,
                    categoria: espe,
                    especificacion: 'PEI',
                    funcion: (e) => setState(() => pei.text = e),
                  ),
                  ButtonEspecificacion(
                    controller: promocion,
                    categoria: espe,
                    especificacion: 'Promocion',
                    funcion: (e) => setState(() => promocion.text = e),
                  )
                ]),
              ),
            )),
    );
  }
}
