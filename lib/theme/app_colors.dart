import 'package:flutter/material.dart';

import '../data/gas_law_content.dart';

abstract final class AppColors {
  AppColors._();

  static const Color boyleBlue = Color(0xFF4A90E2);
  static const Color charlesGreen = Color(0xFF5CB85C);
  static const Color kmtOrange = Color(0xFFFF8A3D);
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color darkNavy = Color(0xFF2F486E);

  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF0F0F0);

  static const Color successBg = Color(0xFFF0F8F0);
  static const Color errorBg = Color(0xFFFFEBEE);

  static Color forGasLaw(GasLawType type) {
    switch (type) {
      case GasLawType.boyle:
        return boyleBlue;
      case GasLawType.charles:
        return charlesGreen;
    }
  }
}
