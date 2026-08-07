import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'denunciar_sceen.dart';
import '../theme/colores.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (currentIndex == 0) {
      return _buildHomeBody(context);
    }

    if (currentIndex == 1) {
      return _emptyPage('Mis denuncias');
    }

    if (currentIndex == 2) {
      return _emptyPage('Recursos');
    }

    return _emptyPage('Perfil');
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
                      'Hola, Ana',
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
