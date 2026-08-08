import 'package:flutter/foundation.dart';
import '../services/registro_service.dart';

class SignupController extends ChangeNotifier {
  bool cargando = false;

  Future<void> registrar({
    required String nombreCompleto,
    required String correo,
    required String password,
  }) async {
    cargando = true;
    notifyListeners();

    try {
      await RegistroService().registrar(
        nombreCompleto: nombreCompleto,
        correo: correo,
        password: password,
      );
      cargando = false;
      notifyListeners();
    } catch (e) {
      cargando = false;
      notifyListeners();
      rethrow;
    }
  }
}
