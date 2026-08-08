import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/tipo_discriminacion.dart';

class TipoDiscriminacionService {
  Future<List<TipoDiscriminacion>> listar() async {
    final uri = Uri.parse('$apiBaseUrl/api/tipos-discriminacion');
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        throw Exception('Error $res.statusCode al consultar tipos de discriminación');
      }
      final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
      return data
          .map((item) =>
              TipoDiscriminacion.fromMap(item as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      throw Exception('No se pudo cargar tipos de discriminación: $e');
    }
  }
}
