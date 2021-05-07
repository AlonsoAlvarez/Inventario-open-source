import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario/models/producto.dart';

class Marca {
  final DocumentReference uid;
  final String name;
  final String description;
  final String url;
  final List categorias;

  Marca({this.categorias, this.uid, this.url, this.name, this.description});

  Map<String, dynamic> get toMap {
    return {
      'name': name,
      'description': description,
      'url': url,
      'categorias': categorias
    };
  }

  Marca _formSnapshot(DocumentSnapshot snapshot) {
    return Marca(
        uid: snapshot.reference,
        url: snapshot.data()['url'],
        name: snapshot.data()['name'],
        description: snapshot.data()['description'],
        categorias: snapshot.data()['categorias']);
  }

  Future<Marca> consultarFuture(DocumentReference reference) async {
    return _formSnapshot(await reference.get());
  }

  Stream<Marca> cosultarStream(DocumentReference reference) {
    return reference.snapshots().map((event) => _formSnapshot(event));
  }

  Stream<List<Marca>> marcasStream() {
    return FirebaseFirestore.instance
        .collection('marcas')
        .orderBy('name', descending: false)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  List<Marca> _queryToList(QuerySnapshot query) {
    List<Marca> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element));
    });
    return tmp;
  }

  void update(DocumentReference reference, Map<String, dynamic> map) async {
    await reference.update(map);
  }

  Future<DocumentReference> create(Map<String, dynamic> map) async {
    return await FirebaseFirestore.instance.collection('marcas').add(map);
  }

  Future<void> delete(DocumentReference reference) async {
    await reference.delete();
  }

  Future<List<Producto>> productosMarca(DocumentReference reference) async {
    var tmp = await FirebaseFirestore.instance
        .collection('productos')
        .where('marca', isEqualTo: reference)
        .orderBy('name', descending: false)
        .get();
    return Producto().queryToList(tmp);
  }

  Future<List<Marca>> marcasFiltro(String filtro) async {
    var tmp = await FirebaseFirestore.instance
        .collection('marcas')
        .orderBy('name', descending: false)
        .get();
    List<Marca> res = [];
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
