import 'dart:io';

import 'package:csv/csv.dart';
import 'package:inventario/models/orden.dart';
import 'package:inventario/models/pedido.dart';
import 'package:inventario/models/usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inventario/utils/fecha.dart';

class CSV {
  CSV._();

  static Future<File> createUsuario(Usuario usuario) async {
    List<List<String>> csvData = [
      ['Nombre', '${usuario.name}'],
      ['Telefono', '${usuario.phone}'],
      ['Email', '${usuario.email}'],
      ['Password', '${usuario.password}'],
    ];
    String csv = const ListToCsvConverter().convert(csvData);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/${_name(DateTime.now())}.csv';
    final File file = File(path);
    await file.writeAsString(csv);
    return file;
  }

  static Future<File> createCSV(List<Pedido> pedidos, double total,
      DateTime fecha, Usuario usuario, bool isEntrada) async {
    List<List<String>> res = [];
    int pcs = 0;
    for (int i = 0; i < pedidos.length; i++) {
      double precio = isEntrada
          ? pedidos[i].producto.precioCompra
          : pedidos[i].producto.precioVenta;
      var tmp = <String>[
        pedidos[i].producto.name,
        pedidos[i].producto.description,
        pedidos[i].cantidad.toString(),
        precio.toString(),
        (pedidos[i].cantidad * precio).toString()
      ];
      pcs += pedidos[i].cantidad;
      res.add(tmp);
    }
    List<List<String>> csvData = [
      ['Fecha', '${Fecha.fecha(fecha)}', 'Hora', '${Fecha.hora(fecha)}'],
      usuario == null
          ? ['Cuenta eliminada', '', '', '']
          : [
              'Encargado',
              '${usuario.name}',
              '${usuario.phone}',
              '${usuario.email}'
            ],
      ['Producto', 'Descripcion', 'Piezas', 'Precio Unit', 'Parcial'],
      ...res,
      ['', 'Piezas', '$pcs', 'Total', '$total']
    ];
    String csv = const ListToCsvConverter().convert(csvData);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/${_name(DateTime.now())}.csv';
    final File file = File(path);
    await file.writeAsString(csv);
    return file;
  }

  static Future<File> ordenesSemana(
      List<Orden> ordenes, DateTime inicio, DateTime termino) async {
    List<Orden> domingo = [];
    List<Orden> lunes = [];
    List<Orden> martes = [];
    List<Orden> miercoles = [];
    List<Orden> jueves = [];
    List<Orden> viernes = [];
    List<Orden> sabado = [];

    ordenes.forEach((e) {
      switch (e.fecha.weekday) {
        case DateTime.sunday:
          domingo.add(e);
          break;
        case DateTime.monday:
          lunes.add(e);
          break;
        case DateTime.tuesday:
          martes.add(e);
          break;
        case DateTime.wednesday:
          miercoles.add(e);
          break;
        case DateTime.thursday:
          jueves.add(e);
          break;
        case DateTime.friday:
          viernes.add(e);
          break;
        case DateTime.saturday:
          sabado.add(e);
          break;
        default:
          break;
      }
    });

    int cantidad = 0;

    if (cantidad < domingo.length) cantidad = domingo.length;
    if (cantidad < lunes.length) cantidad = lunes.length;
    if (cantidad < martes.length) cantidad = martes.length;
    if (cantidad < miercoles.length) cantidad = miercoles.length;
    if (cantidad < jueves.length) cantidad = jueves.length;
    if (cantidad < viernes.length) cantidad = viernes.length;
    if (cantidad < sabado.length) cantidad = sabado.length;

    List<List<String>> data = [];

    for (int i = 0; i < cantidad; i++) {
      data.add([
        i < domingo.length ? _datos(domingo[i]) : "",
        i < lunes.length ? _datos(lunes[i]) : "",
        i < martes.length ? _datos(martes[i]) : "",
        i < miercoles.length ? _datos(miercoles[i]) : "",
        i < jueves.length ? _datos(jueves[i]) : "",
        i < viernes.length ? _datos(viernes[i]) : "",
        i < sabado.length ? _datos(sabado[i]) : "",
      ]);
    }

    List<List<String>> csvData = [
      ['De:', '${_fecha(inicio)}', 'A:', '${_fecha(termino)}'],
      [
        'Domingo',
        'Lunes',
        'Martes',
        'Miercoles',
        'Jueves',
        'Viernes',
        'Sabado'
      ],
      ...data,
      [
        '\$${_totalDinero(domingo)}',
        '\$${_totalDinero(lunes)}',
        '\$${_totalDinero(martes)}',
        '\$${_totalDinero(miercoles)}',
        '\$${_totalDinero(jueves)}',
        '\$${_totalDinero(viernes)}',
        '\$${_totalDinero(sabado)}'
      ],
      [
        'Total de la semana: ',
        '\$${_totalDinero(ordenes)}',
      ]
    ];
    String csv = const ListToCsvConverter().convert(csvData);
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/${_name(DateTime.now())}.csv';
    final File file = File(path);
    await file.writeAsString(csv);
    return file;
  }

  static double _totalDinero(List<Orden> ordenes) {
    double res = 0;
    ordenes.forEach((e) {
      res += e.total;
    });
    return res;
  }

  static String _datos(Orden orden) {
    return '${_horaDatos(orden.fecha)} \$${orden.total}';
  }

  static String _name(DateTime t) {
    return 'Recivo_${t.day}_${_mes(t.month)}_${t.year}_${_hora(t)}';
  }

  static String _fecha(DateTime t) {
    return '${t.day} ${_mes(t.month)}';
  }

  static String _hora(DateTime t) {
    if (t.hour < 12) {
      if (t.hour == 0) {
        return '12_${_agregaCero(t.minute)}_am';
      } else {
        return '${t.hour}_${_agregaCero(t.minute)}_am';
      }
    } else {
      return '${t.hour - 12}_${_agregaCero(t.minute)}_pm';
    }
  }

  static String _horaDatos(DateTime t) {
    if (t.hour < 12) {
      if (t.hour == 0) {
        return '12:${_agregaCero(t.minute)}am';
      } else {
        return '${t.hour}:${_agregaCero(t.minute)}am';
      }
    } else {
      return '${t.hour - 12}:${_agregaCero(t.minute)}pm';
    }
  }

  static String _agregaCero(int n) {
    if (n < 10) {
      return '0$n';
    } else {
      return '$n';
    }
  }

  static String _mes(int n) {
    switch (n) {
      case 1:
        return 'Ene';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dic';
      default:
        return '$n';
    }
  }
}
