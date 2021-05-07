import 'dart:io';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/components/alert_pick.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/services/auth.dart';
import 'package:inventario/utils/crop_img.dart';
import 'package:inventario/utils/csv.dart';
import 'package:inventario/utils/subir_file.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class PageAgregarEmpleado extends StatefulWidget {
  final Usuario usuario;

  const PageAgregarEmpleado({Key key, this.usuario}) : super(key: key);

  @override
  _PageAgregarEmpleadoState createState() => _PageAgregarEmpleadoState();
}

class _PageAgregarEmpleadoState extends State<PageAgregarEmpleado> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  File foto;
  bool loading = false;
  bool oculto = true;
  Usuario usuarioNuevo;

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      nameController.text = widget.usuario.name;
      emailController.text = widget.usuario.email;
      phoneController.text = widget.usuario.phone;
    }
  }

  void tomarFoto() {
    pickedFile().then((value) => setState(() => foto = value));
  }

  void cortarFoto() {
    cropImage(foto).then((value) => setState(() => foto = value));
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario != null ? 'Editar' : 'Agregar'),
        actions: [
          if (widget.usuario != null && appState.usuario.isAdmin) ...[
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertConfirma(
                        title: '¿Eliminar a ${widget.usuario.name}?',
                        acept: () {
                          widget.usuario.uid.delete();
                          Fluttertoast.showToast(
                              msg: 'Eliminado: ${widget.usuario.name}');
                          Navigator.pop(context);
                        },
                        cancel: () {},
                      );
                    });
              },
            )
          ]
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
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
                                (widget.usuario != null &&
                                    widget.usuario.url != null)) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertPickImage(
                                      borrar: false,
                                      url: widget.usuario != null
                                          ? widget.usuario.url
                                          : null,
                                      tagHero: 'HeroFoto',
                                      pick: tomarFoto,
                                      crop: cortarFoto,
                                      delete: () => setState(() => foto = null),
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
                                      : NetworkImage(widget.usuario != null
                                          ? widget.usuario.url
                                          : ''),
                                  placeholder: AssetImage('assets/camara.png'),
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
                            return 'Nombre del empleado';
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
                        readOnly: widget.usuario == null ? loading : true,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'EMAIL',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Ingresa un email';
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
                            return 'Ingresa un telefono';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                if (widget.usuario == null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: loading,
                          obscureText: oculto,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'CONTRASEÑA',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingresa una contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                            oculto ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() => oculto = !oculto);
                        },
                      )
                    ],
                  ),
                ],
                SizedBox(height: 20),
                if (widget.usuario == null && usuarioNuevo != null) ...[
                  Container(
                    height: 100,
                    width: 100,
                    child: RaisedButton(
                      child: Image.asset('assets/csv1.png'),
                      onPressed: () async {
                        File csv = await CSV.createUsuario(usuarioNuevo);
                        Share.shareFiles([csv.path],
                            text: 'Tabla de registros');
                      },
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.blueGrey[800],
                        onPressed: () async {
                          setState(() => loading = true);
                          if (_formKey.currentState.validate() &&
                              (foto != null || widget.usuario != null)) {
                            var url2 = foto != null
                                ? await uploadPicture(foto,
                                    '${nameController.text}', Folder.usuarios)
                                : widget.usuario.url;
                            usuarioNuevo = Usuario(
                              url: url2,
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                              name: nameController.text,
                              isAdmin: false,
                            );
                            if (widget.usuario == null) {
                              var result = await AuthService()
                                  .createUsuario(usuarioNuevo);
                              if (result != null) {
                                Fluttertoast.showToast(msg: 'Creado');
                              } else {
                                Fluttertoast.showToast(msg: 'Error');
                              }
                            } else {
                              widget.usuario.uid.update(usuarioNuevo.toMap);
                              Fluttertoast.showToast(msg: 'Actualizado');
                            }
                          } else {
                            Fluttertoast.showToast(msg: 'Datos incompletos');
                          }
                          setState(() => loading = false);
                        },
                        child: loading
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                                widget.usuario != null
                                    ? 'Actualizar'
                                    : 'Guardar',
                                style: TextStyle(color: Colors.white),
                              ),
                      ))
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
