import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

/// Widget que carga `assets/images/logos/N1.svg` y aplica una
/// conversión sencilla de estilos <style> a atributos inline para
/// preservar los `fill` originales del SVG.
class Logo extends StatelessWidget {
  final double? height;
  final double? width;

  const Logo({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadAndFixSvg('assets/images/logos/N1.svg'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.data == null) {
          return SizedBox(height: height ?? 72, width: width);
        }
        return SvgPicture.string(
          snapshot.data!,
          height: height,
          width: width,
          fit: BoxFit.contain,
        );
      },
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
    svg = svg.replaceAll("class='$cls'", 'fill="$color"');
    svg = svg.replaceAllMapped(RegExp('class="([^\"]*\\b$cls\\b[^\"]*)"'), (m) {
      final existing = m.group(1)!;
      return 'class="$existing" fill="$color"';
    });
  });
  return svg;
}
