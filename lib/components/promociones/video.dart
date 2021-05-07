import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final File video;
  final String url;
  VideoPlayerScreen({Key key, this.video, this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Crear y almacenar el VideoPlayerController. El VideoPlayerController
    // ofrece distintos constructores diferentes para reproducir videos desde assets, archivos,
    // o internet.
    _controller = widget.video != null
        ? VideoPlayerController.file(widget.video)
        : VideoPlayerController.network(widget.url);

    // Inicializa el controlador y almacena el Future para utilizarlo luego
    _initializeVideoPlayerFuture = _controller.initialize();

    // Usa el controlador para hacer un bucle en el vídeo
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Asegúrate de despachar el VideoPlayerController para liberar los recursos
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Si el VideoPlayerController ha finalizado la inicialización, usa
          // los datos que proporciona para limitar la relación de aspecto del VideoPlayer
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            // Usa el Widget VideoPlayer para mostrar el vídeo
            child: VideoPlayer(_controller),
          );
        } else {
          // Si el VideoPlayerController todavía se está inicializando, muestra un
          // spinner de carga
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
