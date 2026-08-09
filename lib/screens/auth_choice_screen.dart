import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import '../theme/colores.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primario,
      body: Stack(
        children: [
          Container(color: AppColors.primario),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
              ],
            ),
          ),
          // Bottom white rounded panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.86,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.fondoPantalla,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(140)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  SvgPicture.asset(
                    'assets/images/logos/N1.svg',
                    height: 200,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primario,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height:40),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secundario,
                        elevation: 3,
                        shadowColor: AppColors.secundario.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Registrarse',
                        style: GoogleFonts.poppins(
                          color: AppColors.textoOscuro,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.fondoPantalla,
                        side: BorderSide(
                          color: AppColors.textoOscuro.withOpacity(0.25),
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Iniciar Sesión',
                        style: GoogleFonts.poppins(
                          color: AppColors.textoOscuro,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FutureBuilder<String>(
                    future: _loadAndFixSvg('assets/images/personajes/2.svg'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      return SvgPicture.string(
                        snapshot.data!,
                        height: 260,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> _loadAndFixSvg(String assetPath) async {
  String svg = await rootBundle.loadString(assetPath);
  final regStyle = RegExp(r'<style>(.*?)</style>', dotAll: true);
  final match = regStyle.firstMatch(svg);
  if (match == null) return svg;
  final styleContent = match.group(1)!;
  final classReg = RegExp(r"\.([a-zA-Z0-9_-]+)\{fill:([^;]+);\}");
  final Map<String, String> mapping = {};
  for (final m in classReg.allMatches(styleContent)) {
    final cls = m.group(1)!.trim();
    final color = m.group(2)!.trim();
    mapping[cls] = color;
  }
  svg = svg.replaceFirst(regStyle, '');
  mapping.forEach((cls, color) {
    svg = svg.replaceAll('class="$cls"', 'fill="$color"');
    svg = svg.replaceAll('class=\'$cls\'', 'fill="$color"');
    svg = svg.replaceAllMapped(RegExp('class="([^"]*\\b$cls\\b[^"]*)"'), (m) {
      final existing = m.group(1)!;
      return 'class="$existing" fill="$color"';
    });
  });
  return svg;
}
