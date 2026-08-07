import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_flutter/widgets/fila_Icono.dart';
import '../widgets/Campo_texto.dart';
import '../widgets/label.dart';
import 'success_screen.dart';
import '../theme/colores.dart';
import '../widgets/dropdown_gris.dart';

// ── Datos ──────────────────────────────────
const _lugares = [
  'Centro', 'Norte', 'Sur', 'Oriente', 'Occidente',
  'Barrio El Bosque', 'Barrio La Palma',
];

const _tiposDiscriminacion = [
  'Discriminación LGBTIQ+', 'Racismo o xenofobia', 'Bullying escolar',
  'Violencia de género', 'Acoso laboral', 'Maltrato institucional',
];

const _subtipos = {
  'Discriminación LGBTIQ+': ['Agresión verbal', 'Exclusión', 'Violencia'],
  'Racismo o xenofobia':    ['Insultos raciales', 'Exclusión'],
  'Bullying escolar':       ['Acoso', 'Hostigamiento'],
  'Violencia de género':    ['Acoso', 'Violencia psicológica'],
  'Acoso laboral':          ['Presión', 'Discriminación laboral'],
  'Maltrato institucional': ['Negación de servicios'],
};

const _tiposAcoso     = ['Acoso sexual', 'Acoso escolar', 'Acoso laboral', 'Ciberbullying'];
const _tiposViolencia = ['Física', 'Psicológica', 'Sexual', 'Económica'];
const _gruposPob      = [
  'Mujer', 'Hombre', 'LGBTIQ+', 'Adulto mayor',
  'Persona con discapacidad', 'Migrante', 'Niño/Niña',
];

const _entornos = {
  'Familiar':      ['Padre', 'Madre', 'Hermanos', 'Abuelos', 'Tíos', 'Otros'],
  'Social':        ['Calle', 'Parque', 'Otros'],
  'Académico':     ['Colegios', 'Universidades', 'Fundaciones', 'Corporaciones'],
  'Institucional': ['Entidades públicas', 'Clínicas', 'EPS', 'IPS', 'ESE'],
};

const _instituciones = [
  {
    'nombre': 'Fiscalía',
    'descripcion': 'Selecciona esta opción si hubo amenazas, agresiones físicas, violencia sexual, extorsión, lesiones, delitos informáticos u otros hechos que puedan constituir un delito.',
  },
  {
    'nombre': 'Defensoría del Pueblo',
    'descripcion': 'Selecciona esta opción si estás siendo víctima de discriminación, acoso, vulneración de derechos o necesitas acompañamiento y asesoría.',
  },
  {
    'nombre': 'Policía',
    'descripcion': 'Selecciona esta opción si existe una emergencia, una amenaza en curso, riesgo para tu integridad o necesitas atención inmediata.',
  },
];

