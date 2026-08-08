import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sesion.dart';

class SesionStorage {
  static const _tokenKey = 'auth_token';
  static const _sesionKey = 'auth_sesion';

  Future<void> guardar(Sesion sesion) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, sesion.token);
    await prefs.setString(_sesionKey, jsonEncode(sesion.toMap()));
  }

  Future<Sesion?> obtener() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sesionKey);
    if (raw == null || raw.isEmpty) return null;
    final sesion = Sesion.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    if (sesion.token.isEmpty || sesion.estaExpirada) {
      await _limpiar(prefs);
      return null;
    }
    return sesion;
  }

  Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sesionKey);
    if (raw == null || raw.isEmpty) return null;
    final sesion = Sesion.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    if (sesion.token.isEmpty || sesion.estaExpirada) {
      await _limpiar(prefs);
      return null;
    }
    return sesion.token;
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await _limpiar(prefs);
  }

  Future<void> _limpiar(SharedPreferences prefs) async {
    await prefs.remove(_tokenKey);
    await prefs.remove(_sesionKey);
  }
}
