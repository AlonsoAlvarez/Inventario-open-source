import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario/models/producto.dart';

class Categoria {
  final DocumentReference uid;
  final String name;
  final String description;
  final String url;

  Categoria({this.uid, this.url, this.name, this.description});

  Map<String, dynamic> get toMap {
    return {'name': name, 'description': description, 'url': url};
  }

  Categoria _formSnapshot(DocumentSnapshot snapshot) {
    return Categoria(
      uid: snapshot.reference,
      url: snapshot.data()['url'],
      name: snapshot.data()['name'],
      description: snapshot.data()['description'],
    );
  }

  Future<Categoria> consultarFuture(DocumentReference reference) async {
    return _formSnapshot(await reference.get());
  }

  Future<List<Categoria>> consultarListFuture(List lista) async {
    List<Categoria> tmp = [];
    for (var i = 0; i < lista.length; i++) {
      tmp.add(await consultarFuture(lista[i]));
    }
    return tmp;
  }

  Stream<Categoria> cosultarStream(DocumentReference reference) {
    return reference.snapshots().map((event) => _formSnapshot(event));
  }

  Stream<List<Categoria>> categoriasStream() {
    return FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('name', descending: false)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  Future<List<Categoria>> categoriasFuture() async {
    QuerySnapshot tmp = await FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('name', descending: false)
        .get();
    return _queryToList(tmp);
  }

  List<Categoria> _queryToList(QuerySnapshot query) {
    List<Categoria> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element));
    });
    return tmp;
  }

  void update(DocumentReference reference, Map<String, dynamic> map) async {
    await reference.update(map);
  }

  Future<DocumentReference> create(Map<String, dynamic> map) async {
    return await FirebaseFirestore.instance.collection('categorias').add(map);
  }

  Future<void> delete(DocumentReference reference) async {
    await reference.delete();
  }

  Future<List<Producto>> productosCategoria(DocumentReference reference) async {
    var tmp = await FirebaseFirestore.instance
        .collection('productos')
        .where('categoria', isEqualTo: reference)
        .orderBy('name', descending: false)
        .get();
    return Producto().queryToList(tmp);
  }

  Future<List<Categoria>> categoriasFiltro(String filtro) async {
    var tmp = await FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('name', descending: false)
        .get();
    List<Categoria> res = [];
    var list = _queryToList(tmp);
    list.forEach((element) {
      if (filtro == '') {
        res.add(element);
      } else {
        if (element.name.toLowerCase().contains(filtro.toLowerCase())) {
          res.add(element);
        }
      }
    });
    return res;
  }
}
