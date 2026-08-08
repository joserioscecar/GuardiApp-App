import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colores.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.pasoActual});
  final int pasoActual;

  static const _colores = [
    Color(0xFFFFCA28),
    Color(0xFFFF8C00),
    Color(0xFFFFCA28),
    Color(0xFFFFCA28),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fondoPantalla,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) {
          final activo = i == pasoActual;
          final completado = i < pasoActual;
          return Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activo
                      ? _colores[i]
                      : completado
                          ? AppColors.primario.withOpacity(0.2)
                          : const Color(0xFFD9D9D9),
                ),
                alignment: Alignment.center,
                child: completado
                    ? const Icon(Icons.check, size: 20, color: AppColors.primario)
                    : Text(
                        '${i + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: activo ? Colors.white : const Color(0xFF9E9E9E),
                        ),
                      ),
              ),
              if (i < 3)
                Container(
                  width: 32,
                  height: 2,
                  color: completado
                      ? AppColors.primario.withOpacity(0.4)
                      : const Color(0xFFD9D9D9),
                ),
            ],
          );
        }),
      ),
    );
  }
}
