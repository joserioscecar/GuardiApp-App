import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'what_can_you_do_screen.dart';
import '../theme/colores.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primario,
      body: Stack(
        children: [
          // Top colored area (uses full screen background color)
          Container(color: AppColors.primario),

          // Center character image
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                Center(
                  child: SizedBox(
                    height: size.height * 0.38,
                    child: FutureBuilder<String>(
                      future: _loadAndFixSvg('assets/images/personajes/4.svg'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox.shrink();
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return const SizedBox.shrink();
                        }
                        return SvgPicture.string(
                          snapshot.data!,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom white rounded panel
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.52,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.fondoPantalla,
                borderRadius: BorderRadius.vertical(top: Radius.circular(190)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Bienvenido a',
                      style: TextStyle(
                        color: AppColors.textoOscuro,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/logos/guardiapp_naranja.svg',
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Es una comunidad segura para\ndenunciar y recibir apoyo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textoOscuro,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots
                      Row(
                        children: const [
                          _Dot(active: false),
                          SizedBox(width: 8),
                          _Dot(active: true),
                          SizedBox(width: 8),
                          _Dot(active: false),
                        ],
                      ),

                      // Next button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secundario,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const WhatCanYouDoScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text('Siguiente', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({Key? key, required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 12 : 8,
      height: active ? 12 : 8,
      decoration: BoxDecoration(
        color: active ? AppColors.secundario : AppColors.fondoPantalla,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Carga un SVG desde assets y convierte las clases CSS (.cls-1 {...})
/// a atributos inline `fill="#xxxxxx"` para que `flutter_svg` pinte
/// los colores correctamente cuando el parser ignore el bloque <style>.
Future<String> _loadAndFixSvg(String assetPath) async {
  String svg = await rootBundle.loadString(assetPath);

  // Extraer mapeo simple de clases desde el bloque <style>
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

  // Remove the <style> block
  svg = svg.replaceFirst(regStyle, '');

  // Replace class="cls-N" with inline fill attribute
  mapping.forEach((cls, color) {
    svg = svg.replaceAll('class="$cls"', 'fill="$color"');
    svg = svg.replaceAll('class=\'$cls\'', 'fill="$color"');
    // also replace occurrences like class="cls-1 cls-2" conservatively
    svg = svg.replaceAllMapped(RegExp('class="([^"]*\\b$cls\\b[^"]*)"'), (m) {
      final existing = m.group(1)!;
      return 'class="$existing" fill="$color"';
    });
  });

  return svg;
}
