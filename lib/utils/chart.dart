import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:inventario/models/linea.dart';

Series<LinearSales, int> lineaGrafica(List<int> puntos, String id) {
  return _linea(_puntosGrafica(puntos), id);
}

Series<LinearSales, int> _linea(List<LinearSales> data, String id) {
  return Series<LinearSales, int>(
    id: id,
    colorFn: (_, __) => _random(),
    domainFn: (LinearSales sales, _) => sales.year,
    measureFn: (LinearSales sales, _) => sales.sales,
    data: data,
  );
}

List<LinearSales> _puntosGrafica(List<int> puntos) {
  List<LinearSales> res = [];
  int i = 0;
  puntos.forEach((e) {
    res.add(LinearSales(i, e));
    i++;
  });
  return res;
}

// ignore: missing_return
Color _random() {
  Random r = new Random();
  int n = r.nextInt(8);
  switch (n) {
    case 0:
      return MaterialPalette.blue.shadeDefault;
      break;
    case 1:
      return MaterialPalette.cyan.shadeDefault;
      break;
    case 2:
      return MaterialPalette.deepOrange.shadeDefault;
      break;
    case 3:
      return MaterialPalette.deepOrange.shadeDefault;
      break;
    case 4:
      return MaterialPalette.green.shadeDefault;
      break;
    case 5:
      return MaterialPalette.purple.shadeDefault;
      break;
    case 6:
      return MaterialPalette.pink.shadeDefault;
      break;
    case 7:
      return MaterialPalette.red.shadeDefault;
      break;
    case 8:
      return MaterialPalette.yellow.shadeDefault;
      break;
  }
}

String genHexRan() {
  Random r = new Random();
  String res = "";
  for (int i = 0; i < 6; i++) {
    int n = r.nextInt(15);
    if (n < 10) {
      res += '$n';
    } else {
      if (n == 10) {
        res += "a";
      }
      if (n == 11) {
        res += "b";
      }
      if (n == 12) {
        res += "c";
      }
      if (n == 13) {
        res += "d";
      }
      if (n == 14) {
        res += "e";
      }
      if (n == 15) {
        res += "f";
      }
    }
  }
  return res;
}
