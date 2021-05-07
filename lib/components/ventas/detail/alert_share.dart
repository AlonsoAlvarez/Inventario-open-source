import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/pages/ventas/crear_pdf.dart';
import 'package:inventario/utils/csv.dart';
import 'package:inventario/models/pedido.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:inventario/providers/orders_state.dart';
import 'package:provider/provider.dart';

class AlertShare extends StatelessWidget {
  final List<Pedido> pedidos;
  final double total;
  final DateTime fecha;
  final Usuario usuario;
  final Orden orden;
  final bool isEntrada;

  const AlertShare(
      {Key key,
      @required this.pedidos,
      @required this.total,
      @required this.fecha,
      @required this.usuario,
      @required this.orden,
      @required this.isEntrada})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ordersState = Provider.of<OrdersState>(context);
    return AlertDialog(
      title: Text('Compartir'),
      content: Container(
          child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            child: ButtonFile(
              asset: 'assets/csv1.png',
              function: () async {
                bool borrados = false;
                for (int i = 0; i < pedidos.length; i++) {
                  if (pedidos[i].producto == null) {
                    borrados = true;
                    break;
                  }
                }
                if (!borrados) {
                  File csv = await CSV.createCSV(
                      pedidos, total, fecha, usuario, isEntrada);
                  Share.shareFiles([csv.path], text: 'Tabla de registros');
                } else {
                  Fluttertoast.showToast(msg: 'No se puede crear');
                }
                Navigator.pop(context);
              },
            ),
          ),
          Spacer(),
          Container(
            height: 100,
            width: 100,
            child: ButtonFile(
              asset: 'assets/pdf1.png',
              function: () async {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageCreatePDF(
                              nota: isEntrada
                                  ? ordersState.notasEntrada + 1
                                  : ordersState.notasVenta + 1,
                              isEntrada: isEntrada,
                              orden: orden,
                              pedidos: pedidos,
                            )));
              },
            ),
          )
        ],
      )),
    );
  }
}

class ButtonFile extends StatefulWidget {
  const ButtonFile({
    Key key,
    @required this.function,
    @required this.asset,
  }) : super(key: key);

  final Function function;
  final String asset;
  @override
  _ButtonFileState createState() => _ButtonFileState();
}

class _ButtonFileState extends State<ButtonFile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: loading
          ? Center(child: CircularProgressIndicator())
          : Image.asset(widget.asset),
      onPressed: () {
        setState(() => loading = true);
        widget.function();
        setState(() => loading = false);
      },
      color: Colors.white,
    );
  }
}
