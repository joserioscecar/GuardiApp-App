class Institucion {
  const Institucion({
    this.id = '',
    this.nombre = '',
    this.descripcion,
  });

  final String id;
  final String nombre;
  final String? descripcion;

  factory Institucion.fromMap(Map<String, dynamic> json) {
    return Institucion(
      id: (json['id'] as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      descripcion: (json['descripcion'] as String?)?.trim(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
