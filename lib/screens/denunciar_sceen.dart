import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_flutter/widgets/fila_Icono.dart';
import '../widgets/Campo_texto.dart';
import '../widgets/label.dart';
import '../widgets/dropdown_gris.dart';
import '../widgets/step_indicator.dart';
import '../widgets/botones_inferiores.dart';
import 'success_screen.dart';
import '../theme/colores.dart';
import '../controllers/denuncia_form_controller.dart';

class DenunciarScreen extends StatefulWidget {
  const DenunciarScreen({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  State<DenunciarScreen> createState() => _DenunciarScreenState();
}

class _DenunciarScreenState extends State<DenunciarScreen> {
  int _paso = 0;
  final _ctrl = DenunciaFormController();

  static const _titulosPaso = [
    'Detalles de la Denuncia',
    '¿Cuándo y dónde ocurrió?',
    '¿Deseas redireccionar tu denuncia?',
    'Evidencias y Envío',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl.fecha = DateFormat('dd/MM/yyyy', 'es_ES').format(DateTime.now());
    _ctrl.addListener(_actualizar);
    _ctrl.cargarCatalogo();
  }

  @override
  void dispose() {
    _ctrl.removeListener(_actualizar);
    _ctrl.dispose();
    super.dispose();
  }

  void _actualizar() {
    if (mounted) setState(() {});
  }

  void _siguiente() {
    if (_ctrl.esPasoValido(_paso)) {
      setState(() => _paso++);
    } else {
      _ctrl.marcarTocados(_paso);
    }
  }

  void _anterior() {
    if (_paso > 0) {
      setState(() => _paso--);
    } else {
      widget.onBack();
    }
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
      _ctrl.fecha = DateFormat('dd/MM/yyyy', 'es_ES').format(picked);
      _ctrl.touched['fecha'] = true;
      _actualizar();
    }
  }

  Future<void> _enviar() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primario),
      ),
    );

    try {
      final radicado = await _ctrl.enviarDenuncia();
      if (!mounted) return;
      Navigator.pop(context);

      if (radicado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes iniciar sesión para enviar una denuncia'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(radicado: radicado),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo enviar la denuncia: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      body: _buildCuerpo(),
    );
  }

  Widget _buildCuerpo() {
    if (_ctrl.cargando) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primario),
      );
    }

    if (_ctrl.errorCatalogo) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: AppColors.textoGris),
              const SizedBox(height: 12),
              Text(
                'No se pudo cargar el catálogo de la denuncia.\nVerifica tu conexión e inténtalo de nuevo.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppColors.textoGris),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _ctrl.cargarCatalogo(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primario,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Reintentar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        StepIndicator(pasoActual: _paso),
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
        BotonesInferiores(
          paso: _paso,
          totalPasos: 4,
          onAnterior: _anterior,
          onSiguiente: _siguiente,
          onEnviar: _enviar,
        ),
      ],
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
              color: _ctrl.tipoDenunciante.isEmpty && _ctrl.touched['tipoDenunciante']!
                  ? Colors.red
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: ['Víctima', 'Testigo'].map((op) {
              final sel = _ctrl.tipoDenunciante == op;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _ctrl.tipoDenunciante = op;
                    _ctrl.touched['tipoDenunciante'] = true;
                    _actualizar();
                  },
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
              color: _ctrl.genero.isEmpty && _ctrl.touched['genero']!
                  ? Colors.red
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(4),
          child: Wrap(
            spacing: 8,
            children: _ctrl.generos.map((g) {
              final sel = _ctrl.genero == g;
              return GestureDetector(
                onTap: () {
                  _ctrl.genero = g;
                  _ctrl.touched['genero'] = true;
                  _actualizar();
                },
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
          valor: _ctrl.edad,
          placeholder: 'Ej: 25',
          keyboardType: TextInputType.number,
          maxLength: 3,
          isInvalid: _ctrl.edad.isEmpty && _ctrl.touched['edad']!,
          onValorChange: (v) {
            _ctrl.edad = v;
            if (v.isNotEmpty) _ctrl.touched['edad'] = true;
            _actualizar();
          },
        ),
        const SizedBox(height: 20),
        Label('¿Qué tipo de situación deseas denunciar?'),
        DropdownGris(
          valor: _ctrl.discriminacion,
          placeholder: 'Selecciona la situación',
          opciones: _ctrl.tipos,
          isInvalid: _ctrl.discriminacion.isEmpty && _ctrl.touched['discriminacion']!,
          onSeleccionar: (v) {
            _ctrl.discriminacion = v;
            _ctrl.subDisc = '';
            _ctrl.touched['discriminacion'] = true;
            _actualizar();
          },
        ),
        if (_ctrl.discriminacion.isNotEmpty) ...[
          const SizedBox(height: 12),
          DropdownGris(
            valor: _ctrl.subDisc,
            placeholder: 'Selecciona el subtipo',
            opciones: _ctrl.subtiposSeleccionados,
            isInvalid: _ctrl.subDisc.isEmpty && _ctrl.touched['subDisc']!,
            onSeleccionar: (v) {
              _ctrl.subDisc = v;
              _ctrl.touched['subDisc'] = true;
              _actualizar();
            },
          ),
        ],
        const SizedBox(height: 20),
        Label('¿Qué ocurrió?'),
        CampoTexto(
          valor: _ctrl.descripcion,
          placeholder: 'Describe lo ocurrido',
          maxLines: 4,
          isInvalid: _ctrl.descripcion.isEmpty && _ctrl.touched['descripcion']!,
          onValorChange: (v) {
            _ctrl.descripcion = v;
            if (v.isNotEmpty) _ctrl.touched['descripcion'] = true;
            _actualizar();
          },
        ),
        const SizedBox(height: 20),
        Label('Grupo poblacional'),
        DropdownGris(
          valor: _ctrl.grupo,
          placeholder: 'Selecciona el grupo',
          opciones: _ctrl.grupos,
          isInvalid: _ctrl.grupo.isEmpty && _ctrl.touched['grupo']!,
          onSeleccionar: (v) {
            _ctrl.grupo = v;
            _ctrl.touched['grupo'] = true;
            _actualizar();
          },
        ),
        const SizedBox(height: 20),
        Label('Tipo de entorno'),
        DropdownGris(
          valor: _ctrl.entorno,
          placeholder: 'Selecciona el entorno',
          opciones: _ctrl.entornos,
          isInvalid: _ctrl.entorno.isEmpty && _ctrl.touched['entorno']!,
          onSeleccionar: (v) {
            _ctrl.entorno = v;
            _ctrl.touched['entorno'] = true;
            _actualizar();
          },
        ),
        const SizedBox(height: 20),
        Label('Personas involucradas'),
        Row(
          children: [
            Expanded(
              child: CampoTexto(
                valor: _ctrl.personaTemp,
                placeholder: 'Agregar persona',
                isInvalid: _ctrl.personas.isEmpty && _ctrl.touched['personas']!,
                onValorChange: (v) {
                  _ctrl.personaTemp = v;
                  if (v.isNotEmpty) _ctrl.touched['personas'] = true;
                  _actualizar();
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _ctrl.agregarPersona,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primario,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        if (_ctrl.personas.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_ctrl.personas.length, (index) {
              return Chip(
                label: Text(_ctrl.personas[index]),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _ctrl.eliminarPersona(index),
              );
            }),
          ),
        ],
        if (_ctrl.personas.isEmpty && _ctrl.touched['personas']!)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Debes agregar al menos una persona involucrada.',
              style: GoogleFonts.inter(color: Colors.red, fontSize: 12),
            ),
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
          valor: _ctrl.fecha,
          placeholder: 'Selecciona la fecha',
          isInvalid: _ctrl.fecha.isEmpty && _ctrl.touched['fecha']!,
          onTap: () {
            _ctrl.touched['fecha'] = true;
            _actualizar();
            _seleccionarFecha();
          },
          icono: const Icon(Icons.calendar_month, color: AppColors.textoGris),
        ),
        const SizedBox(height: 28),
        Label('Lugar del incidente'),
        CampoTexto(
          valor: _ctrl.lugar,
          placeholder: 'Escribe el lugar del incidente',
          isInvalid: _ctrl.lugar.isEmpty && _ctrl.touched['lugar']!,
          onValorChange: (v) {
            _ctrl.lugar = v;
            if (v.isNotEmpty) _ctrl.touched['lugar'] = true;
            _actualizar();
          },
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
        ..._ctrl.instituciones.map((inst) {
          final nombre = inst.nombre;
          final descripcionInst = inst.descripcion ?? '';
          final sel = _ctrl.institucion == nombre;
          return GestureDetector(
            onTap: () {
              _ctrl.institucion = nombre;
              _ctrl.touched['institucion'] = true;
              _actualizar();
            },
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
                        if (descripcionInst.isNotEmpty) ...[
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
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: nombre,
                    groupValue: _ctrl.institucion,
                    activeColor: AppColors.primario,
                    onChanged: (v) {
                      _ctrl.institucion = v ?? '';
                      _ctrl.touched['institucion'] = true;
                      _actualizar();
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        if (_ctrl.institucion.isEmpty && _ctrl.touched['institucion']!)
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
    final imagenes = _ctrl.imagenes;
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
            onPressed: _ctrl.seleccionarImagenes,
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
                        onTap: () {
                          _ctrl.imagenes.removeAt(index);
                          _actualizar();
                        },
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
