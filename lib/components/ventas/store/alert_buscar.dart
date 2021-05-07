import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/Item.dart';
import 'package:inventario/models/categoria.dart';
import 'package:inventario/models/marca.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/providers/venta_state.dart';
import 'package:inventario/utils/scan.dart';
import 'package:provider/provider.dart';

class AlertBuscar extends StatefulWidget {
  @override
  _AlertBuscarState createState() => _AlertBuscarState();
}

class _AlertBuscarState extends State<AlertBuscar> {
  Marca marca;
  Categoria categoria;
  bool isMarca = false;
  bool isCategoria = false;
  final ctrlSearch = TextEditingController();
  final ctrlMarca = TextEditingController(text: 'Todas');
  final ctrlCategoria = TextEditingController(text: 'Todas');
  @override
  Widget build(BuildContext context) {
    final ventaState = Provider.of<VentaState>(context);
    return AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrlSearch,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'BUSCAR',
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.qr_code),
                onPressed: () async {
                  String barCode = await scanBarcodeNormal();
                  if (barCode != null) {
                    Producto prod = await Producto().cosultarBarCode(barCode);
                    if (prod == null) {
                      Fluttertoast.showToast(msg: 'Producto no encontrado');
                    } else {
                      ventaState.agregar(Pedido(producto: prod, cantidad: 1));
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
          if (!isMarca && !isCategoria) ...[
            Row(
              children: [
                Expanded(
                    child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'MARCA'),
                  controller: ctrlMarca,
                  onTap: () {
                    setState(() => isMarca = true);
                  },
                )),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'CATEGORIA'),
                  controller: ctrlCategoria,
                  onTap: () {
                    setState(() => isCategoria = true);
                  },
                )),
              ],
            ),
          ] else ...[
            SizedBox(height: 10),
            Text(isCategoria ? 'Selecciona categoría' : 'Selecciona Marca')
          ]
        ],
      ),
      content: Container(
          height: 300,
          child: (!isMarca && !isCategoria)
              ? FutureBuilder<List<Producto>>(
                  future: Producto().productosFiltro(
                      ctrlSearch.text,
                      marca != null ? marca.uid : null,
                      categoria != null ? categoria.uid : null),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data.isEmpty) {
                      return Center(child: Text('No hay coincidencias'));
                    }
                    return SingleChildScrollView(
                      child: Column(children: [
                        ...snapshot.data.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Item(
                                objeto: e,
                                function: () {
                                  ventaState.agregar(
                                      Pedido(producto: e, cantidad: 1));
                                  Navigator.pop(context);
                                },
                              ),
                            ))
                      ]),
                    );
                  })
              : isMarca
                  ? FutureBuilder<List<Marca>>(
                      future: Marca().marcasFiltro(ctrlSearch.text),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data.isEmpty) {
                          return Center(child: Text('No hay coincidencias'));
                        }
                        return SingleChildScrollView(
                          child: Column(children: [
                            /*
                            RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    isMarca = false;
                                    marca = null;
                                    ctrlMarca.text = 'Todas';
                                  });
                                },
                                child: Text('TODAS')), */
                            ...snapshot.data.map((e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Item(
                                    objeto: e,
                                    function: () {
                                      setState(() {
                                        isMarca = false;
                                        marca = e;
                                        ctrlMarca.text = e.name;
                                      });
                                    },
                                  ),
                                ))
                          ]),
                        );
                      })
                  : FutureBuilder<List<Categoria>>(
                      future: Categoria().categoriasFiltro(ctrlSearch.text),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data.isEmpty) {
                          return Center(child: Text('No hay coincidencias'));
                        }
                        return SingleChildScrollView(
                          child: Column(children: [
                            ...snapshot.data.map((e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Item(
                                    objeto: e,
                                    function: () {
                                      setState(() {
                                        isCategoria = false;
                                        categoria = e;
                                        ctrlCategoria.text = e.name;
                                      });
                                    },
                                  ),
                                ))
                          ]),
                        );
                      })),
    );
  }
}
