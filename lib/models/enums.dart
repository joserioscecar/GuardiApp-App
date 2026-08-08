enum TipoDenunciante {
  victima('Víctima'),
  testigo('Testigo');

  const TipoDenunciante(this.label);
  final String label;
}

enum Genero {
  mujer('Mujer'),
  hombre('Hombre'),
  otro('Otro');

  const Genero(this.label);
  final String label;
}

enum TipoDiscriminacion {
  lgbtiq('Discriminación LGBTIQ+'),
  racismo('Racismo o xenofobia'),
  bullying('Bullying escolar'),
  violenciaGenero('Violencia de género'),
  acosoLaboral('Acoso laboral'),
  maltratoInstitucional('Maltrato institucional');

  const TipoDiscriminacion(this.label);
  final String label;
}

enum GrupoPoblacional {
  mujer('Mujer'),
  hombre('Hombre'),
  lgbtiq('LGBTIQ+'),
  adultoMayor('Adulto mayor'),
  discapacidad('Persona con discapacidad'),
  migrante('Migrante'),
  ninoNina('Niño/Niña');

  const GrupoPoblacional(this.label);
  final String label;
}

enum Entorno {
  familiar('Familiar'),
  social('Social'),
  academico('Académico'),
  institucional('Institucional');

  const Entorno(this.label);
  final String label;
}

enum Institucion {
  fiscalia('Fiscalía'),
  defensorias('Defensoría del Pueblo'),
  policia('Policía');

  const Institucion(this.label);
  final String label;
}

enum SubtipoDiscriminacion {
  agresionVerbal('Agresión verbal'),
  exclusion('Exclusión'),
  violencia('Violencia'),
  insultosRaciales('Insultos raciales'),
  acoso('Acoso'),
  hostigamiento('Hostigamiento'),
  violenciaPsicologica('Violencia psicológica'),
  presion('Presión'),
  discriminacionLaboral('Discriminación laboral'),
  negacionServicios('Negación de servicios');

  const SubtipoDiscriminacion(this.label);
  final String label;
}

const subtiposPorDiscriminacion = {
  TipoDiscriminacion.lgbtiq: [
    SubtipoDiscriminacion.agresionVerbal,
    SubtipoDiscriminacion.exclusion,
    SubtipoDiscriminacion.violencia,
  ],
  TipoDiscriminacion.racismo: [
    SubtipoDiscriminacion.insultosRaciales,
    SubtipoDiscriminacion.exclusion,
  ],
  TipoDiscriminacion.bullying: [
    SubtipoDiscriminacion.acoso,
    SubtipoDiscriminacion.hostigamiento,
  ],
  TipoDiscriminacion.violenciaGenero: [
    SubtipoDiscriminacion.acoso,
    SubtipoDiscriminacion.violenciaPsicologica,
  ],
  TipoDiscriminacion.acosoLaboral: [
    SubtipoDiscriminacion.presion,
    SubtipoDiscriminacion.discriminacionLaboral,
  ],
  TipoDiscriminacion.maltratoInstitucional: [
    SubtipoDiscriminacion.negacionServicios,
  ],
};

extension TipoDenuncianteX on TipoDenunciante {
  static TipoDenunciante fromLabel(String label) =>
      TipoDenunciante.values.firstWhere((e) => e.label == label);
}

extension GeneroX on Genero {
  static Genero fromLabel(String label) =>
      Genero.values.firstWhere((e) => e.label == label);
}

extension TipoDiscriminacionX on TipoDiscriminacion {
  static TipoDiscriminacion fromLabel(String label) =>
      TipoDiscriminacion.values.firstWhere((e) => e.label == label);
}

extension GrupoPoblacionalX on GrupoPoblacional {
  static GrupoPoblacional fromLabel(String label) =>
      GrupoPoblacional.values.firstWhere((e) => e.label == label);
}

extension EntornoX on Entorno {
  static Entorno fromLabel(String label) =>
      Entorno.values.firstWhere((e) => e.label == label);
}

extension InstitucionX on Institucion {
  static Institucion fromLabel(String label) =>
      Institucion.values.firstWhere((e) => e.label == label);
}

extension SubtipoDiscriminacionX on SubtipoDiscriminacion {
  static SubtipoDiscriminacion fromLabel(String label) =>
      SubtipoDiscriminacion.values.firstWhere((e) => e.label == label);
}
