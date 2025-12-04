import 'package:flutter/material.dart';

class LinedPaper extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool enabled;

  const LinedPaper({
    super.key,
    required this.text,
    required this.style,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinedPaperPainter(text: text, style: style, enabled: enabled),
      child: Text(text, style: style),
    );
  }
}

class _LinedPaperPainter extends CustomPainter {
  final String text;
  final TextStyle style;
  final bool enabled;

  _LinedPaperPainter({
    required this.text,
    required this.style,
    required this.enabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!enabled) return;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);

    final lineMetrics = textPainter.computeLineMetrics();

    final realLineHeight = lineMetrics.first.height;

    final paintLine =
        Paint()
          ..color = const Color(0xFFE0DCC6)
          ..strokeWidth = 1;

    double y = 0;

    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintLine);
      y += realLineHeight;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
