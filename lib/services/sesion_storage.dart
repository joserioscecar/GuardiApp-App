import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sesion.dart';
import 'refresh_service.dart';

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
    if (sesion.token.isEmpty) return null;
    return sesion;
  }

  Future<String?> obtenerToken() async {
    final sesion = await obtener();
    return sesion?.token;
  }

  Future<String?> obtenerTokenValido() async {
    final sesion = await obtener();
    if (sesion == null) return null;

    if (!sesion.estaExpirada) return sesion.token;

    if (sesion.refreshToken.isEmpty) {
      await cerrarSesion();
      return null;
    }

    try {
      final nuevaSesion =
          await RefreshService().refrescar(sesion.refreshToken);
      await guardar(nuevaSesion);
      return nuevaSesion.token;
    } catch (_) {
      await cerrarSesion();
      return null;
    }
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
