import 'package:flutter/material.dart';


class CustomButtonPainter extends CustomPainter {

String data;
  CustomButtonPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF282828);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFF51C0CD);

    // Define the main shape
    Path buttonPath = Path()
      ..moveTo(0, 0) // Top-left
      ..lineTo(size.width*0.9, 0) // Top-right
      ..lineTo(size.width *1.1, size.height) // Bottom-right
      ..lineTo(0, size.height); // Bottom-left
     // ..close();

    // Draw the button background
    canvas.drawPath(buttonPath, paint);

    // Draw the glowing border
    canvas.drawPath(buttonPath, borderPaint);

    // Optionally, you could add some shadows to create depth
    final shadowPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(buttonPath, shadowPaint);

    // Now draw the text inside the button
    TextSpan text = TextSpan(
      text: data,
      style: const TextStyle(
        fontFamily: 'Orbitron',
        // Use a similar futuristic font
        fontSize: 15,
        color: Color(0xFF27D4ED),
        fontWeight: FontWeight.normal,
        shadows: [
          Shadow(
            blurRadius: 1.0,
            color: Color(0xFF27D4ED),
            offset: Offset(0.1, 0.1),
          ),
        ],
      ),
    );
    TextPainter tp = TextPainter(
      text: text,
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(
      canvas,
      Offset(
        (size.width - tp.width) / 2,
        (size.height - tp.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

