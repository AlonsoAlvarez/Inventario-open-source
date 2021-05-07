import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/alert_pick.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/utils/crop_img.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventario/providers/ajustes.dart';

import 'package:inventario/constants/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Ajustes ajustes = Ajustes();
  bool loading = true;
  File foto;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  AppState appState;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        ajustes.prefs = value;
        loading = false;
        nameController.text = appState.usuario.name;
        emailController.text = appState.usuario.email;
        phoneController.text = appState.usuario.phone;
      });
    });
  }

  void tomarFoto() {
    pickedFile().then((value) => setState(() => foto = value));
  }

  void cortarFoto() {
    cropImage(foto).then((value) => setState(() => foto = value));
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context);
    ajustes = Provider.of<Ajustes>(context);
    return loading
        ? Container()
        : Scaffold(
            appBar: AppBar(
              title: Text('Ajustes'),
            ),
            body: Container(
              /*
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'), fit: BoxFit.none)), */
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 15, 25.0, 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: RaisedButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    if (foto != null ||
                                        (appState.usuario.url != null)) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertPickImage(
                                              borrar: false,
                                              url: appState.usuario.url ?? null,
                                              tagHero: 'HeroFoto',
                                              pick: tomarFoto,
                                              crop: cortarFoto,
                                              delete: () =>
                                                  setState(() => foto = null),
                                              foto: foto,
                                            );
                                          });
                                    } else {
                                      // SELECCIONAR IMAGEN
                                      tomarFoto();
                                    }
                                  },
                                  child: Hero(
                                    tag: 'HeroFoto',
                                    child: Container(
                                        color: Colors.white,
                                        child: FadeInImage(
                                          image: foto != null
                                              ? FileImage(foto)
                                              : NetworkImage(
                                                  appState.usuario.url ?? ''),
                                          placeholder:
                                              AssetImage('assets/camara.png'),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                readOnly: loading,
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'NOMBRE',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Nombre del administrador';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'EMAIL',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa tu email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: TextFormField(
                                readOnly: loading,
                                controller: phoneController,
                                decoration: InputDecoration(
                                  labelText: 'TELEFONO',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa tu telefono';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                              color: Colors.blueGrey[800],
                              onPressed: () async {
                                if (_formKey.currentState.validate() &&
                                    (foto != null ||
                                        appState.usuario.url != null)) {
                                  setState(() => loading = true);
                                  var url2 = foto != null
                                      ? await uploadPicture(
                                          foto,
                                          '${nameController.text}',
                                          Folder.usuarios)
                                      : appState.usuario.url;
                                  Usuario tmp = Usuario(
                                    url: url2,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                  appState.updateUsuario(tmp);
                                  Fluttertoast.showToast(msg: 'Actualizado');
                                  setState(() => loading = false);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Datos incompletos');
                                }
                              },
                              child: Text('Actualizar',
                                  style: TextStyle(color: Colors.white))),
                        ),
                        SizedBox(height: 35.0),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              ' Color del tema ',
                              style: TextStyle(
                                  backgroundColor: Colors.white.withAlpha(200)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: colorSelect(Colors.red, 'red'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.blueGrey, 'blueGrey'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.blue, 'blue'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.green, 'green'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.purple, 'purple'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.pink, 'pink'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.orange, 'orange'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: colorSelect(Colors.brown, 'brown'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget colorSelect(Color color, String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ajustes.setColor(name);
          tema = color;
          Fluttertoast.showToast(msg: 'Tema: $name');
        });
      },
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}
