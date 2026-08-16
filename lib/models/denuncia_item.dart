class PersonaDenunciada {
  const PersonaDenunciada({this.nombre = ''});

  final String nombre;

  factory PersonaDenunciada.fromMap(Map<String, dynamic> json) {
    return PersonaDenunciada(
      nombre: (json['nombre'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'nombre': nombre};
}

class DenunciaItem {
  const DenunciaItem({
    this.id = '',
    this.radicado = '',
    this.tipoDenunciante = '',
    this.discriminacion = '',
    this.subTipo = '',
    this.genero = '',
    this.edad = '',
    this.grupo = '',
    this.entorno = '',
    this.subEntorno = '',
    this.personasDenunciadas = const [],
    this.institucionNombre = '',
    this.descripcion = '',
    this.fecha = '',
    this.lugar = '',
    this.evidencias = const [],
  });

  final String id;
  final String radicado;
  final String tipoDenunciante;
  final String discriminacion;
  final String subTipo;
  final String genero;
  final String edad;
  final String grupo;
  final String entorno;
  final String subEntorno;
  final List<PersonaDenunciada> personasDenunciadas;
  final String institucionNombre;
  final String descripcion;
  final String fecha;
  final String lugar;
  final List<String> evidencias;

  factory DenunciaItem.fromMap(Map<String, dynamic> json) {
    return DenunciaItem(
      id: (json['id'] as String?) ?? '',
      radicado: (json['radicado'] as String?) ?? '',
      tipoDenunciante: (json['tipoDenunciante'] as String?) ?? '',
      discriminacion: (json['discriminacion'] as String?) ?? '',
      subTipo: (json['subTipo'] as String?) ?? '',
      genero: (json['genero'] as String?) ?? '',
      edad: json['edad']?.toString() ?? '',
      grupo: (json['grupo'] as String?) ?? '',
      entorno: (json['entorno'] as String?) ?? '',
      subEntorno: (json['subEntorno'] as String?) ?? '',
      personasDenunciadas: (json['personasDenunciadas'] as List<dynamic>?)
              ?.map((p) =>
                  PersonaDenunciada.fromMap(p as Map<String, dynamic>))
              .toList() ??
          const [],
      institucionNombre: (json['institucionNombre'] as String?) ?? '',
      descripcion: (json['descripcion'] as String?) ?? '',
      fecha: (json['fecha'] as String?) ?? '',
      lugar: (json['lugar'] as String?) ?? '',
      evidencias: List<String>.from(
          (json['evidencias'] ?? json['imagenes']) as List? ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'radicado': radicado,
      'tipoDenunciante': tipoDenunciante,
      'discriminacion': discriminacion,
      'subTipo': subTipo,
      'genero': genero,
      'edad': edad,
      'grupo': grupo,
      'entorno': entorno,
      'subEntorno': subEntorno,
      'personasDenunciadas': personasDenunciadas.map((p) => p.toMap()).toList(),
      'institucionNombre': institucionNombre,
      'descripcion': descripcion,
      'fecha': fecha,
      'lugar': lugar,
      'evidencias': evidencias,
    };
  }
}
