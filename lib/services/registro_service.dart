import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class RegistroService {
  Future<void> registrar({
    required String nombreCompleto,
    required String correo,
    required String password,
  }) async {
    final uri = Uri.parse('$apiBaseUrl/api/usuarios');
    final body = jsonEncode({
      'nombreCompleto': nombreCompleto,
      'correo': correo,
      'password': password,
    });

    debugPrint('POST $uri');
    debugPrint('Body: $body');

    try {
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      final resBody = utf8.decode(res.bodyBytes);
      debugPrint('Status: ${res.statusCode}');
      debugPrint('Response: $resBody');

      if (res.statusCode == 200 || res.statusCode == 201) {
        return;
      }

      dynamic data;
      try {
        data = jsonDecode(resBody);
      } catch (_) {
        data = null;
      }

      if (data is Map<String, dynamic>) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final mensajes = <String>[];
          for (final entry in errors.entries) {
            final valor = entry.value;
            if (valor is List) {
              for (final e in valor) {
                mensajes.add(e.toString());
              }
            } else {
              mensajes.add(valor.toString());
            }
          }
          if (mensajes.isNotEmpty) {
            throw Exception(mensajes.join('\n'));
          }
        }
        final mensaje = data['message'] ??
            data['detail'] ??
            data['title'] ??
            'HTTP ${res.statusCode}';
        throw Exception(mensaje.toString());
      }
      throw Exception('HTTP ${res.statusCode}');
    } on Exception catch (e) {
      debugPrint('Error: $e');
      throw Exception('No se pudo registrar: $e');
    }
  }
}
