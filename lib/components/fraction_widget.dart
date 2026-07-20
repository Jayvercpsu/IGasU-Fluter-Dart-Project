import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FractionWidget extends StatelessWidget {
  final String leftPart;
  final String numerator;
  final String denominator;
  final Color? color;
  final TextStyle? textStyle;

  const FractionWidget({
    super.key,
    required this.leftPart,
    required this.numerator,
    required this.denominator,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    const defaultColor = Color(0xFF6B7280);
    final style = textStyle ??
        GoogleFonts.inter(fontSize: 14, color: defaultColor, height: 1.4);

    final fracColor = color ?? defaultColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leftPart.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(leftPart, style: style),
            ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(numerator, style: style, textAlign: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: fracColor.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                Text(denominator, style: style, textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
