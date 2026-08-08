import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';

class BotonesInferiores extends StatelessWidget {
  const BotonesInferiores({
    super.key,
    required this.paso,
    required this.totalPasos,
    required this.onAnterior,
    required this.onSiguiente,
    required this.onEnviar,
  });

  final int paso;
  final int totalPasos;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;
  final VoidCallback onEnviar;

  @override
  Widget build(BuildContext context) {
    final esPrimero = paso == 0;
    final esUltimo = paso == totalPasos - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.fondoPantalla,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!esPrimero) ...[
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: onAnterior,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primario, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Anterior',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primario,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: esUltimo ? onEnviar : onSiguiente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secundario,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  esUltimo ? 'Denunciar' : 'Siguiente',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
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
