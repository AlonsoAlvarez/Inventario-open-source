import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/pages/categorias.dart';
import 'package:inventario/pages/empleados.dart';
import 'package:inventario/pages/marcas.dart';
import 'package:inventario/pages/productos.dart';
import 'package:inventario/pages/promociones.dart';
import 'package:inventario/pages/ramas.dart';
import 'package:inventario/pages/settings.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/services/auth.dart';
import 'package:inventario/utils/scan.dart';
import 'package:inventario/pages/ventas.dart';
import 'package:inventario/pages/productos/agregar.dart';
import 'package:inventario/models/producto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DrawerHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 20),
          if (appState.usuario.isAdmin) ...[
            Divider(),
            ListTile(
                title: Text('Promociones'),
                leading: Icon(Icons.art_track),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => PagePromocion()));
                }),
            Divider(),
            ListTile(
              title: Text('Empleados'),
              leading: Icon(Icons.supervised_user_circle),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PageEmpleados()));
              },
            ),
          ],
          Divider(),
          ListTile(
            title: Text('Productos'),
            leading: Icon(Icons.assignment_ind),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PageProductos()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Marcas'),
            leading: Icon(Icons.business_center),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PageMarcas()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Cartegorias'),
            leading: Icon(Icons.category),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PageRamas()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Sub cartegorias'),
            leading: Icon(Icons.category),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PageCategorias()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Ventas'),
            leading: Icon(Icons.shopping_cart),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PageVentas(isEntrada: false)));
            },
          ),
          if (appState.usuario.isAdmin) ...[
            Divider(),
            ListTile(
              title: Text('Entradas'),
              leading: Icon(Icons.add_business),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PageVentas(isEntrada: true)));
              },
            ),
          ],
          Divider(),
          ListTile(
            title: Text('Escanear'),
            leading: Icon(Icons.qr_code),
            onTap: () async {
              String barCode = await scanBarcodeNormal();
              if (barCode != null) {
                Producto prod = await Producto().cosultarBarCode(barCode);
                if (prod == null) {
                  Fluttertoast.showToast(msg: 'Producto no encontrado');
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => PageAgregarPrducto(
                                producto: prod,
                              )));
                }
              }
            },
          ),
          /*
          Divider(),
          ListTile(
            title: Text('Acerca de la app'),
            leading: Transform.rotate(
              child: Icon(
                Icons.error_outline,
              ),
              angle: pi,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PageInfo()));
            },
          ), */
          Divider(),
          ListTile(
              title: Text('Ajustes'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SettingsPage()));
              }),
          Divider(),
          ListTile(
            title: Text('Cerrar sesion'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertConfirma(
                      title: '¿Quieres salir?',
                      acept: () async {
                        await _auth.singOut();
                        appState.setUsuario(null);
                        Fluttertoast.showToast(msg: 'Saliste de la app');
                      },
                      cancel: () {},
                    );
                  });
            },
          ),
        ]),
      ),
    );
  }
}
