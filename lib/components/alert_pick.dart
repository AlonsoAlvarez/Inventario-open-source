import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventario/screens/show_img.dart';

class AlertPickImage extends StatelessWidget {
  final Function pick;
  final Function crop;
  final Function delete;
  final String tagHero;
  final File foto;
  final String url;
  final bool borrar;

  const AlertPickImage(
      {Key key,
      this.pick,
      this.crop,
      this.delete,
      this.tagHero,
      this.foto,
      this.url,
      @required this.borrar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Acciones',
      ),
      content: Container(
          height: 208,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RaisedButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ShowImage(
                                  tagHero: tagHero,
                                  place: 'assets/camara.png',
                                  url: url,
                                  foto: foto,
                                )));
                  },
                  child: Hero(
                    tag: tagHero,
                    child: Container(
                        height: 150,
                        color: Colors.white,
                        child: FadeInImage(
                          image: foto != null
                              ? FileImage(foto)
                              : NetworkImage(url),
                          placeholder: AssetImage('assets/camara.png'),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(children: [
                /*
            Expanded(
                child: IconButton(
              onPressed: show,
              icon: Icon(Icons.view_in_ar, color: Colors.blueGrey[800]),
            )),
            SizedBox(width: 5), */
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    pick();
                  },
                  icon: Icon(
                    Icons.image,
                    color: Colors.blueGrey,
                  ),
                )),
                if (foto != null) ...[
                  SizedBox(width: 5),
                  Expanded(
                      child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      crop();
                    },
                    icon: Icon(Icons.crop, color: Colors.orangeAccent),
                  )),
                  SizedBox(width: 5),
                  Expanded(
                      child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      delete();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  )),
                ] else ...[
                  if (borrar) ...[
                    SizedBox(width: 5),
                    Expanded(
                        child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        delete();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    )),
                  ]
                ]
              ]),
            ],
          )),
    );
  }
}
