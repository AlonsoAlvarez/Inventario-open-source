import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventario/components/promociones/video.dart';
import 'package:inventario/models/promocion.dart';
import 'package:inventario/utils/crop_img.dart';
import 'package:inventario/utils/subir_file.dart';

import '../alert_pick.dart';

class AlertCreatePromocion extends StatefulWidget {
  @override
  _AlertCreatePromocionState createState() => _AlertCreatePromocionState();
}

class _AlertCreatePromocionState extends State<AlertCreatePromocion> {
  File foto;
  File video;
  bool loading = false;

  void tomarFoto() {
    pickedFile().then((value) => setState(() => foto = value));
  }

  void tomarVideo() {
    pickedVideo().then((value) => setState(() => video = value));
  }

  void cortarFoto() {
    cropImage(foto).then((value) => setState(() => foto = value));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Crear Promocion',
        style: TextStyle(fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 200,
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                if (video == null) ...[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (foto != null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertPickImage(
                                    borrar: false,
                                    url: null,
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
                                    : AssetImage('assets/camara.png'),
                                placeholder: AssetImage('assets/camara.png'),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
                if (foto == null) ...[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          tomarVideo();
                        },
                        child: Container(
                            color: Colors.white,
                            child: video == null
                                ? Image.asset('assets/video.png')
                                : VideoPlayerScreen(
                                    video: video,
                                  )),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ]),
        ),
      ),
      actions: [
        RaisedButton(
          color: Colors.blueGrey[800],
          child: loading
              ? Center(child: CircularProgressIndicator())
              : Text(
                  'Crear',
                  style: TextStyle(color: Colors.white),
                ),
          onPressed: () async {
            if (foto == null && video == null) {
              Fluttertoast.showToast(msg: 'Selecciona una imagen o video');
            } else {
              setState(() => loading = true);
              String path = foto != null ? 'foto' : 'video';
              String url = await uploadPicture(foto ?? video,
                  foto != null ? 'foto' : 'video', Folder.promociones);
              Promocion res =
                  Promocion(url: url, name: path, fecha: DateTime.now());
              await Promocion().createPromocion(res.toMap);
              setState(() => loading = false);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
