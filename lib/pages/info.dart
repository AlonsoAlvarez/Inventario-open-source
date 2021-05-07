import 'package:flutter/material.dart';

class PageInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Información de la aplicación \n\n\n Cliente: Vincent Javier Domínguez, para REyCO. \n\n Desarrollo: Del 2 al 15 de Febrero del 2021. \n\n Desarrollador: Mario Alonso Alvarez Pérez \n\n Contacto: \n \t - alvarez.alonso.mario@gmail.com \n \t - 4941016698 \n \t - https://github.com/AlonsoAlvarez',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
