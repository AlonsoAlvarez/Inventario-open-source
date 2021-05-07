import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/pages/ventas/pdf_view.dart';
import 'package:inventario/utils/fecha.dart';
import 'package:inventario/utils/pdf.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inventario/components/alert_info.dart';
import 'package:pdf/pdf.dart';

class PageCreatePDF extends StatefulWidget {
  final List<Pedido> pedidos;
  final Orden orden;
  final bool isEntrada;
  final int nota;

  PageCreatePDF(
      {Key key,
      @required this.pedidos,
      @required this.orden,
      @required this.isEntrada,
      @required this.nota})
      : super(key: key);

  @override
  _PageCreatePDFState createState() => _PageCreatePDFState();
}

class _PageCreatePDFState extends State<PageCreatePDF> {
  final _formKey = GlobalKey<FormState>();
  final _clienteNode = FocusNode();
  final _direccionNode = FocusNode();
  final _phoneNode = FocusNode();
  final _sucursalNode = FocusNode();
  final _tipoNode = FocusNode();
  final _estatusNode = FocusNode();
  final _sucursalController = TextEditingController(text: 'MATRIZ');
  final _clienteController = TextEditingController();
  final _direccionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _numeroController = TextEditingController();
  final _tipoController = TextEditingController();
  final _estatusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoController.text = widget.isEntrada ? 'Pedido' : 'Venta';
    _numeroController.text = '${widget.nota}';
  }

  bool loading = false;
  bool loadingPDF = false;
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.orden.urlPDF != null || file != null)
            ? 'Actualizar PDF'
            : 'Crear PDF'),
        actions: [
          if (widget.orden.urlPDF != null || file != null) ...[
            if (loadingPDF) ...[
              Center(
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white))
            ] else ...[
              IconButton(
                  icon: Icon(Icons.picture_as_pdf),
                  onPressed: () async {
                    if (file == null) {
                      setState(() => loadingPDF = true);
                      file = await getFileFromUrl(widget.orden.urlPDF);
                      setState(() => loadingPDF = false);
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFScreen(path: file.path)));
                  })
            ]
          ]
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      readOnly: false,
                      controller: _numeroController,
                      decoration: InputDecoration(labelText: 'NUMERO'),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_tipoNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Numero de nota';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      readOnly: false,
                      focusNode: _tipoNode,
                      controller: _tipoController,
                      decoration: InputDecoration(
                          labelText: 'TIPO', hintText: 'Ej: Venta, Pedido'),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_sucursalNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Numero de nota';
                        }
                        return null;
                      },
                    ),
                  )
                ]),
                TextFormField(
                  readOnly: false,
                  controller: _sucursalController,
                  focusNode: _sucursalNode,
                  decoration: InputDecoration(
                      labelText: 'SUCURSAL', hintText: 'Ej: Matriz, Bodega'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_estatusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Sucursal a la que corresponde';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: false,
                        controller: _estatusController,
                        focusNode: _estatusNode,
                        decoration: InputDecoration(
                            labelText: 'ESTATUS',
                            hintText: 'Ej: Pagado, Restan \$240'),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_clienteNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Estatus de la orden';
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
                                    'En este apartado colocar el estatus actual de la orden Ej: Pagado, Adelanto de 390 Restan 110, etc.',
                              );
                            });
                      },
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  widget.isEntrada ? 'Datos del Provedor' : 'Datos del Cliente',
                  style: TextStyle(fontSize: 20),
                ),
                TextFormField(
                  readOnly: false,
                  controller: _clienteController,
                  decoration: InputDecoration(
                      labelText: widget.isEntrada ? 'PROVEDOR' : 'CLIENTE'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_direccionNode);
                  },
                  focusNode: _clienteNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return widget.isEntrada
                          ? 'Nombre del provedor'
                          : 'Nombre del cliente';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: false,
                  controller: _direccionController,
                  decoration: InputDecoration(labelText: 'DIRECCION'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phoneNode);
                  },
                  focusNode: _direccionNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Direccion del cliente';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: false,
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'TELEFONO'),
                  focusNode: _phoneNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Telefono del cliente';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.blueGrey[800],
                    onPressed: () async {
                      bool borrados = false;
                      for (int i = 0; i < widget.pedidos.length; i++) {
                        if (widget.pedidos[i].producto == null) {
                          borrados = true;
                          break;
                        }
                      }
                      if (!borrados) {
                        int numero = int.tryParse(_numeroController.text);
                        if (_formKey.currentState.validate() &&
                            numero != null) {
                          setState(() => loading = true);
                          Uint8List data = await generateInvoice(
                              PdfPageFormat.a4,
                              numero,
                              _sucursalController.text,
                              _clienteController.text,
                              _direccionController.text,
                              _phoneController.text,
                              _tipoController.text,
                              widget.pedidos,
                              widget.isEntrada,
                              _estatusController.text);
                          final dir = await getApplicationDocumentsDirectory();
                          final name =
                              '${dir.path}/Recivo_${Fecha.fechaHoraFiles(DateTime.now())}.pdf';
                          File pdf = File(name);
                          await pdf.writeAsBytes(data);
                          String urlPDF = await uploadFile(
                              pdf,
                              'Recivo_',
                              widget.isEntrada
                                  ? Folder.entradas
                                  : Folder.ventas);
                          await widget.orden.uid.update({'urlPDF': urlPDF});
                          Fluttertoast.showToast(
                              msg: (widget.orden.urlPDF != null || file != null)
                                  ? 'Actualizado'
                                  : 'Guardado');
                          setState(() {
                            file = pdf;
                            loading = false;
                          });
                        } else {
                          Fluttertoast.showToast(msg: 'Datos incompletos');
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'No se puede crear');
                      }
                    },
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                            (widget.orden.urlPDF != null || file != null)
                                ? 'Actualizar'
                                : 'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
