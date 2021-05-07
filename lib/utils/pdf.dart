import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:inventario/models/pedido.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'fecha.dart';

Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat,
    int numero,
    String sucursal,
    String nombreCliente,
    String direccionCliente,
    String telefonoCliente,
    String tipoNota,
    List<Pedido> productos,
    bool isEntrada,
    String estatus) async {
  final products = List<Product>.generate(
      productos.length,
      (index) => Product(
          productos[index].producto.name,
          isEntrada
              ? productos[index].producto.precioCompra
              : productos[index].producto.precioVenta,
          productos[index].cantidad));
  /*[
    Product('Descripcion', 21, 2),
    Product('Algo', 32, 1),
    Product('Pendiente', 15, 5),
    Product('No se', 53, 3),
  ]; */
  final invoice = Invoice(
    isEntrada: isEntrada,
    estatus: estatus,
    numeroNota: '$numero',
    tipoNota: tipoNota,
    direccionCliente: direccionCliente,
    sucursal: sucursal,
    products: products,
    nombreCliente: nombreCliente,
    phoneCliente: telefonoCliente,
    direccionTienda: 'Direccion, col. ejemplo\nJerez, Zac. Tel. 4444444444',
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );
  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  final List<Product> products;
  final String tipoNota;
  final String numeroNota;
  final String direccionTienda;
  final String direccionCliente;
  final String nombreCliente;
  final String sucursal;
  final String phoneCliente;
  final String estatus;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final bool isEntrada;

  Invoice(
      {this.isEntrada,
      this.estatus,
      this.phoneCliente,
      this.numeroNota,
      this.tipoNota,
      this.direccionTienda,
      this.direccionCliente,
      this.nombreCliente,
      this.sucursal,
      this.products,
      this.baseColor,
      this.accentColor});

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  // ignore: unused_element
  PdfColor get _baseTextColor =>
      baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  // ignore: unused_element
  PdfColor get _accentTextColor =>
      baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  //double get _grandTotal => _total * (1 + tax);

//  String _logo;

  var reyco;
  var castel;
  var interceramic;
  var cato;
  var lamosa;
  var vitromex;
  var cesantoni;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    final font1 = await rootBundle.load('fonts/LongTime.ttf');
    final font2 = await rootBundle.load('fonts/hadriatic.ttf');
    final font3 = await rootBundle.load('fonts/AYearWithoutRain.ttf');

    reyco = pw.MemoryImage(
        (await rootBundle.load('assets/bg.png')).buffer.asUint8List());

    castel = pw.MemoryImage(
        (await rootBundle.load('assets/castel.png')).buffer.asUint8List());
    interceramic = pw.MemoryImage(
        (await rootBundle.load('assets/interceramic.jpg'))
            .buffer
            .asUint8List());
    cato = pw.MemoryImage(
        (await rootBundle.load('assets/cato.jpg')).buffer.asUint8List());
    lamosa = pw.MemoryImage(
        (await rootBundle.load('assets/lamosa.png')).buffer.asUint8List());
    vitromex = pw.MemoryImage(
        (await rootBundle.load('assets/vitromex.png')).buffer.asUint8List());
    cesantoni = pw.MemoryImage(
        (await rootBundle.load('assets/cesantoni.png')).buffer.asUint8List());

    //_logo = await rootBundle.loadString('assets/bg.svg');

    doc.addPage(pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          pw.Font.ttf(font1),
          pw.Font.ttf(font2),
          pw.Font.ttf(font3),
        ),
        header: _buildHeader,
        build: (context) => [
              pw.SizedBox(height: 5),
              _contentTable(context),
              pw.SizedBox(height: 5),
              _rowTotal(context),
              pw.SizedBox(height: 15),
              _rowEstatus(context)
            ]));

    return doc.save();
  }

  pw.Widget _rowEstatus(pw.Context context) {
    return pw.Row(children: [
      pw.Text('ESTATUS:',
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 18,
            fontWeight: pw.FontWeight.normal,
          )),
      pw.Expanded(
          child: pw.Column(
//              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
            pw.Text('$estatus',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.normal,
                )),
            pw.Divider(indent: 1, height: 1)
          ]))
    ]);
  }

  pw.Widget _rowTotal(pw.Context context) {
    return pw.Row(children: [
      pw.SizedBox(width: 300),
      pw.Text('TOTAL:',
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 17,
            fontWeight: pw.FontWeight.normal,
          )),
      pw.Expanded(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
            pw.Text('\$${_total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.normal,
                )),
            pw.Divider(indent: 1, height: 1)
          ]))
    ]);
  }

  pw.Widget _contentTable(pw.Context context) {
    final List<String> tableHeaders = <String>[
      'CANT.',
      'DESCRIPCIÓN',
      'PRECIO UNITARIO',
      'IMPORTE'
    ];
    var contenido = List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
            tableHeaders.length, (col) => products[row].getIndex(col)));

    return pw.Table.fromTextArray(
        border: null, //pw.TableBorder.all(),
        headerHeight: 25,
        cellHeight: 25,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.center,
          3: pw.Alignment.centerRight
        },
        headerDecoration: pw.BoxDecoration(color: PdfColors.blueGrey700),
        headerStyle: pw.TextStyle(
            color: PdfColors.white,
            fontSize: 15,
            fontWeight: pw.FontWeight.normal),
        cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 12),
        rowDecoration: pw.BoxDecoration(
            border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: .5),
        )),
        headers: List<String>.generate(
            tableHeaders.length, (col) => tableHeaders[col]),
        data: contenido);
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(children: [
      pw.Row(children: [
        pw.Expanded(
            flex: 1,
            child: pw.Padding(
                padding: pw.EdgeInsets.only(right: 30),
                child: pw.Column(children: [
                  pw.SizedBox(height: 20),
                  pw.Row(children: [
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                      child: pw.Image(castel),
                    )
                  ]),
                  pw.Image(interceramic),
                  pw.SizedBox(height: 7),
                  pw.Row(children: [
                    pw.Expanded(
                      child: pw.Image(cato),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Expanded(
                      child: pw.Image(lamosa),
                    )
                  ]),
                  pw.SizedBox(height: 7),
                  pw.Row(children: [
                    pw.Expanded(
                      child: pw.Image(vitromex),
                    ),
                    pw.SizedBox(width: 15),
                    pw.Expanded(
                      child: pw.Image(cesantoni),
                    )
                  ]),
                  pw.Text(numeroNota,
                      style: pw.TextStyle(fontSize: 30, color: PdfColors.red))

                  /// logos
                  /// Numero
                ]))),
        pw.Expanded(
            flex: 2,
            child: pw.Column(children: [
              pw.Row(children: [
                pw.Expanded(
                    child: pw.Column(children: [
                  pw.Image(reyco),
                  pw.Text('Distribuidor Autorizado',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 13, color: PdfColors.red)),
                  pw.Text(direccionTienda,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 9, color: PdfColors.red))

                  /// REYCO
                ])),
                pw.Expanded(
                    child: pw.Padding(
                        padding: pw.EdgeInsets.only(left: 30),
                        child: pw.Column(children: [
                          pw.Text(sucursal,
                              style: pw.TextStyle(
                                  fontSize: 25, color: PdfColors.red)),
                          pw.Container(
                              decoration: pw.BoxDecoration(
                                  color: PdfColors.blueGrey700),
                              child: pw.Row(children: [
                                pw.Spacer(),
                                pw.Text('NOTA DE',
                                    style: pw.TextStyle(
                                        fontSize: 14, color: PdfColors.white)),
                                pw.Spacer(),
                              ])),
                          pw.SizedBox(height: 2),
                          pw.Text(tipoNota,
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColors.black)),
                          pw.SizedBox(height: 2),
                          pw.Container(
                              decoration: pw.BoxDecoration(
                                  color: PdfColors.blueGrey700),
                              child: pw.Row(children: [
                                pw.Spacer(),
                                pw.Text('FECHA',
                                    style: pw.TextStyle(
                                        fontSize: 14, color: PdfColors.white)),
                                pw.Spacer(),
                              ])),
                          pw.SizedBox(height: 2),
                          pw.Text('${Fecha.fecha(DateTime.now())}',
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColors.black)),
                          pw.SizedBox(height: 2),

                          /// Matriz
                        ])))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text(isEntrada ? 'Provedor: ' : 'Cliente: ',
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Expanded(
                    child: pw.Column(children: [
                  pw.Text('$nombreCliente',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.normal,
                      )),
                  pw.Divider(indent: 1, height: 1)
                ]))
              ]),
              pw.Row(children: [
                pw.Text('Dirección: ',
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Expanded(
                    child: pw.Column(children: [
                  pw.Text('$direccionCliente',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.normal,
                      )),
                  pw.Divider(indent: 1, height: 1)
                ]))
              ]),
              pw.Row(children: [
                pw.Text('Telefono: ',
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Expanded(
                    child: pw.Column(children: [
                  pw.Text('$phoneCliente',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.normal,
                      )),
                  pw.Divider(indent: 1, height: 1)
                ]))
              ]),
              pw.SizedBox(height: 5),
              //7 Cliente
              // Direccion
              // Telefono
            ]))
      ])
    ]);
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ), /*
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _logo),
      ), */
    );
  }
}

class Product {
  const Product(
    this.productName,
    this.price,
    this.quantity,
  );

  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return quantity.toString();
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return _formatCurrency(total);
    }
    return '';
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}
