import 'package:flutter/material.dart';
import '../../models/especificacion.dart';

class ButtonEspecificacion extends StatelessWidget {
  final String especificacion;
  final Especificacion categoria;
  final Function funcion;
  final TextEditingController controller;

  const ButtonEspecificacion(
      {Key key,
      this.especificacion,
      this.funcion,
      this.categoria,
      @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 0 < Especificacion.especificacion(categoria, especificacion).length
        ? TextFormField(
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              labelText: '$especificacion',
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('$especificacion'),
                      content: Container(
                        height: 300,
                        child: ListView(
                            children: Especificacion.especificacion(
                                    categoria, especificacion)
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: RaisedButton(
                                        onPressed: () {
                                          funcion(e);
                                          Navigator.pop(context);
                                        },
                                        child: Text('$e'),
                                      ),
                                    ))
                                .toList()),
                      ),
                    );
                  });
            },
          )
        : Container();
  }
}
