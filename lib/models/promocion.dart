import 'package:cloud_firestore/cloud_firestore.dart';

class Promocion {
  final DocumentReference uid;
  final String url;
  final String name;
  final DateTime fecha;

  Promocion({this.uid, this.url, this.name, this.fecha});

  Map<String, dynamic> get toMap {
    return {
      'url': url,
      'fecha': fecha,
      'name': name,
    };
  }

  Promocion _fromSnapshot(DocumentSnapshot snapshot) {
    return Promocion(
        uid: snapshot.reference,
        name: snapshot.data()['name'],
        url: snapshot.data()['url'],
        fecha: DateTime.fromMillisecondsSinceEpoch(
            snapshot.data()['fecha'].millisecondsSinceEpoch));
  }

  Future<DocumentReference> createPromocion(Map<String, dynamic> map) async {
    DocumentReference ref =
        await FirebaseFirestore.instance.collection('promociones').add(map);
    return ref;
  }

  Future<Promocion> consultarPromocionFuture(
      DocumentReference reference) async {
    return _fromSnapshot(await reference.get());
  }

  Future<void> deletePromocion(DocumentReference reference) async {
    await reference.delete();
  }

  Future<List<Promocion>> consultarPromocionesFuture() async {
    QuerySnapshot tmp = await FirebaseFirestore.instance
        .collection('promociones')
        .orderBy('fecha', descending: true)
        .get();
    return _queryToList(tmp);
  }

  Stream<List<Promocion>> consultarPromocionesStream() {
    return FirebaseFirestore.instance
        .collection('promociones')
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  List<Promocion> _queryToList(QuerySnapshot query) {
    List<Promocion> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_fromSnapshot(element));
    });
    return tmp;
  }
}
