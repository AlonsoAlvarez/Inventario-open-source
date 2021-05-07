import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/pages/home.dart';
import 'package:inventario/pages/login.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:provider/provider.dart';

class Wrapped extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    if (appState.usuario == null) {
      Fluttertoast.showToast(msg: 'Try auto login');
      if (_auth.currentUser != null) {
        Usuario().consultarEmpleadoFuture(_auth.currentUser.uid).then((user) {
          if (user != null) {
            Fluttertoast.showToast(msg: 'Empleado ${user.name}');
            appState.setUsuario(user);
          } else {
            Usuario()
                .consultarAdministradorFuture(_auth.currentUser.uid)
                .then((admin) {
              if (admin != null) {
                Fluttertoast.showToast(msg: 'Administrador ${admin.name}');
                appState.setUsuario(admin);
              } else {
                _auth.signOut();
              }
            });
          }
        });
      }
      return PageLogin();
    } else {
      return PageHome();
    }
  }
}
