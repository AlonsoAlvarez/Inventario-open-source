import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventario/providers/ajustes.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/providers/venta_state.dart';
import 'package:inventario/services/wrapped.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/orders_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: VentaState()),
    ChangeNotifierProvider.value(value: OrdersState()),
    ChangeNotifierProvider.value(value: AppState()),
    ChangeNotifierProvider.value(value: Ajustes())
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Ajustes ajustes = Ajustes();
  Color tema = Colors.red;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((vaule) {
      setState(() {
        ajustes.prefs = vaule;
        ajustes.cargarColor();
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ajustes = Provider.of<Ajustes>(context);
    return MaterialApp(
      title: 'Inventario',
      theme: ThemeData(
        primarySwatch: ajustes.color,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Wrapped(),
    );
  }
}
