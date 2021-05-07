import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:inventario/models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> createUsuario(Usuario usuario) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.password);
      User user = result.user;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .set(usuario.toMap);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<Usuario> singInWhitEmailAndPassword(
      String email, String password) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      Usuario usuario = await Usuario().consultarEmpleadoFuture(user.uid);
      if (usuario != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .update({'token': await firebaseMessaging.getToken()});
      } else {
        usuario = await Usuario().consultarAdministradorFuture(user.uid);
        await FirebaseFirestore.instance
            .collection('administradores')
            .doc(user.uid)
            .update({'token': await firebaseMessaging.getToken()});
      }
      return usuario;
    } catch (e) {
      return null;
    }
  }

  Future singOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
