import 'package:flutter/foundation.dart';
import '../services/login_service.dart';
import '../models/sesion.dart';
import '../services/sesion_storage.dart';

class LoginController extends ChangeNotifier {
  bool cargando = false;

  Future<Sesion> iniciarSesion({
    required String email,
    required String password,
  }) async {
    cargando = true;
    notifyListeners();

    try {
      final sesion = await LoginService()
          .iniciarSesion(email: email, password: password);
      await SesionStorage().guardar(sesion);
      cargando = false;
      notifyListeners();
      return sesion;
    } catch (e) {
      cargando = false;
      notifyListeners();
      rethrow;
    }
  }
}
