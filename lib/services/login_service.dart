import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/sesion.dart';

class LoginService {
  Future<Sesion> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$apiBaseUrl/usuarios/login');
    final body = jsonEncode({'email': email, 'password': password});

    try {
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      final dynamic data = jsonDecode(utf8.decode(res.bodyBytes));

      if (res.statusCode == 200) {
        return Sesion.fromMap(data as Map<String, dynamic>);
      }

      final mensaje = data is Map<String, dynamic>
          ? (data['message'] ??
              data['detail'] ??
              data['title'] ??
              'HTTP ${res.statusCode}')
          : 'HTTP ${res.statusCode}';
      throw Exception(mensaje.toString());
    } on Exception catch (e) {
      throw Exception('No se pudo iniciar sesión: $e');
    }
  }
}
