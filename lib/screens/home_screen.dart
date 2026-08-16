import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'denunciar_sceen.dart';
import 'login_screen.dart';
import '../theme/colores.dart';
import '../services/sesion_storage.dart';
import '../services/denuncia_service.dart';
import '../models/denuncia_item.dart';
import '../config/api_config.dart';
import 'detalle_denuncia_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentIndex = widget.initialTab;
  String _nombreUsuario = '';
  String _correoUsuario = '';

  List<DenunciaItem> _denuncias = [];
  bool _cargandoDenuncias = false;
  bool _errorDenuncias = false;

  @override
  void initState() {
    super.initState();
    _cargarSesion();
  }

  Future<void> _cargarSesion() async {
    final sesion = await SesionStorage().obtener();
    if (mounted) {
      setState(() {
        _nombreUsuario = sesion?.nombreCompleto ?? '';
        _correoUsuario = sesion?.correo ?? '';
      });
    }
    if (currentIndex == 1) {
      _cargarDenuncias();
    }
  }

  Future<void> _cerrarSesion() async {
    await SesionStorage().cerrarSesion();
    if (!mounted) return;
    _irALogin();
  }

  void _irALogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  String _buildImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final limpio = path.startsWith('/') ? path.substring(1) : path;
    return '$apiHost/$limpio';
  }

  void _verEvidencias(List<String> imagenes) {
    final urls = imagenes.map(_buildImageUrl).toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _EvidenciasViewer(imagenes: urls),
      ),
    );
  }

  Future<void> _cargarDenuncias() async {
    setState(() {
      _cargandoDenuncias = true;
      _errorDenuncias = false;
    });
    try {
      final token = await SesionStorage().obtenerTokenValido();
      if (token == null || token.isEmpty) {
        if (mounted) _irALogin();
        return;
      }
      final denuncias = await DenunciaService().listar(token: token);
      if (!mounted) return;
      setState(() {
        _denuncias = denuncias;
        _cargandoDenuncias = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorDenuncias = true;
        _cargandoDenuncias = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        leading: currentIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => currentIndex = 0),
              )
            : null,
        title: Text(
          _tituloPorTab[currentIndex],
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  static const _tituloPorTab = [
    'Inicio',
    'Mis denuncias',
    'Recursos',
    'Perfil',
  ];

  Widget _buildBody(BuildContext context) {
    if (currentIndex == 0) {
      return _buildHomeBody(context);
    }

    if (currentIndex == 1) {
      return _buildDenunciasBody();
    }

    if (currentIndex == 2) {
      return _emptyPage('Recursos');
    }

    return _buildProfileBody();
  }

  Widget _buildHomeBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF5900),
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  'assets/images/logos/guardiapp_naranja.svg',
                  width: 180,
                  height: 60,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                 //     color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset(
                      'assets/images/personajes/1.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nombreUsuario.isNotEmpty ? 'Hola, $_nombreUsuario' : 'Hola',
                      style: GoogleFonts.poppins(
                        color: AppColors.textoOscuro,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Estamos contigo',
                      style: GoogleFonts.poppins(
                        color: AppColors.textoOscuro,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: _cerrarSesion,
                  icon: const Icon(Icons.logout_rounded),
                  color: Colors.red,
                  tooltip: 'Cerrar sesión',
                ),
              ],
            ),

            const SizedBox(height: 40),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                color: AppColors.secundario,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '¿Necesitas ayuda?',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      'Realiza tu denuncia',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      'de forma segura y confidencial.',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DenunciarScreen(
                              onBack: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textoOscuro,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hacer una denuncia',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 34),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recursos de ayuda',
                  style: GoogleFonts.poppins(
                    color: AppColors.textoOscuro,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Ver todos',
                  style: GoogleFonts.poppins(
                    color: AppColors.textoOscuro,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            _resourceCard(
              icon: Icons.phone_in_talk_rounded,
              title: 'Líneas de ayuda',
              subtitle: 'Contactos disponibles 24/7.',
            ),

            const SizedBox(height: 16),

            _resourceCard(
              icon: Icons.menu_book_rounded,
              title: 'Guía de apoyo',
              subtitle: 'Información para orientarte.',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _resourceCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.primario,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 38),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _svgAvatar(String assetPath, {double size = 48}) {
    return FutureBuilder<String>(
      future: rootBundle
          .loadString(assetPath)
          .timeout(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.textoOscuro,
            ),
          );
        }

        try {
          return SvgPicture.string(
            snapshot.data!,
            width: size,
            height: size,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          );
        } catch (e) {
          return Center(
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.textoOscuro,
            ),
          );
        }
      },
    );
  }

  Widget _emptyPage(String title) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.textoOscuro,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDenunciasBody() {
    return SafeArea(
      child: _cargandoDenuncias
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primario),
            )
          : _errorDenuncias
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.textoGris),
                        const SizedBox(height: 12),
                        Text(
                          'No se pudieron cargar las denuncias.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.textoGris),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _cargarDenuncias,
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
                )
              : _denuncias.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.description_outlined,
                              size: 56, color: AppColors.textoGris),
                          const SizedBox(height: 12),
                          Text(
                            'No tienes denuncias aún.',
                            style: GoogleFonts.poppins(
                              color: AppColors.textoOscuro,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tus denuncias aparecerán aquí.',
                            style: GoogleFonts.inter(
                              color: AppColors.textoGris,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _cargarDenuncias,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        itemCount: _denuncias.length,
                        itemBuilder: (context, index) {
                          final d = _denuncias[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetalleDenunciaScreen(denuncia: d),
                                ),
                              );
                            },
                            child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 1,
                            color: AppColors.fondoCampo,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          d.radicado.isNotEmpty
                                              ? d.radicado
                                              : 'Sin radicado',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primario,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primario
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          d.discriminacion,
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primario,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    d.descripcion,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.textoOscuro,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 14,
                                          color: AppColors.textoGris),
                                      const SizedBox(width: 6),
                                      Text(
                                        d.fecha,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.textoGris,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.location_on,
                                          size: 14,
                                          color: AppColors.textoGris),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          d.lugar,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.textoGris,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (d.evidencias.isNotEmpty)
                                        GestureDetector(
                                          onTap: () =>
                                              _verEvidencias(d.evidencias),
                                          child: const Icon(
                                            Icons.image_rounded,
                                            size: 20,
                                            color: AppColors.primario,
                                          ),
                                        )
                                      else
                                        const Icon(
                                          Icons.image_rounded,
                                          size: 20,
                                          color: AppColors.textoGris,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.primario
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Ver detalle',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primario,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 10,
                                              color: AppColors.primario,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        },
                      ),
                    ),
    );
  }

  Widget _buildProfileBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primario.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 44,
                color: AppColors.primario,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _nombreUsuario.isNotEmpty ? _nombreUsuario : 'Usuario',
              style: GoogleFonts.poppins(
                color: AppColors.textoOscuro,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_correoUsuario.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                _correoUsuario,
                style: GoogleFonts.inter(
                  color: AppColors.textoGris,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _cerrarSesion,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Cerrar sesi\u00F3n',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 105,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.fondoPantalla,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(index: 0, icon: Icons.home_rounded, label: 'Inicio'),
          _navItem(
            index: 1,
            icon: Icons.description_rounded,
            label: 'Mis denuncias',
          ),
          _navItem(index: 2, icon: Icons.menu_book_rounded, label: 'Recursos'),
          _navItem(index: 3, icon: Icons.person_rounded, label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          currentIndex = index;
        });
        if (index == 1) {
          _cargarDenuncias();
        }
      },
      child: SizedBox(
        width: 82,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 34,
              color: isSelected ? AppColors.primario : AppColors.secundario,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textoGris,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EvidenciasViewer extends StatelessWidget {
  const _EvidenciasViewer({required this.imagenes});
  final List<String> imagenes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${imagenes.length} evidencia${imagenes.length == 1 ? '' : 's'}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: PageView.builder(
        itemCount: imagenes.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                imagenes[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image_rounded,
                          size: 48, color: Colors.white54),
                      SizedBox(height: 8),
                      Text(
                        'No se pudo cargar la imagen',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
