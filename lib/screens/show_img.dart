import 'dart:io';

import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String place;
  final String tagHero;
  final String url;
  final File foto;
  ShowImage({this.place, this.tagHero, this.url, this.foto});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text('Regresar')),
      body: Center(
        child: Hero(
          tag: tagHero,
          child: Container(
            color: Colors.black,
            child: FadeInImage(
                placeholder: AssetImage(place),
                image: foto != null ? FileImage(foto) : NetworkImage(url),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
