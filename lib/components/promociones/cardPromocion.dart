import 'package:flutter/material.dart';
import 'package:inventario/models/promocion.dart';

import './video.dart';

class CardPromocion extends StatelessWidget {
  final Promocion promocion;
  final Function funcion;

  const CardPromocion(
      {Key key, @required this.promocion, @required this.funcion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: funcion,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 150,
          child: promocion.name != "video"
              ? Image.network(promocion.url)
              : VideoPlayerScreen(
                  url: promocion.url,
                ),
        ));
  }
}
