import 'package:flutter/material.dart';
import 'package:inventario/models/pedido.dart';

class VentaState with ChangeNotifier {
  List<Pedido> pedidos = [];

  get totalEntrada {
    double res = 0;
    pedidos.forEach((element) {
      res += (element.producto.precioCompra * element.cantidad);
    });
    return res;
  }

  get totalVenta {
    double res = 0;
    pedidos.forEach((element) {
      res += (element.producto.precioVenta * element.cantidad);
    });
    return res;
  }

  void reset() {
    this.pedidos.clear();
    notifyListeners();
  }

  void cambiarCantidad(Pedido pedido, int cantidad) {
    int index;
    for (int i = 0; i < pedidos.length; i++) {
      if (pedidos[i] == pedido) {
        index = i;
        break;
      }
    }
    pedidos[index].cantidad = cantidad;
    notifyListeners();
  }

  void agregar(Pedido pedido) {
    bool existe = false;
    for (int i = 0; i < pedidos.length; i++) {
      if (pedidos[i].producto.uid == pedido.producto.uid) {
        existe = true;
        break;
      }
    }
    if (!existe) {
      pedidos.add(pedido);
      notifyListeners();
    }
  }

  void remover(Pedido pedido) {
    pedidos.remove(pedido);
    notifyListeners();
  }
}
