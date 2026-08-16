import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/sesion.dart';

class RefreshService {
  Future<Sesion> refrescar(String refreshToken) async {
    final uri = Uri.parse('$apiBaseUrl/usuarios/refresh');
    final body = jsonEncode({'token': refreshToken});

    try {
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      final resBody = utf8.decode(res.bodyBytes);

      if (res.statusCode == 200) {
        final data = jsonDecode(resBody) as Map<String, dynamic>;
        return Sesion.fromMap(data);
      }

      throw Exception(res.statusCode.toString());
    } on Exception catch (e) {
      rethrow;
    }
  }
}
