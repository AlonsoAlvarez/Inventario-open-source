import 'package:flutter/material.dart';
import 'package:inventario/models/usuario.dart';

class AppState with ChangeNotifier {
  Usuario _usuarioActual;

  Usuario get usuario => _usuarioActual;

  void updateUsuario(Usuario usuario) {
    Usuario tmp = Usuario(
        url: usuario.url ?? _usuarioActual.url,
        uid: _usuarioActual.uid,
        token: _usuarioActual.token,
        name: usuario.name ?? _usuarioActual.name,
        phone: usuario.phone ?? _usuarioActual.phone,
        isAdmin: _usuarioActual.isAdmin,
        email: _usuarioActual.email);
    this._usuarioActual = tmp;
    _usuarioActual.uid.update(tmp.toMap);
    notifyListeners();
  }

  void setUsuario(Usuario usuario) {
    this._usuarioActual = usuario;
    notifyListeners();
  }
}
