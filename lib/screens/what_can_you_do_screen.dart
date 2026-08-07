import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'auth_choice_screen.dart';
import '../theme/colores.dart';

class WhatCanYouDoScreen extends StatelessWidget {
  const WhatCanYouDoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      body: Stack(
        children: [
          // Blobs decorativos sutiles de fondo
          Positioned(
            top: -70,
            right: -50,
            child: _Blob(size: 180, color: AppColors.secundario.withOpacity(0.20)),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: _Blob(size: 220, color: AppColors.primario.withOpacity(0.10)),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      Text(
                        '¿Qué puedes hacer en\nGuardiApp?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textoOscuro,
                          fontSize: 25,
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 22),

                      _FeatureItem(
                        icon: Icons.chat_bubble_rounded,
                        iconColor: const Color(0xFF3E9AE0),
                        title: 'Realiza denuncias',
                        subtitle: 'de forma confidencial.',
                      ),
                      const SizedBox(height: 10),
                      _FeatureItem(
                        icon: Icons.favorite_rounded,
                        iconColor: AppColors.primario,
                        title: 'Recibe orientación',
                        subtitle: 'y recursos de ayuda.',
                      ),
                      const SizedBox(height: 10),
                      _FeatureItem(
                        icon: Icons.groups_rounded,
                        iconColor: AppColors.secundario,
                        iconOnDark: true,
                        title: 'Acompañamiento',
                        subtitle: 'en cada paso del proceso.',
                      ),
                      const SizedBox(height: 10),
                      _FeatureItem(
                        icon: Icons.shield_rounded,
                        iconColor: AppColors.primario,
                        title: 'Comunidad segura',
                        subtitle: 'y solidaria.',
                      ),

                      const SizedBox(height: 16),

                      // Personaje SVG centrado
                      SizedBox(
                        height: size.height * 0.26,
                        child: FutureBuilder<String>(
                          future: _loadAndFixSvg('assets/images/personajes/2.svg'),
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
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              _Dot(active: false),
                              SizedBox(width: 8),
                              _Dot(active: false),
                              SizedBox(width: 8),
                              _Dot(active: true),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secundario,
                              elevation: 2,
                              shadowColor: AppColors.secundario.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const AuthChoiceScreen()),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Siguiente',
                                    style: TextStyle(
                                      color: AppColors.textoOscuro,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded,
                                      color: AppColors.textoOscuro, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
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

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool iconOnDark;

  const _FeatureItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.iconOnDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconOnDark ? AppColors.textoOscuro : Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textoOscuro,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.textoGris, fontSize: 13),
                ),
              ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.secundario : AppColors.fondoCampo,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({Key? key, required this.size, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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