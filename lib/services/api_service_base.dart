import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/catalogo_item.dart';

abstract class ApiServiceBase {
  Future<List<CatalogoItem>> fetchLista({
    required String endpoint,
    String idKey = 'id',
    String nombreKey = 'nombre',
  }) async {
    final uri = Uri.parse('$apiBaseUrl$endpoint');
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        throw Exception('Error $res.statusCode al consultar $endpoint');
      }
      final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
      return data.map((item) {
        return CatalogoItem(
          id: (item[idKey] ?? '').toString(),
          nombre: (item[nombreKey] ?? '').toString(),
        );
      }).toList();
    } on Exception catch (e) {
      throw Exception('No se pudo cargar $endpoint: $e');
    }
  }
}
