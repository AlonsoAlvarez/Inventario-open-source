import 'package:flutter/material.dart';
import 'package:inventario/components/alert_confirmar.dart';
import 'package:inventario/components/promociones/alertCreatePromocion.dart';
import 'package:inventario/components/promociones/cardPromocion.dart';
import 'package:inventario/models/promocion.dart';
import 'package:inventario/utils/subir_file.dart';

class PagePromocion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promociones'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertCreatePromocion();
                  });
            },
          )
        ],
      ),
      body: StreamBuilder<List<Promocion>>(
          stream: Promocion().consultarPromocionesStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.isEmpty) {
              return Center(child: Text('No hay promociones aún'));
            }
            return SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        ...snapshot.data.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: CardPromocion(
                              key: ValueKey(e.uid),
                              promocion: e,
                              funcion: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertConfirma(
                                        title: '¿Eliminar?',
                                        cancel: () {},
                                        acept: () async {
                                          await deleteFile(e.url);
                                          await Promocion()
                                              .deletePromocion(e.uid);
                                        },
                                      );
                                    });
                              },
                            )))
                      ],
                    )));
          }),
    );
  }
}
