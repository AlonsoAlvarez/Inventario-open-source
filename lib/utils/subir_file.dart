import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:inventario/constants/storage.dart';
import 'package:inventario/utils/fecha.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<String> uploadPicture(File file, String nombre, Folder folder) async {
  FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: Bucket);
  UploadTask _uploadTask;
  String filePath =
      '${casoFolder(folder.index)}/${Fecha.fechaHoraFiles(DateTime.now())}_${nombreGuiones(nombre)}';
  _uploadTask = _storage.ref().child(filePath).putFile(file);
  String url = await (await _uploadTask).ref.getDownloadURL();
  return url;
}

Future<String> uploadFile(File file, String nombre, Folder folder) async {
  FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: Bucket);
  String filePath =
      '${casoFolder(folder.index)}/${Fecha.fechaHoraFiles(DateTime.now())}_${nombreGuiones(nombre)}';
  UploadTask _uploadTask;
  _uploadTask = _storage.ref().child(filePath).putFile(file);
  String url = await (await _uploadTask).ref.getDownloadURL();
  return url;
}

String nombreGuiones(String name) {
  return name.replaceAll(' ', '_');
}

Future<void> deleteFile(String url) async {
  FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: Bucket);
  Reference refer = _storage.refFromURL(url);
  await refer.delete();
}

Future<File> getFileFromUrl(String url) async {
  try {
    var data = await http.get(url);
    var bytes = data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/mi_archivo_online.pdf");
    File urlFile = await file.writeAsBytes(bytes);
    return urlFile;
  } catch (e) {
    throw Exception("Error al abrir el archivo");
  }
}

enum Folder {
  productos,
  marcas,
  categorias,
  usuarios,
  ventas,
  entradas,
  promociones,
  semanas
}

String casoFolder(int index) {
  switch (index) {
    case 0:
      return 'productos';
      break;
    case 1:
      return 'marcas';
      break;
    case 2:
      return 'categorias';
      break;
    case 3:
      return 'usuarios';
      break;
    case 4:
      return 'ventas';
      break;
    case 5:
      return 'entradas';
      break;
    case 6:
      return 'promociones';
      break;
    case 7:
      return 'semanas';
      break;
    default:
      return 'desconocidos';
  }
}
