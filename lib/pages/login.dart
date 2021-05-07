import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/models/usuario.dart';
import 'package:inventario/providers/app_state.dart';
import 'package:inventario/services/auth.dart';
import 'package:provider/provider.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool oculto = true;
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Ingresa')),
        body: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  SizedBox(height: 10),
                  Container(height: 150, child: Image.asset('assets/bg.png')),
                  TextFormField(
                    readOnly: loading,
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'EMAIL'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingresa un email';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: loading,
                          obscureText: oculto,
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'CONTRASEÑA'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ingresa tu contraseña';
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
                  SizedBox(height: 110),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: loading
                        ? Center(child: CircularProgressIndicator())
                        : RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                Usuario result = await AuthService()
                                    .singInWhitEmailAndPassword(
                                        emailController.text,
                                        passwordController.text);
                                if (result != null) {
                                  appState.setUsuario(result);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Credenciales incorrectas');
                                }
                                setState(() => loading = false);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Datos incompletos');
                              }
                            },
                            color: Colors.blueGrey[800],
                            child: Text(
                              'INGRESAR',
                              style: TextStyle(color: Colors.white),
                            )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
