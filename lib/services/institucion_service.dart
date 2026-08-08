import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/institucion.dart';

class InstitucionService {
  Future<List<Institucion>> listar() async {
    final uri = Uri.parse('$apiBaseUrl/api/instituciones');
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        throw Exception(
            'Error $res.statusCode al consultar instituciones');
      }
      final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
      return data
          .map((item) =>
              Institucion.fromMap(item as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      throw Exception('No se pudo cargar instituciones: $e');
    }
  }
}
