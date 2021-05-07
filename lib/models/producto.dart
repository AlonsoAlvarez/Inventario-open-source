import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final DocumentReference uid;
  final DocumentReference categoria;
  final DocumentReference marca;
  final String name;
  final String description;
  final String barCode;
  final String url;
  final DocumentReference rama;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final String acabado;
  final String apariencia;
  final String comercial;
  final String material;
  final String uso;
  final String color;
  final String pisoMuro;
  final String pei;
  final String promocion;
  final List urlsFotos;

  Producto(
      {this.urlsFotos,
      this.acabado,
      this.apariencia,
      this.comercial,
      this.material,
      this.uso,
      this.color,
      this.pisoMuro,
      this.pei,
      this.promocion,
      this.rama,
      this.url,
      this.uid,
      this.categoria,
      this.marca,
      this.name,
      this.description,
      this.barCode,
      this.precioCompra,
      this.precioVenta,
      this.stock});

  Map<String, dynamic> get toMap {
    return {
      'url': url,
      'categoria': categoria,
      'marca': marca,
      'name': name,
      'description': description,
      'barCode': barCode,
      'precioCompra': precioCompra,
      'precioVenta': precioVenta,
      'stock': stock,
      'rama': rama,
      'acabado': acabado,
      'apariencia': apariencia,
      'comercial': comercial,
      'material': material,
      'uso': uso,
      'color': color,
      'pisoMuro': pisoMuro,
      'pei': pei,
      'promocion': promocion,
      'urlsFotos': urlsFotos
    };
  }

  Producto _formSnapshot(DocumentSnapshot snapshot) {
    return Producto(
        uid: snapshot.reference,
        url: snapshot.data()['url'],
        categoria: snapshot.data()['categoria'],
        marca: snapshot.data()['marca'],
        name: snapshot.data()['name'],
        description: snapshot.data()['description'],
        barCode: snapshot.data()['barCode'],
        precioCompra: snapshot.data()['precioCompra'],
        precioVenta: snapshot.data()['precioVenta'],
        stock: snapshot.data()['stock'],
        rama: snapshot.data()['rama'],
        material: snapshot.data()['material'] ?? '',
        acabado: snapshot.data()['acabado'] ?? '',
        apariencia: snapshot.data()['apariencia'] ?? '',
        comercial: snapshot.data()['comercial'] ?? '',
        color: snapshot.data()['color'] ?? '',
        pei: snapshot.data()['pei'] ?? '',
        pisoMuro: snapshot.data()['pisoMuro'] ?? '',
        uso: snapshot.data()['uso'] ?? '',
        promocion: snapshot.data()['promocion'] ?? '',
        urlsFotos: snapshot.data()['urlsFotos'] ?? []);
  }

  Future<Producto> consultarFuture(DocumentReference reference) async {
    DocumentSnapshot tmp = await reference.get();
    return tmp.exists ? _formSnapshot(tmp) : null;
  }

  Stream<Producto> cosultarStream(DocumentReference reference) {
    return reference.snapshots().map((event) => _formSnapshot(event));
  }

  Future<Producto> cosultarBarCode(String barCode) async {
    QuerySnapshot tmp = await FirebaseFirestore.instance
        .collection('productos')
        .where('barCode', isEqualTo: barCode)
        .get();
    return tmp.size != 0 ? _formSnapshot(tmp.docs.first) : null;
  }

  Stream<List<Producto>> productosStream() {
    return FirebaseFirestore.instance
        .collection('productos')
        .orderBy('name', descending: false)
        .snapshots()
        .map((event) => queryToList(event));
  }

  Stream<List<Producto>> productosMarcaStream(DocumentReference reference) {
    return FirebaseFirestore.instance
        .collection('productos')
        .where('marca', isEqualTo: reference)
        .orderBy('name', descending: false)
        .snapshots()
        .map((event) => queryToList(event));
  }

  Future<List<Producto>> productosFiltro(String filtro, DocumentReference marca,
      DocumentReference categoria) async {
    var tmp = await FirebaseFirestore.instance
        .collection('productos')
        .orderBy('name', descending: false)
        .get();
    List<Producto> res = [];
    var list = queryToList(tmp);
    list.forEach((element) {
      if (marca == null && categoria == null) {
        if (filtro == '') {
          res.add(element);
        } else {
          if (element.name.toLowerCase().contains(filtro.toLowerCase())) {
            res.add(element);
          }
        }
      } else {
        if (marca != null && categoria != null) {
          if (element.categoria == categoria && element.marca == marca) {
            if (filtro == '') {
              res.add(element);
            } else {
              if (element.name.toLowerCase().contains(filtro.toLowerCase())) {
                res.add(element);
              }
            }
          }
        } else {
          if (marca != null) {
            if (element.marca == marca) {
              if (filtro == '') {
                res.add(element);
              } else {
                if (element.name.toLowerCase().contains(filtro.toLowerCase())) {
                  res.add(element);
                }
              }
            }
          } else {
            if (element.categoria == categoria) {
              if (filtro == '') {
                res.add(element);
              } else {
                if (element.name.toLowerCase().contains(filtro.toLowerCase())) {
                  res.add(element);
                }
              }
            }
          }
        }
      }
    });
    return res;
  }

  Stream<List<Producto>> productosCategoriaStream(DocumentReference reference) {
    return FirebaseFirestore.instance
        .collection('productos')
        .where('categoria', isEqualTo: reference)
        .orderBy('name', descending: false)
        .snapshots()
        .map((event) => queryToList(event));
  }

  List<Producto> queryToList(QuerySnapshot query) {
    List<Producto> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element));
    });
    return tmp;
  }

  void update(DocumentReference reference, Map<String, dynamic> map) async {
    await reference.update(map);
  }

  Future<DocumentReference> create(Map<String, dynamic> map) async {
    return await FirebaseFirestore.instance.collection('productos').add(map);
  }

  Future<void> delete(DocumentReference reference) async {
    await reference.delete();
  }
}
