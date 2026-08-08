import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/denuncia_item.dart';

class DenunciaService {
  Future<String> enviar({
    required String token,
    required Map<String, String> campos,
    List<String> personas = const [],
    List<String> rutasImagenes = const [],
  }) async {
    final uri = Uri.parse('$apiBaseUrl/api/denuncias');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(campos);

    for (final p in personas) {
      request.files.add(
        http.MultipartFile.fromString(
          'Personas',
          p,
          contentType: MediaType('text', 'plain'),
        ),
      );
    }

    for (final ruta in rutasImagenes) {
      request.files.add(await http.MultipartFile.fromPath('imagenes', ruta));
    }

    try {
      final streamed = await request.send().timeout(const Duration(seconds: 30));
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 201) {
        final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
        return (data['radicado'] as String?) ?? '';
      }
      final detalle = res.body.isNotEmpty
          ? res.body
          : 'HTTP ${res.statusCode}';
      throw Exception(detalle);
    } on Exception catch (e) {
      throw Exception('No se pudo enviar la denuncia: $e');
    }
  }

  Future<List<DenunciaItem>> listar({required String token}) async {
    final uri = Uri.parse('$apiBaseUrl/api/denuncias');
    try {
      final res = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
        return data
            .map((item) => DenunciaItem.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      final detalle = res.body.isNotEmpty ? res.body : 'HTTP ${res.statusCode}';
      throw Exception(detalle);
    } on Exception catch (e) {
      throw Exception('No se pudo cargar la lista de denuncias: $e');
    }
  }
}
