import 'package:inventario/models/pedido.dart';

class Operaciones {
  Operaciones._();

  static double totalPedidos(List<Pedido> pedidos, bool isEntrada) {
    double resultado = 0;
    pedidos.forEach((element) {
      if (element.cantidad != null && element.producto != null) {
        resultado += element.cantidad *
            (isEntrada
                ? element.producto.precioCompra
                : element.producto.precioVenta);
      }
    });
    return resultado;
  }
}
