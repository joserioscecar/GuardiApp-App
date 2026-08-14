import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/tipo_discriminacion.dart';
import '../models/institucion.dart';
import '../services/catalogo_item.dart';
import '../services/genero_service.dart';
import '../services/tipo_discriminacion_service.dart';
import '../services/grupo_poblacional_service.dart';
import '../services/entorno_service.dart';
import '../services/institucion_service.dart';
import '../services/denuncia_service.dart';
import '../services/sesion_storage.dart';
import '../services/imagen_service.dart';

class DenunciaFormController extends ChangeNotifier {
  bool cargando = true;
  bool errorCatalogo = false;

  List<String> generos = [];
  Map<String, String> generoIdPorNombre = {};
  List<String> tipos = [];
  Map<String, String> tipoIdPorNombre = {};
  Map<String, List<SubtipoDiscriminacion>> subtiposPorTipoId = {};
  List<String> grupos = [];
  Map<String, String> grupoIdPorNombre = {};
  List<String> entornos = [];
  Map<String, String> entornoIdPorNombre = {};
  List<Institucion> instituciones = [];
  Map<String, String> institucionIdPorNombre = {};

  String descripcion = '';
  String lugar = '';
  String fecha = '';
  String tipoDenunciante = '';
  String genero = '';
  String edad = '';
  String discriminacion = '';
  String subDisc = '';
  String grupo = '';
  String entorno = '';
  List<String> personas = [];
  String personaTemp = '';
  String institucion = '';

  final Map<String, bool> touched = {
    'descripcion': false,
    'lugar': false,
    'fecha': false,
    'tipoDenunciante': false,
    'genero': false,
    'edad': false,
    'discriminacion': false,
    'subDisc': false,
    'grupo': false,
    'entorno': false,
    'personas': false,
    'institucion': false,
  };

  List<XFile> imagenes = [];
  final ImagePicker _picker = ImagePicker();

  bool get edadValida {
    if (edad.trim().isEmpty) return true;
    final valor = int.tryParse(edad.trim());
    return valor != null && valor > 0;
  }

  String? get errorEdad => edadValida
      ? null
      : 'La edad debe ser un número entero positivo.';

  List<String> get subtiposSeleccionados {
    final tipoId = tipoIdPorNombre[discriminacion];
    if (tipoId == null) return [];
    return (subtiposPorTipoId[tipoId] ?? const [])
        .map((s) => s.nombre)
        .toList();
  }

  bool esPasoValido(int paso) {
    switch (paso) {
      case 0:
        return tipoDenunciante.isNotEmpty &&
            genero.isNotEmpty &&
            edadValida &&
            discriminacion.isNotEmpty &&
            descripcion.isNotEmpty &&
            grupo.isNotEmpty &&
            entorno.isNotEmpty &&
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

  void marcarTocados(int paso) {
    switch (paso) {
      case 0:
        touched['tipoDenunciante'] = true;
        touched['genero'] = true;
        touched['edad'] = true;
        touched['discriminacion'] = true;
        touched['descripcion'] = true;
        touched['grupo'] = true;
        touched['entorno'] = true;
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
    notifyListeners();
  }

  Future<void> cargarCatalogo() async {
    cargando = true;
    errorCatalogo = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        GeneroService().listar(),
        TipoDiscriminacionService().listar(),
        GrupoPoblacionalService().listar(),
        EntornoService().listar(),
        InstitucionService().listar(),
      ]);

      final generosList = results[0] as List<CatalogoItem>;
      final tiposList = results[1] as List<TipoDiscriminacion>;
      final gruposList = results[2] as List<CatalogoItem>;
      final entornosList = results[3] as List<CatalogoItem>;
      final institucionesList = results[4] as List<Institucion>;

      generoIdPorNombre = {
        for (final g in generosList) g.nombre: g.id,
      };
      tipoIdPorNombre = {
        for (final t in tiposList) t.nombre: t.id,
      };
      grupoIdPorNombre = {
        for (final g in gruposList) g.nombre: g.id,
      };
      entornoIdPorNombre = {
        for (final e in entornosList) e.nombre: e.id,
      };
      institucionIdPorNombre = {
        for (final i in institucionesList) i.nombre: i.id,
      };
      subtiposPorTipoId = {};
      for (final t in tiposList) {
        if (t.subtipos.isNotEmpty) {
          subtiposPorTipoId[t.id] = t.subtipos;
        }
      }

      generos = generosList.map((g) => g.nombre).toList();
      tipos = tiposList.map((t) => t.nombre).toList();
      grupos = gruposList.map((g) => g.nombre).toList();
      entornos = entornosList.map((e) => e.nombre).toList();
      instituciones = institucionesList;
      cargando = false;
      notifyListeners();
    } catch (e) {
      errorCatalogo = true;
      cargando = false;
      notifyListeners();
    }
  }

  void agregarPersona() {
    if (personaTemp.trim().isEmpty) {
      touched['personas'] = true;
      notifyListeners();
      return;
    }
    if (!personas.contains(personaTemp.trim())) {
      personas.add(personaTemp.trim());
      personaTemp = '';
      touched['personas'] = true;
      notifyListeners();
    }
  }

  void eliminarPersona(int index) {
    personas.removeAt(index);
    notifyListeners();
  }

  Future<void> seleccionarImagenes() async {
    try {
      final seleccionadas = await _picker.pickMultiImage();
      if (seleccionadas.isNotEmpty) {
        imagenes.addAll(seleccionadas);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al seleccionar imágenes: $e');
    }
  }

  Future<String?> enviarDenuncia() async {
    final subTipoId = subtiposPorTipoId[tipoIdPorNombre[discriminacion]]
            ?.firstWhere(
              (st) => st.nombre == subDisc,
              orElse: () => SubtipoDiscriminacion(id: '', nombre: subDisc),
            )
            .id ??
        '';

    final campos = <String, String>{
      'TipoDenunciante': tipoDenunciante == 'Víctima' ? 'Victima' : 'Testigo',
      'Discriminacion': tipoIdPorNombre[discriminacion] ?? '',
      'SubTipo': subTipoId,
      'Genero': generoIdPorNombre[genero] ?? '',
      'Edad': edad,
      'Grupo': grupoIdPorNombre[grupo] ?? '',
      'Entorno': entornoIdPorNombre[entorno] ?? '',
      'InstitucionId': institucionIdPorNombre[institucion] ?? '',
      'Descripcion': descripcion,
      'Fecha': fecha,
      'Lugar': lugar,
    };

    final token = await SesionStorage().obtenerTokenValido();
    if (token == null || token.isEmpty) return null;

    final rutas = imagenes.map((img) => img.path).toList();
    final rutasComprimidas = await ImagenService().comprimir(rutas);

    return DenunciaService().enviar(
      token: token,
      campos: campos,
      personas: personas,
      rutasImagenes: rutasComprimidas,
    );
  }
}
