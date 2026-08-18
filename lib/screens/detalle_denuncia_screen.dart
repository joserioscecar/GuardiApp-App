import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';
import '../models/denuncia_item.dart';
import '../config/api_config.dart';

class DetalleDenunciaScreen extends StatelessWidget {
  const DetalleDenunciaScreen({super.key, required this.denuncia});
  final DenunciaItem denuncia;

  String _buildImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final limpio = path.startsWith('/') ? path.substring(1) : path;
    return '$apiHost/$limpio';
  }

  @override
  Widget build(BuildContext context) {
    final d = denuncia;
    final evidencias = d.evidencias;

    return Scaffold(
      backgroundColor: AppColors.fondoPantalla,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        foregroundColor: Colors.white,
        title: Text(
          d.radicado,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _seccion(
              titulo: 'Información general',
              children: [
                _fila('Tipo de denunciante', d.tipoDenunciante),
                _fila('Discriminación', d.discriminacion),
                if (d.subTipo.isNotEmpty) _fila('Subtipo', d.subTipo),
                _fila('Género', d.genero),
                _fila('Edad', d.edad),
                _fila('Grupo poblacional', d.grupo),
              ],
            ),
            const SizedBox(height: 16),
            _seccion(
              titulo: 'Lugar y fecha',
              children: [
                _fila('Fecha', d.fecha),
                _fila('Lugar', d.lugar),
                _fila('Entorno', d.entorno),
                if (d.subEntorno.isNotEmpty) _fila('Subentorno', d.subEntorno),
              ],
            ),
            const SizedBox(height: 16),
            _seccion(
              titulo: 'Personas denunciadas',
              children: d.personasDenunciadas.isEmpty
                  ? [const _FilaTexto('No se registraron personas')]
                  : d.personasDenunciadas
                      .map((p) => _fila('Nombre', p.nombre))
                      .toList(),
            ),
            const SizedBox(height: 16),
            _seccion(
              titulo: 'Institución',
              children: [
                _fila('Redirigido a', d.institucionNombre),
              ],
            ),
            const SizedBox(height: 16),
            _seccion(
              titulo: 'Descripción',
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    d.descripcion.isNotEmpty
                        ? d.descripcion
                        : 'Sin descripción',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textoOscuro,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            if (evidencias.isNotEmpty) ...[
              const SizedBox(height: 16),
              _seccion(
                titulo: 'Evidencias (${evidencias.length})',
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: evidencias.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final url = _buildImageUrl(evidencias[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => _EvidenciaFull(
                                  url: url,
                                  index: index,
                                  total: evidencias.length,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              url,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: AppColors.fondoCampo,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primario,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, _, _) => Container(
                                width: 100,
                                height: 100,
                                color: AppColors.fondoCampo,
                                child: const Icon(
                                  Icons.broken_image_rounded,
                                  color: AppColors.textoGris,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _seccion({
    required String titulo,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.fondoCampo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primario,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _fila(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textoGris,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor.isNotEmpty ? valor : '—',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textoOscuro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaTexto extends StatelessWidget {
  const _FilaTexto(this.texto);
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        texto,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontStyle: FontStyle.italic,
          color: AppColors.textoGris,
        ),
      ),
    );
  }
}

class _EvidenciaFull extends StatelessWidget {
  const _EvidenciaFull({
    required this.url,
    required this.index,
    required this.total,
  });
  final String url;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Evidencia ${index + 1} de $total',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Image.network(
            url,
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
            errorBuilder: (_, __, ___) => const Center(
              child: Column(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
