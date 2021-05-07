import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:inventario/utils/chart.dart';
import 'package:inventario/models/history.dart';
import 'package:inventario/models/orden.dart';
// import 'package:inventario/utils/guardarSemana.dart';

class OrdersState with ChangeNotifier {
  List<Orden> _ordenes = [];

  List<Orden> get ordenes => _ordenes;

  Series<dynamic, dynamic> get ingresos {
    List<int> tmp = [];
    var date = _ordenes[0].fecha;
    double val = 0;
    int i = 0;
    while (i < _ordenes.length) {
      while (i < _ordenes.length &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (!_ordenes[i].isEntrada) {
          val += _ordenes[i].total;
        }
        i++;
      }
      tmp.add(val.round());
      if (i < _ordenes.length) date = _ordenes[i].fecha;
      val = 0;
    }
    return lineaGrafica(tmp, 'Ingresos');
  }

  List<History> get ingresosHistory {
    List<History> tmp = [];
    var date = _ordenes[_ordenes.length - 1].fecha;
    double val = 0;
    int i = _ordenes.length - 1;
    while (-1 < i) {
      while (-1 < i &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (!_ordenes[i].isEntrada) {
          val += _ordenes[i].total;
        }
        i--;
      }
      tmp.add(History(date: date, valor: val));
      if (-1 < i) date = _ordenes[i].fecha;
      val = 0;
    }
    return tmp;
  }

  List<History> get ingresosHistoryHoy {
    List<History> tmp = [];
    var date = _ordenes[_ordenes.length - 1].fecha;
    var hoy = DateTime.now();
    double val = 0;
    int i = _ordenes.length - 1;
    bool entra = false;
    while (-1 < i) {
      while (-1 < i &&
          date.hour == _ordenes[i].fecha.hour &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (!_ordenes[i].isEntrada &&
            hoy.day == _ordenes[i].fecha.day &&
            hoy.month == _ordenes[i].fecha.month &&
            hoy.year == _ordenes[i].fecha.year) {
          val += _ordenes[i].total;
          entra = true;
        }
        i--;
      }
      if (entra) {
        tmp.add(History(date: date, valor: val));
        entra = false;
      }
      if (-1 < i) date = _ordenes[i].fecha;
      val = 0;
    }
    return tmp;
  }

  List<History> get ventasHistory {
    List<History> tmp = [];
    var date = _ordenes[_ordenes.length - 1].fecha;
    double val = 0;
    int i = _ordenes.length - 1;
    while (-1 < i) {
      while (-1 < i &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (!_ordenes[i].isEntrada) {
          val++;
        }
        i--;
      }
      tmp.add(History(date: date, valor: val));
      if (-1 < i) date = _ordenes[i].fecha;
      val = 0;
    }
    return tmp;
  }

  List<History> get ventasHistoryHoy {
    List<History> tmp = [];
    var date = _ordenes[_ordenes.length - 1].fecha;
    var hoy = DateTime.now();
    double val = 0;
    int i = _ordenes.length - 1;
    bool entra = false;
    while (-1 < i) {
      while (-1 < i &&
          date.hour == _ordenes[i].fecha.hour &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (!_ordenes[i].isEntrada &&
            hoy.day == _ordenes[i].fecha.day &&
            hoy.month == _ordenes[i].fecha.month &&
            hoy.year == _ordenes[i].fecha.year) {
          val++;
          entra = true;
        }
        i--;
      }
      if (entra) {
        tmp.add(History(date: date, valor: val));
        entra = false;
      }
      if (-1 < i) date = _ordenes[i].fecha;
      val = 0;
    }
    return tmp;
  }

  Series<dynamic, dynamic> get ventas {
    List<int> tmp = [];
    var date = _ordenes[0].fecha;
    int val = 0;
    int i = 0;
    while (i < _ordenes.length) {
      while (i < _ordenes.length &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (!_ordenes[i].isEntrada) {
          val++;
        }
        i++;
      }
      tmp.add(val);
      if (i < _ordenes.length) date = _ordenes[i].fecha;
      val = 0;
    }
    return lineaGrafica(tmp, 'Ventas');
  }

  Series<dynamic, dynamic> get ingresosHoy {
    List<int> tmp = [];
    var date = _ordenes[0].fecha;
    var hoy = DateTime.now();
    double val = 0;
    int i = 0;
    bool entra = false;
    while (i < _ordenes.length) {
      while (i < _ordenes.length &&
          date.hour == _ordenes[i].fecha.hour &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (hoy.day == _ordenes[i].fecha.day &&
            hoy.month == _ordenes[i].fecha.month &&
            hoy.year == _ordenes[i].fecha.year &&
            !_ordenes[i].isEntrada) {
          val += _ordenes[i].total;
          entra = true;
        }
        i++;
      }
      if (entra) {
        tmp.add(val.round());
        entra = false;
      }
      if (i < _ordenes.length) date = _ordenes[i].fecha;
      val = 0;
    }
    return lineaGrafica(tmp, 'Ingresos hoy');
  }

  Series<dynamic, dynamic> get ventasHoy {
    List<int> tmp = [];
    var date = _ordenes[0].fecha;
    var hoy = DateTime.now();
    int val = 0;
    int i = 0;
    bool entra = false;
    while (i < _ordenes.length) {
      while (i < _ordenes.length &&
          date.hour == _ordenes[i].fecha.hour &&
          date.day == _ordenes[i].fecha.day &&
          date.month == _ordenes[i].fecha.month &&
          date.year == _ordenes[i].fecha.year) {
        if (hoy.day == _ordenes[i].fecha.day &&
            hoy.month == _ordenes[i].fecha.month &&
            hoy.year == _ordenes[i].fecha.year &&
            !_ordenes[i].isEntrada) {
          val++;
          entra = true;
        }
        i++;
      }
      if (entra) {
        tmp.add(val);
        entra = false;
      }
      if (i < _ordenes.length) date = _ordenes[i].fecha;
      val = 0;
    }
    return lineaGrafica(tmp, 'Ventas hoy');
  }

  int get notasEntrada {
    int entradas = 0;
    _ordenes.forEach((element) {
      if (element.isEntrada) {
        entradas++;
      }
    });
    return entradas;
  }

  int get notasVenta {
    int salidas = 0;
    _ordenes.forEach((element) {
      if (!element.isEntrada) {
        salidas++;
      }
    });
    return salidas;
  }

  void setOrders(List<Orden> orders) {
    this._ordenes = orders;
    //for (int i = 0; i < orders.length; i++) {
    //    orders[i].uid.update({'salvado': false});
//    }
//    guradarSemana(orders);
//    notifyListeners();
  }
}
