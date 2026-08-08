import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';
import 'home_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, this.radicado = ''});
  final String radicado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: Stack(
        children: [
          // Arco decorativo inferior
          Positioned(
            bottom: -60,
            left: -40,
            right: -40,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.secundario.withOpacity(0.20),
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Personaje ilustrado con el escudo
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.secundario.withOpacity(0.30),
                            ),
                          ),
                          FutureBuilder<String>(
                            future: _loadAndFixSvg('assets/images/personajes/6.svg'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState != ConnectionState.done) {
                                return const SizedBox.shrink();
                              }
                              if (snapshot.hasError || snapshot.data == null) {
                                return const SizedBox.shrink();
                              }
                              return SvgPicture.string(snapshot.data!, fit: BoxFit.contain);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      '¡Denuncia enviada!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textoOscuro,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      radicado.isNotEmpty
                          ? 'Tu radicado: $radicado'
                          : 'Hemos recibido tu denuncia.\nTe acompañaremos en el proceso.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.4,
                        color: AppColors.textoGris,
                      ),
                    ),

                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(initialTab: 1),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secundario,
                          elevation: 2,
                          shadowColor: AppColors.secundario.withOpacity(0.5),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Ver mis denuncias',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textoOscuro,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primario,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: AppColors.primario.withOpacity(0.5),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Volver al inicio',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Copia de la función util usada para convertir estilos CSS a atributos inline
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