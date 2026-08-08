import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagenService {
  Future<List<String>> comprimir(
    List<String> rutas, {
    int calidad = 70,
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    final comprimidas = <String>[];
    final tempDir = Directory.systemTemp;
    for (final ruta in rutas) {
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}_${comprimidas.length}.jpg';
      try {
        final result = await FlutterImageCompress.compressAndGetFile(
          ruta,
          targetPath,
          quality: calidad,
          minWidth: minWidth,
          minHeight: minHeight,
        );
        if (result != null) {
          comprimidas.add(result.path);
        } else {
          comprimidas.add(ruta);
        }
      } catch (_) {
        comprimidas.add(ruta);
      }
    }
    return comprimidas;
  }
}
