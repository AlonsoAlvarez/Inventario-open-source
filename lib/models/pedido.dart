import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario/models/producto.dart';

class Pedido {
  final DocumentReference uid;
  final DocumentReference uidProducto;
  Producto producto;
  int cantidad;

  Pedido({this.producto, this.uid, this.uidProducto, this.cantidad});

  Map<String, dynamic> get toMap {
    return {'uidProducto': uidProducto ?? producto.uid, 'cantidad': cantidad};
  }

  Pedido _formSnapshot(DocumentSnapshot snapshot) {
    return Pedido(
        uid: snapshot.reference,
        uidProducto: snapshot.data()['uidProducto'],
        cantidad: snapshot.data()['cantidad']);
  }

  Future<DocumentReference> createPedido(Map<String, dynamic> map) async {
    QuerySnapshot tmp = await FirebaseFirestore.instance
        .collection('pedidos')
        .where('cantidad', isEqualTo: map['cantidad'])
        .where('uidProducto', isEqualTo: map['uidProducto'])
        .get();
    if (0 < tmp.size) {
      return tmp.docs.first.reference;
    } else {
      DocumentReference ref =
          await FirebaseFirestore.instance.collection('pedidos').add(map);
      return ref;
    }
  }

  Future<Pedido> consultarPedido(DocumentReference reference) async {
    DocumentSnapshot tmp = await reference.get();
    return tmp.exists ? _formSnapshot(tmp) : null;
  }
}
