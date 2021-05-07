import 'package:flutter/material.dart';
import 'package:inventario/components/home/chart.dart';
import 'package:inventario/components/home/drawer.dart';
import 'package:inventario/components/home/item_history.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/providers/orders_state.dart';
import 'package:inventario/utils/guardarSemana.dart';
import 'package:provider/provider.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  bool ingresos = true;
  bool hoy = false;
  bool verificado = false;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final ordersState = Provider.of<OrdersState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: DrawerHome(),
      body: !appState.usuario.isAdmin
          ? Center(child: Image.asset('assets/bg.png'))
          : StreamBuilder<List<Orden>>(
              stream: Orden().ordenesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.isEmpty || snapshot.hasError) {
                  return Center(
                      child: Text(
                          ingresos
                              ? 'No Tienes ingresos aún'
                              : 'No Tienes ventas aún',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)));
                }
                ordersState.setOrders(snapshot.data);
                if (!verificado) {
                  guradarSemana(snapshot.data);
                  verificado = true;
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/bg.png'))),
                          child: ChartHome(
                            title: ingresos
                                ? 'INGRESOS' + (hoy ? ' HOY' : '')
                                : 'VENTAS' + (hoy ? ' HOY' : ''),
                            animate: true,
                            seriesList: ingresos
                                ? hoy
                                    ? [ordersState.ingresosHoy]
                                    : [ordersState.ingresos]
                                : hoy
                                    ? [ordersState.ventasHoy]
                                    : [ordersState.ventas],
                          ),
                        ),
                        Divider(),
                        if (ingresos &&
                            ordersState.ingresosHistory != null) ...[
                          if (!hoy) ...[
                            ...ordersState.ingresosHistory
                                .map((e) => ItemHistory(
                                      isHoy: hoy,
                                      history: e,
                                      isMoney: true,
                                    ))
                          ] else ...[
                            ...ordersState.ingresosHistoryHoy
                                .map((e) => ItemHistory(
                                      isHoy: hoy,
                                      history: e,
                                      isMoney: true,
                                    ))
                          ]
                        ],
                        if (!ingresos && ordersState.ventasHistory != null) ...[
                          if (!hoy) ...[
                            ...ordersState.ventasHistory.map((e) => ItemHistory(
                                  isHoy: hoy,
                                  history: e,
                                  isMoney: false,
                                ))
                          ] else ...[
                            ...ordersState.ventasHistoryHoy
                                .map((e) => ItemHistory(
                                      isHoy: hoy,
                                      history: e,
                                      isMoney: false,
                                    ))
                          ]
                        ]
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: !appState.usuario.isAdmin
          ? Container()
          : FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blueGrey[800],
              child:
                  Icon(ingresos ? Icons.book : Icons.monetization_on_outlined),
              tooltip: ingresos ? 'Ver ventas' : 'Ver ingresos',
              onPressed: () {
                setState(() {
                  if (ingresos && hoy /* ingresos de hoy */) {
                    /* ventas de hoy */
                    ingresos = false;
                  } else {
                    if (!ingresos && hoy /* ventas de hoy */) {
                      /* ingresos de todo */
                      ingresos = true;
                      hoy = false;
                    } else {
                      if (ingresos && !hoy /* ingresos de todo */) {
                        /* ventas de todo */
                        ingresos = false;
                      } else {
                        if (!ingresos && !hoy /* ventas de todo */) {
                          /* ingresos de hoy */
                          ingresos = true;
                          hoy = true;
                        }
                      }
                    }
                  }
                });
              },
            ),
    );
  }
}
