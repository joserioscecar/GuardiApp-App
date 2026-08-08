class SubtipoDiscriminacion {
  const SubtipoDiscriminacion({
    this.id = '',
    this.nombre = '',
  });

  final String id;
  final String nombre;

  factory SubtipoDiscriminacion.fromMap(Map<String, dynamic> json) {
    return SubtipoDiscriminacion(
      id: (json['id'] as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}

class TipoDiscriminacion {
  const TipoDiscriminacion({
    this.id = '',
    this.nombre = '',
    this.subtipos = const [],
  });

  final String id;
  final String nombre;
  final List<SubtipoDiscriminacion> subtipos;

  factory TipoDiscriminacion.fromMap(Map<String, dynamic> json) {
    return TipoDiscriminacion(
      id: (json['id'] as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      subtipos: (json['subtipos'] as List<dynamic>?)
              ?.map((st) =>
                  SubtipoDiscriminacion.fromMap(st as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'subtipos': subtipos.map((st) => st.toMap()).toList(),
    };
  }
}
