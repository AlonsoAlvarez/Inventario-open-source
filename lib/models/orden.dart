import 'package:cloud_firestore/cloud_firestore.dart';

class Orden {
  final DocumentReference uid;
  final DocumentReference uidEncargado;
  final bool isEntrada;
  final List uidPedidos;
  final DateTime fecha;
  final double total;
  final String urlPDF;

  Orden(
      {this.urlPDF,
      this.uidEncargado,
      this.isEntrada,
      this.total,
      this.uid,
      this.uidPedidos,
      this.fecha});

  Map<String, dynamic> get toMap {
    return {
      'uidPedidos': uidPedidos,
      'urlPDF': urlPDF,
      'fecha': fecha,
      'total': total,
      'isEntrada': isEntrada,
      'uidEncargado': uidEncargado,
      'salvado': false
    };
  }

  Orden _formSnapshot(DocumentSnapshot snapshot) {
    return Orden(
        uid: snapshot.reference,
        urlPDF: snapshot.data()['urlPDF'],
        uidPedidos: snapshot.data()['uidPedidos'],
        uidEncargado: snapshot.data()['uidEncargado'],
        isEntrada: snapshot.data()['isEntrada'],
        total: snapshot.data()['total'].toDouble(),
        fecha: DateTime.fromMillisecondsSinceEpoch(
            snapshot.data()['fecha'].millisecondsSinceEpoch));
  }

  Future<DocumentReference> createOrden(Map<String, dynamic> map) async {
    DocumentReference ref =
        await FirebaseFirestore.instance.collection('ordenes').add(map);
    return ref;
  }

  Future<Orden> consultarOrdenFuture(DocumentReference reference) async {
    return _formSnapshot(await reference.get());
  }

  Future<void> deleteOrden(DocumentReference reference) async {
    await reference.delete();
  }

  Stream<List<Orden>> ordenesStream() {
    return FirebaseFirestore.instance
        .collection('ordenes')
        .where('salvado', isEqualTo: false)
        .orderBy('fecha', descending: false)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  Stream<List<Orden>> ordenesStreamDesending(bool isEntrada) {
    return FirebaseFirestore.instance
        .collection('ordenes')
        .where('isEntrada', isEqualTo: isEntrada)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  Stream<List<Orden>> ordenesStreamDesendingEmpleado(
      bool isEntrada, DocumentReference uid) {
    return FirebaseFirestore.instance
        .collection('ordenes')
        .where('uidEncargado', isEqualTo: uid)
        .where('isEntrada', isEqualTo: isEntrada)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  List<Orden> _queryToList(QuerySnapshot query) {
    List<Orden> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element));
    });
    return tmp;
  }
}