// ─────────────────────────────────────────────────────────
class DenunciarScreen extends StatefulWidget {
  const DenunciarScreen({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<DenunciarScreen> createState() => _DenunciarScreenState();
}

class _DenunciarScreenState extends State<DenunciarScreen> {
  int _paso = 0;

  String descripcion     = '';
  String lugar           = '';
  String fecha           = '';
  String tipoDenunciante = '';
  String genero          = '';
  String edad            = '';
  String discriminacion  = '';
  String subDisc         = '';
  String acoso           = '';
  String violencia       = '';
  String grupo           = '';
  String entorno         = '';
  String subEntorno      = '';
  String personas        = '';
  String institucion     = '';

  final Map<String, bool> touched = {
    'descripcion': false,
    'lugar': false,
    'fecha': false,
    'tipoDenunciante': false,
    'genero': false,
    'edad': false,
    'discriminacion': false,
    'subDisc': false,
    'acoso': false,
    'violencia': false,
    'grupo': false,
    'entorno': false,
    'subEntorno': false,
    'personas': false,
    'institucion': false,
  };

  List<XFile> imagenes = [];
  final ImagePicker _picker = ImagePicker();

  static const _titulosPaso = [
    'Detalles de la Denuncia',
    '¿Cuándo y dónde ocurrió?',
    '¿Deseas redireccionar tu denuncia?',
    'Evidencias y Envío',
  ];

  bool _esPasoValido() {
    switch (_paso) {
      case 0:
        return tipoDenunciante.isNotEmpty &&
            genero.isNotEmpty &&
            edad.isNotEmpty &&
            discriminacion.isNotEmpty &&
            descripcion.isNotEmpty &&
            grupo.isNotEmpty &&
            entorno.isNotEmpty &&
            subEntorno.isNotEmpty &&
            personas.isNotEmpty;
      case 1:
        return fecha.isNotEmpty && lugar.isNotEmpty;
      case 2:
        return institucion.isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _marcarTocados() {
    setState(() {
      switch (_paso) {
        case 0:
          touched['tipoDenunciante'] = true;
          touched['genero'] = true;
          touched['edad'] = true;
          touched['discriminacion'] = true;
          touched['descripcion'] = true;
          touched['grupo'] = true;
          touched['entorno'] = true;
          touched['subEntorno'] = true;
          touched['personas'] = true;
          break;
        case 1:
          touched['fecha'] = true;
          touched['lugar'] = true;
          break;
        case 2:
          touched['institucion'] = true;
          break;
      }
    });
  }

  void _siguiente() {
    if (_esPasoValido()) {
      setState(() => _paso++);
    } else {
      _marcarTocados();
    }
  }

  void _anterior() {
    if (_paso > 0) setState(() => _paso--);
    else widget.onBack();
  }

  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: DateTime(2000),
      lastDate: ahora,
      locale: const Locale('es', 'ES'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primario,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        fecha = DateFormat('dd/MM/yyyy', 'es_ES').format(picked);
        touched['fecha'] = true;
      });
    }
  }

  Future<void> _seleccionarImagenes() async {
    try {
      final List<XFile> seleccionadas = await _picker.pickMultiImage();
      if (seleccionadas.isNotEmpty) {
        setState(() => imagenes.addAll(seleccionadas));
      }
    } catch (e) {
      debugPrint('Error al seleccionar imágenes: $e');
    }
  }

  void _enviar() {
    final datosDenuncia = {
      'descripcion': descripcion,
      'lugar': lugar,
      'fecha': fecha,
      'tipoDenunciante': tipoDenunciante,
      'genero': genero,
      'edad': edad,
      'discriminacion': discriminacion,
      'subDisc': subDisc,
      'acoso': acoso,
      'violencia': violencia,
      'grupo': grupo,
      'entorno': entorno,
      'subEntorno': subEntorno,
      'personas': personas,
      'institucion': institucion,
      'imagenes': imagenes.map((img) => img.path).toList(),
    };

    debugPrint('--- DATOS CAPTURADOS ---');
    datosDenuncia.forEach((key, value) => debugPrint('$key: $value'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primario),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        title: Text(
          'Nueva denuncia',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _anterior,
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(pasoActual: _paso),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Text(
              _titulosPaso[_paso],
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textoOscuro,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildPasoActual(),
            ),
          ),
          // ── Botones Anterior / Siguiente ──
          _BotonesInferiores(
            paso: _paso,
            totalPasos: 4,
            onAnterior: _anterior,
            onSiguiente: _siguiente,
            onEnviar: _enviar,
          ),
        ],
      ),
    );
  }

  Widget _buildPasoActual() {
    switch (_paso) {
      case 0: return _buildPaso1();
      case 1: return _buildPaso2();
      case 2: return _buildPaso3();
      case 3: return _buildPaso4();
      default: return const SizedBox();
    }
  }

  // ─────────── PASO 1 ───────────
  Widget _buildPaso1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label('¿Eres víctima o testigo?'),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: tipoDenunciante.isEmpty && touched['tipoDenunciante']!
                  ? Colors.red : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: ['Víctima', 'Testigo'].map((op) {
              final sel = tipoDenunciante == op;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    tipoDenunciante = op;
                    touched['tipoDenunciante'] = true;
                  }),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: op == 'Víctima' ? 6 : 0,
                      left: op == 'Testigo' ? 6 : 0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primario : AppColors.fondoCampo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      op,
                      style: GoogleFonts.inter(
                        color: sel ? Colors.white : AppColors.textoGris,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Label('Género'),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: genero.isEmpty && touched['genero']! ? Colors.red : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(4),
          child: Wrap(
            spacing: 8,
            children: ['Mujer', 'Hombre', 'Otro'].map((g) {
              final sel = genero == g;
              return GestureDetector(
                onTap: () => setState(() {
                  genero = g;
                  touched['genero'] = true;
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primario : AppColors.fondoCampo,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    g,
                    style: GoogleFonts.inter(
                      color: sel ? Colors.white : AppColors.textoGris,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        Label('Edad'),
        CampoTexto(
          valor: edad,
          placeholder: 'Ej: 25',
          keyboardType: TextInputType.number,
          maxLength: 3,
          isInvalid: edad.isEmpty && touched['edad']!,
          onValorChange: (v) => setState(() {
            edad = v;
            if (v.isNotEmpty) touched['edad'] = true;
          }),
        ),
        const SizedBox(height: 20),
        Label('¿Qué tipo de situación deseas denunciar?'),
        DropdownGris(
          valor: discriminacion,
          placeholder: 'Selecciona la situación',
          opciones: _tiposDiscriminacion,
          isInvalid: discriminacion.isEmpty && touched['discriminacion']!,
          onSeleccionar: (v) => setState(() {
            discriminacion = v;
            subDisc = '';
            touched['discriminacion'] = true;
          }),
        ),
        if (discriminacion.isNotEmpty) ...[
          const SizedBox(height: 12),
          DropdownGris(
            valor: subDisc,
            placeholder: 'Selecciona el subtipo',
            opciones: _subtipos[discriminacion] ?? [],
            isInvalid: subDisc.isEmpty && touched['subDisc']!,
            onSeleccionar: (v) => setState(() {
              subDisc = v;
              touched['subDisc'] = true;
            }),
          ),
        ],
        const SizedBox(height: 20),
        Label('¿Qué ocurrió?'),
        CampoTexto(
          valor: descripcion,
          placeholder: 'Describe lo ocurrido',
          maxLines: 4,
          isInvalid: descripcion.isEmpty && touched['descripcion']!,
          onValorChange: (v) => setState(() {
            descripcion = v;
            if (v.isNotEmpty) touched['descripcion'] = true;
          }),
        ),
        const SizedBox(height: 20),
        Label('Grupo poblacional'),
        DropdownGris(
          valor: grupo,
          placeholder: 'Selecciona el grupo',
          opciones: _gruposPob,
          isInvalid: grupo.isEmpty && touched['grupo']!,
          onSeleccionar: (v) => setState(() {
            grupo = v;
            touched['grupo'] = true;
          }),
        ),
        const SizedBox(height: 20),
        Label('Tipo de entorno'),
        DropdownGris(
          valor: entorno,
          placeholder: 'Selecciona el entorno',
          opciones: _entornos.keys.toList(),
          isInvalid: entorno.isEmpty && touched['entorno']!,
          onSeleccionar: (v) => setState(() {
            entorno = v;
            subEntorno = '';
            touched['entorno'] = true;
          }),
        ),
        if (entorno.isNotEmpty) ...[
          const SizedBox(height: 12),
          DropdownGris(
            valor: subEntorno,
            placeholder: 'Especifica el lugar',
            opciones: _entornos[entorno] ?? [],
            isInvalid: subEntorno.isEmpty && touched['subEntorno']!,
            onSeleccionar: (v) => setState(() {
              subEntorno = v;
              touched['subEntorno'] = true;
            }),
          ),
        ],
        const SizedBox(height: 20),
        Label('Personas involucradas'),
        CampoTexto(
          valor: personas,
          placeholder: 'Escribe los nombres',
          isInvalid: personas.isEmpty && touched['personas']!,
          onValorChange: (v) => setState(() {
            personas = v;
            if (v.isNotEmpty) touched['personas'] = true;
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ─────────── PASO 2 ───────────
  Widget _buildPaso2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label('Fecha'),
        Text(
          'Selecciona la fecha',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textoGris),
        ),
        const SizedBox(height: 8),
        FilaIcono(
          valor: fecha,
          placeholder: 'Selecciona la fecha',
          isInvalid: fecha.isEmpty && touched['fecha']!,
          onTap: () {
            setState(() => touched['fecha'] = true);
            _seleccionarFecha();
          },
          icono: const Icon(Icons.calendar_month, color: AppColors.textoGris),
        ),
        const SizedBox(height: 28),
        Label('Lugar del incidente'),
        DropdownGris(
          valor: lugar,
          placeholder: 'Selecciona el lugar',
          opciones: _lugares,
          isInvalid: lugar.isEmpty && touched['lugar']!,
          onSeleccionar: (v) => setState(() {
            lugar = v;
            touched['lugar'] = true;
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ─────────── PASO 3 ───────────
  Widget _buildPaso3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._instituciones.map((inst) {
          final nombre = inst['nombre']!;
          final descripcionInst = inst['descripcion']!;
          final sel = institucion == nombre;
          return GestureDetector(
            onTap: () => setState(() {
              institucion = nombre;
              touched['institucion'] = true;
            }),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.fondoCampo,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: sel ? AppColors.primario : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textoOscuro,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          descripcionInst,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textoGris,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: nombre,
                    groupValue: institucion,
                    activeColor: AppColors.primario,
                    onChanged: (v) => setState(() {
                      institucion = v ?? '';
                      touched['institucion'] = true;
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
        if (institucion.isEmpty && touched['institucion']!)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Debes seleccionar una institución',
              style: GoogleFonts.inter(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ─────────── PASO 4 ───────────
  Widget _buildPaso4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label('Evidencias (opcional)'),
        Text(
          'Puedes adjuntar fotos o capturas que respalden tu denuncia.',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textoGris),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _seleccionarImagenes,
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: Text(
              imagenes.isEmpty
                  ? '¿Deseas adjuntar imágenes?'
                  : '${imagenes.length} imagen${imagenes.length == 1 ? '' : 'es'} seleccionada${imagenes.length == 1 ? '' : 's'}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primario,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (imagenes.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagenes.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(imagenes[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 2,
                      child: GestureDetector(
                        onTap: () => setState(() => imagenes.removeAt(index)),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─────────── WIDGET: Indicador de pasos ───────────
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.pasoActual});
  final int pasoActual;

  static const _colores = [
    Color(0xFFFFCA28),
    Color(0xFFFF8C00),
    Color(0xFFFFCA28),
    Color(0xFFFFCA28),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondoPantalla,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) {
          final activo = i == pasoActual;
          final completado = i < pasoActual;
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activo
                      ? _colores[i]
                      : completado
                          ? AppColors.primario.withOpacity(0.2)
                          : const Color(0xFFD9D9D9),
                ),
                alignment: Alignment.center,
                child: completado
                    ? const Icon(Icons.check, size: 20, color: AppColors.primario)
                    : Text(
                        '${i + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: activo ? Colors.white : const Color(0xFF9E9E9E),
                        ),
                      ),
              ),
              if (i < 3)
                Container(
                  width: 32,
                  height: 2,
                  color: completado
                      ? AppColors.primario.withOpacity(0.4)
                      : const Color(0xFFD9D9D9),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────── WIDGET: Botones inferiores ───────────
class _BotonesInferiores extends StatelessWidget {
  const _BotonesInferiores({
    required this.paso,
    required this.totalPasos,
    required this.onAnterior,
    required this.onSiguiente,
    required this.onEnviar,
  });

  final int paso;
  final int totalPasos;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;
  final VoidCallback onEnviar;

  @override
  Widget build(BuildContext context) {
    final esPrimero = paso == 0;
    final esUltimo  = paso == totalPasos - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.fondoPantalla,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Botón Anterior (oculto en paso 1) ──
          if (!esPrimero) ...[
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: onAnterior,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primario, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Anterior',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primario,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // ── Botón Siguiente / Enviar ──
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: esUltimo ? onEnviar : onSiguiente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secundario,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  esUltimo ? 'Enviar Denuncia' : 'Siguiente',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}