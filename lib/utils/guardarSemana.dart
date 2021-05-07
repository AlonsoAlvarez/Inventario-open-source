import 'dart:io';

import 'package:inventario/models/orden.dart';
import 'package:inventario/utils/csv.dart';
import 'package:inventario/utils/subir_file.dart';

Future<void> guradarSemana(List<Orden> ordenes) async {
  DateTime hoy = DateTime.now();
  DateTime inicio = DateTime(hoy.year, hoy.month, hoy.day);
  DateTime termino = DateTime(hoy.year, hoy.month, hoy.day, 23, 59, 59, 59, 59);
  switch (hoy.weekday) {
    case DateTime.sunday:
      inicio = inicio.subtract(Duration(days: 7));
      termino = termino.subtract(Duration(days: 1));
      break;
    case DateTime.monday:
      inicio = inicio.subtract(Duration(days: 8));
      termino = termino.subtract(Duration(days: 2));
      break;
    case DateTime.tuesday:
      inicio = inicio.subtract(Duration(days: 9));
      termino = termino.subtract(Duration(days: 3));
      break;
    case DateTime.wednesday:
      inicio = inicio.subtract(Duration(days: 10));
      termino = termino.subtract(Duration(days: 4));
      break;
    case DateTime.thursday:
      inicio = inicio.subtract(Duration(days: 11));
      termino = termino.subtract(Duration(days: 5));
      break;
    case DateTime.friday:
      inicio = inicio.subtract(Duration(days: 12));
      termino = termino.subtract(Duration(days: 6));
      break;
    case DateTime.saturday:
      inicio = inicio.subtract(Duration(days: 13));
      termino = termino.subtract(Duration(days: 7));
      break;
    default:
      break;
  }

  List<Orden> tmp = [];
  ordenes.forEach((e) {
    if (e.fecha.isAfter(inicio) && e.fecha.isBefore(termino)) {
      tmp.add(e);
    }
  });
  if (0 < tmp.length) {
    // crear CSV con los productos
    File csv = await CSV.ordenesSemana(tmp, inicio, termino);
    await uploadFile(
        csv,
        '${inicio.day}_${inicio.month}-${termino.day}_${termino.month}.csv',
        Folder.semanas);
    // actualizar productos que digan salvados
    for (int i = 0; i < tmp.length; i++) {
      tmp[i].uid.update({'salvado': true});
    }
  }
}
