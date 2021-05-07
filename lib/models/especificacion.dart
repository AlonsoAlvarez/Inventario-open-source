import 'package:cloud_firestore/cloud_firestore.dart';

class Especificacion {
  final DocumentReference uid;
  final List acabado;
  final List apariencia;
  final List comercial;
  final List material;
  final List uso;
  final List color;
  final List pisoMuro;
  final List pei;
  final List promocion;
  final String name;
  final DocumentReference uidCategoria;

  Especificacion(
      {this.promocion,
      this.pei,
      this.color,
      this.uid,
      this.acabado,
      this.apariencia,
      this.comercial,
      this.material,
      this.uso,
      this.pisoMuro,
      this.name,
      this.uidCategoria});

  Map<String, dynamic> get toMap {
    return {
      'acabado': acabado,
      'apariencia': apariencia,
      'comercial': comercial,
      'material': material,
      'uso': uso,
      'color': color,
      'pisoMuro': pisoMuro,
      'pei': pei,
      'promocion': promocion,
      'uidCategoria': uidCategoria,
      'name': name
    };
  }

  static Especificacion _formSnapshot(DocumentSnapshot snapshot) {
    return Especificacion(
        uid: snapshot.reference,
        acabado: snapshot.data()['acabado'] ?? [],
        apariencia: snapshot.data()['apariencia'] ?? [],
        comercial: snapshot.data()['comercial'] ?? [],
        material: snapshot.data()['material'] ?? [],
        uso: snapshot.data()['uso'] ?? [],
        pisoMuro: snapshot.data()['pisoMuro'] ?? [],
        name: snapshot.data()['name'] ?? [],
        color: snapshot.data()['color'] ?? [],
        pei: snapshot.data()['pei'] ?? [],
        promocion: snapshot.data()['promocion'] ?? [],
        uidCategoria: snapshot.data()['uidCategoria'] ?? []);
  }

  static Future<Especificacion> consultarFuture(
      DocumentReference reference) async {
    return _formSnapshot(await reference.get());
  }

  static Future<DocumentReference> crear(Map<String, dynamic> mapa) async {
    return await FirebaseFirestore.instance
        .collection('especificaciones')
        .add(mapa);
  }

  static Future<void> actualizar(
      DocumentReference ref, Map<String, dynamic> mapa) async {
    await ref.update(mapa);
  }

  static Future<Especificacion> consultarByCategoria(
      DocumentReference refCategoria) async {
    QuerySnapshot tmp = await FirebaseFirestore.instance
        .collection('especificaciones')
        .where('uidCategoria', isEqualTo: refCategoria)
        .orderBy('name', descending: false)
        .get();
    return 0 < tmp.docs.length ? _formSnapshot(tmp.docs[0]) : null;
  }

  static List especificacion(Especificacion especificacion, String campo) {
    switch (campo) {
      case 'Tipo de material':
        return especificacion.material ?? [];
      case 'Comercial/Residencial':
        return especificacion.comercial ?? [];
      case 'Uso':
        return especificacion.uso ?? [];
      case 'Acabado':
        return especificacion.acabado ?? [];
      case 'Apariencia':
        return especificacion.apariencia ?? [];
      case 'Color':
        return especificacion.color ?? [];
      case 'PEI':
        return especificacion.pei ?? [];
      case 'Piso o Muro':
        return especificacion.pisoMuro ?? [];
      case 'Promocion':
        return especificacion.promocion ?? [];
      default:
        return [];
    }
  }
/*
  static List<Especificacion> _queryToList(QuerySnapshot query) {
    List<Especificacion> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element));
    });
    return tmp;
  } */
}
