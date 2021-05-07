import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final DocumentReference uid;
  final String email;
  final String name;
  final String phone;
  final String url;
  final String password;
  final String token;
  final bool isAdmin;

  Usuario(
      {this.isAdmin,
      this.token,
      this.uid,
      this.email,
      this.name,
      this.phone,
      this.url,
      this.password});

  Map<String, dynamic> get toMap {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'url': url,
      'token': token
    };
  }

  Usuario _formSnapshot(DocumentSnapshot snapshot, bool isAdmin) {
    return Usuario(
        uid: snapshot.reference,
        url: snapshot.data()['url'],
        phone: snapshot.data()['phone'],
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        isAdmin: isAdmin);
  }

  Future<Usuario> consultarUsuarioFuture(String uidCliente) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uidCliente)
        .get();
    return _formSnapshot(snapshot, false);
  }

  Stream<List<Usuario>> usuariosStream() {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .orderBy('name', descending: false)
        .snapshots()
        .map((event) => _queryToList(event));
  }

  List<Usuario> _queryToList(QuerySnapshot query) {
    List<Usuario> tmp = [];
    query.docs.forEach((element) {
      tmp.add(_formSnapshot(element, false));
    });
    return tmp;
  }

  Future<Usuario> consultarUsuario(DocumentReference uid) async {
    DocumentSnapshot tmp = await uid.get();
    return tmp.exists ? _formSnapshot(tmp, false) : null;
  }

  Future<Usuario> consultarAdministradorFuture(String uidAdmin) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('administradores')
        .doc(uidAdmin)
        .get();
    return snapshot.exists ? _formSnapshot(snapshot, true) : null;
  }

  Future<Usuario> consultarEmpleadoFuture(String uidEmpleado) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uidEmpleado)
        .get();
    return snapshot.exists ? _formSnapshot(snapshot, false) : null;
  }
}
