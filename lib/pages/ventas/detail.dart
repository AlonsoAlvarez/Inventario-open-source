import 'package:flutter/material.dart';
import 'package:inventario/icons_extra_icons.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/utils/fecha.dart';
import 'package:inventario/components/ventas/item_pedido.dart';
import 'package:inventario/components/ventas/detail/alert_share.dart';
import 'package:inventario/utils/launcher.dart';

class PageOrdenDetail extends StatelessWidget {
  final List<Pedido> pedidos;
  final DateTime fecha;
  final Usuario usuario;
  final double total;
  final Orden orden;
  final bool isEntrada;

  const PageOrdenDetail(
      {Key key,
      @required this.pedidos,
      @required this.fecha,
      @required this.total,
      @required this.usuario,
      @required this.orden,
      @required this.isEntrada})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Fecha.fechaTiempo(fecha)}'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertShare(
                      orden: orden,
                      isEntrada: isEntrada,
                      usuario: usuario,
                      fecha: fecha,
                      total: total,
                      pedidos: pedidos,
                    );
                  });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              ...pedidos.map((e) => Column(
                    children: [
                      ItemPedido(
                        isEntrada: isEntrada,
                        pedido: e,
                        key: ValueKey('${e.uid.id}'),
                      ),
                      Divider(),
                    ],
                  )),
              RichText(
                  text: TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                    TextSpan(
                        text: '\$$total',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w300,
                        ))
                  ])),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                        text: TextSpan(
                            text: 'Encargado: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                          TextSpan(
                              text: usuario != null
                                  ? '\n ${usuario.name}\n ${usuario.email}\n ${usuario.phone}'
                                  : 'Eliminado',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ))
                        ])),
                  ),
                  if (usuario != null) ...[
                    IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blueAccent[200],
                      ),
                      onPressed: () async {
                        await launchCall(usuario.phone);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        IconsExtra.whatsapp,
                        color: Colors.green[400],
                      ),
                      onPressed: () async {
                        await launchWP(usuario.phone);
                      },
                    ),
                  ]
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
