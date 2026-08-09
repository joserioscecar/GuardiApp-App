class Sesion {
  const Sesion({
    this.token = '',
    this.refreshToken = '',
    this.expiracion = '',
    this.usuarioId = '',
    this.nombreCompleto = '',
    this.correo = '',
  });

  final String token;
  final String refreshToken;
  final String expiracion;
  final String usuarioId;
  final String nombreCompleto;
  final String correo;

  bool get estaExpirada {
    if (expiracion.isEmpty) return true;
    try {
      final fecha = DateTime.parse(expiracion);
      return fecha.isBefore(DateTime.now().toUtc());
    } catch (_) {
      return true;
    }
  }

  factory Sesion.fromMap(Map<String, dynamic> json) {
    return Sesion(
      token: (json['token'] as String?) ?? '',
      refreshToken: (json['refreshToken'] as String?) ?? '',
      expiracion: (json['expiracion'] as String?) ?? '',
      usuarioId: (json['usuarioId'] as String?) ?? '',
      nombreCompleto: (json['nombreCompleto'] as String?) ?? '',
      correo: (json['correo'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiracion': expiracion,
      'usuarioId': usuarioId,
      'nombreCompleto': nombreCompleto,
      'correo': correo,
    };
  }
}
