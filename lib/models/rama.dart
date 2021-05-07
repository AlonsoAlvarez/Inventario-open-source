import 'package:cloud_firestore/cloud_firestore.dart';

class Rama {
  final DocumentReference uid;
  final String name;
  final List uidCategorias;
  final int index;

  Rama({this.index, this.uid, this.name, this.uidCategorias});

  Map<String, dynamic> get toMap {
    return {'name': name, 'uidCategoria': uidCategorias, 'index': index};
  }

  Rama _formSnapshot(DocumentSnapshot snapshot) {
    return Rama(
        uid: snapshot.reference,
        name: snapshot.data()['name'],
        uidCategorias: snapshot.data()['uidCategorias'],
        index: snapshot.data()['index'] ?? 0);
  }

  Future<Rama> consultarRama(DocumentReference rama) async {
    return _formSnapshot(await rama.get());
  }

  static Future<void> actualizar(
      DocumentReference ref, Map<String, dynamic> mapa) async {
    await ref.update(mapa);
  }

  static Future<DocumentReference> create(Map<String, dynamic> map) async {
    return await FirebaseFirestore.instance.collection('ramas').add(map);
  }

  Future<List<Rama>> consultarRamas() async {
    QuerySnapshot tmp = await FirebaseFirestore.instance
        .collection('ramas')
        .orderBy('index', descending: false)
        .get();
    return _queryToList(tmp);
  }

  Stream<List<Rama>> consultarStream() {
    return FirebaseFirestore.instance
        .collection('ramas')
        .orderBy('index', descending: false)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  List<Rama> _queryToList(QuerySnapshot query) {
    List<Rama> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element));
    });
    return tmp;
  }

  void agregarCategoriaRama(
      DocumentReference rama, DocumentReference categoria) async {
    Rama tmp = _formSnapshot(await rama.get());
    bool existe = false;
    List categorias = [];
    if (tmp.uidCategorias != null && 0 < tmp.uidCategorias.length) {
      categorias = tmp.uidCategorias;
      tmp.uidCategorias.forEach((e) {
        if (categoria.id == e.id) {
          existe = true;
        }
      });
    }
    if (!existe) {
      categorias.add(categoria);
      rama.update({'uidCategorias': categorias});
    }
  }
}
