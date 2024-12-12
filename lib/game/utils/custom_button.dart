import 'package:flutter/material.dart';

class CustomButtonPainter extends CustomPainter {

String data;
  CustomButtonPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.cyanAccent;

    // Define the main shape
    Path buttonPath = Path()
      ..moveTo(0, 0) // Top-left
      ..lineTo(size.width*0.9, 0) // Top-right
      ..lineTo(size.width *1.5, size.height) // Bottom-right
      ..lineTo(0, size.height) // Bottom-left
      ..close();

    // Draw the button background
    canvas.drawPath(buttonPath, paint);

    // Draw the glowing border
    canvas.drawPath(buttonPath, borderPaint);

    // Optionally, you could add some shadows to create depth
    final shadowPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(buttonPath, shadowPaint);

    // Now draw the text inside the button
    TextSpan text = TextSpan(
      text: data,
      style: const TextStyle(
        fontFamily: 'Orbitron',
        // Use a similar futuristic font
        fontSize: 15,
        color: Colors.cyanAccent,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.cyan,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
    );
    TextPainter tp = TextPainter(
      text: text,
      textAlign: TextAlign.center,
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

