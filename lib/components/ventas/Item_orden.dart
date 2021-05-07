import 'package:flutter/material.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/models/producto.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/utils/operaciones.dart';
import 'package:inventario/utils/fecha.dart';
import 'package:inventario/pages/ventas/detail.dart';

class ItemOrden extends StatefulWidget {
  final Orden orden;
  final bool isEntrada;
  const ItemOrden({
    Key key,
    @required this.orden,
    @required this.isEntrada,
  }) : super(key: key);

  @override
  _ItemOrdenState createState() => _ItemOrdenState();
}

class _ItemOrdenState extends State<ItemOrden> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () async {
          setState(() => loading = true);
          List<Pedido> pedidos = [];
          for (int i = 0; i < widget.orden.uidPedidos.length; i++) {
            var pedidoTmp =
                await Pedido().consultarPedido(widget.orden.uidPedidos[i]);
            pedidos.add(pedidoTmp);
            var tmp = await Producto().consultarFuture(pedidos[i].uidProducto);
            pedidos[i].producto = tmp;
          }
          Usuario usuario =
              await Usuario().consultarUsuario(widget.orden.uidEncargado);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PageOrdenDetail(
                        isEntrada: widget.isEntrada,
                        orden: widget.orden,
                        usuario: usuario,
                        total:
                            Operaciones.totalPedidos(pedidos, widget.isEntrada),
                        pedidos: pedidos,
                        fecha: widget.orden.fecha,
                      )));
          setState(() => loading = false);
        },
        child: Container(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Text(
                    '${Fecha.fechaTiempo(widget.orden.fecha)}, Prods: ${widget.orden.uidPedidos.length}')));
  }
}
