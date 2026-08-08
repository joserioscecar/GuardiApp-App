class Denuncia {
  const Denuncia({
    this.tipoDenunciante = '',
    this.discriminacion = '',
    this.subDisc = '',
    this.genero = '',
    this.edad = '',
    this.grupo = '',
    this.entorno = '',
    this.subEntorno = '',
    this.personas = const [],
    this.institucion = '',
    this.descripcion = '',
    this.fecha = '',
    this.lugar = '',
    this.imagenes = const [],
  });

  final String tipoDenunciante;
  final String discriminacion;
  final String subDisc;
  final String genero;
  final String edad;
  final String grupo;
  final String entorno;
  final String subEntorno;
  final List<String> personas;
  final String institucion;
  final String descripcion;
  final String fecha;
  final String lugar;
  final List<String> imagenes;

  Map<String, dynamic> toMap() {
    return {
      'tipoDenunciante': tipoDenunciante,
      'discriminacion': discriminacion,
      'subDisc': subDisc,
      'genero': genero,
      'edad': edad,
      'grupo': grupo,
      'entorno': entorno,
      'subEntorno': subEntorno,
      'personas': personas,
      'institucion': institucion,
      'descripcion': descripcion,
      'fecha': fecha,
      'lugar': lugar,
      'imagenes': imagenes,
    };
  }

  factory Denuncia.fromMap(Map<String, dynamic> map) {
    return Denuncia(
      tipoDenunciante: map['tipoDenunciante'] as String? ?? '',
      discriminacion: map['discriminacion'] as String? ?? '',
      subDisc: map['subDisc'] as String? ?? '',
      genero: map['genero'] as String? ?? '',
      edad: map['edad'] as String? ?? '',
      grupo: map['grupo'] as String? ?? '',
      entorno: map['entorno'] as String? ?? '',
      subEntorno: map['subEntorno'] as String? ?? '',
      personas: List<String>.from(map['personas'] as List? ?? const []),
      institucion: map['institucion'] as String? ?? '',
      descripcion: map['descripcion'] as String? ?? '',
      fecha: map['fecha'] as String? ?? '',
      lugar: map['lugar'] as String? ?? '',
      imagenes: List<String>.from(map['imagenes'] as List? ?? const []),
    );
  }

  Denuncia copyWith({
    String? tipoDenunciante,
    String? discriminacion,
    String? subDisc,
    String? genero,
    String? edad,
    String? grupo,
    String? entorno,
    String? subEntorno,
    List<String>? personas,
    String? institucion,
    String? descripcion,
    String? fecha,
    String? lugar,
    List<String>? imagenes,
  }) {
    return Denuncia(
      tipoDenunciante: tipoDenunciante ?? this.tipoDenunciante,
      discriminacion: discriminacion ?? this.discriminacion,
      subDisc: subDisc ?? this.subDisc,
      genero: genero ?? this.genero,
      edad: edad ?? this.edad,
      grupo: grupo ?? this.grupo,
      entorno: entorno ?? this.entorno,
      subEntorno: subEntorno ?? this.subEntorno,
      personas: personas ?? this.personas,
      institucion: institucion ?? this.institucion,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      lugar: lugar ?? this.lugar,
      imagenes: imagenes ?? this.imagenes,
    );
  }
}
