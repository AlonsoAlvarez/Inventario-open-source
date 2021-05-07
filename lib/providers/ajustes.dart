import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ajustes with ChangeNotifier {
  Color color;
  SharedPreferences prefs;

  void setColor(String color) {
    prefs.setString('tema', color);
    this.color = getColor();
    notifyListeners();
  }

  void setUsuario(String uidUsuario) {
    prefs.setString('uidUsuario', uidUsuario);
    notifyListeners();
  }

  void cargarColor() {
    this.color = getColor();
    notifyListeners();
  }

  // ignore: missing_return
  Color getColor() {
    if (prefs.getString('tema') != null) {
      switch (prefs.getString('tema')) {
        case 'red':
          return Colors.red;
          break;
        case 'blueGrey':
          return Colors.blueGrey;
          break;
        case 'blue':
          return Colors.blue;
          break;
        case 'green':
          return Colors.green;
          break;
        case 'purple':
          return Colors.purple;
          break;
        case 'pink':
          return Colors.pink;
          break;
        case 'orange':
          return Colors.orange;
          break;
        case 'brown':
          return Colors.brown;
          break;
      }
    } else {
      return Colors.blue;
    }
  }
}
