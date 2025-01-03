import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final String condition;
  final double size;

  const AnimatedWeatherIcon({super.key, 
    required this.condition,
    this.size = 64,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: WeatherIconPainter(
            condition: widget.condition,
            animation: _controller,
          ),
        );
      },
    );
  }
}

class WeatherIconPainter extends CustomPainter {
  final String condition;
  final Animation<double> animation;

  WeatherIconPainter({
    required this.condition,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    switch (condition.toLowerCase()) {
      case 'sunny':
        _drawSun(canvas, size, paint);
        break;
      case 'cloudy':
      case 'overcast':
        _drawCloud(canvas, size, paint);
        break;
      case 'rain':
        _drawRain(canvas, size, paint);
        break;
      default:
        _drawDefaultIcon(canvas, size, paint);
    }
  }

  void _drawSun(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    // Draw sun circle
    canvas.drawCircle(center, radius, paint);

    // Draw animated rays
    final rayCount = 8;
    final rayLength = radius * 0.5;
    
    for (var i = 0; i < rayCount; i++) {
      final angle = (i * 2 * pi / rayCount) + (animation.value * 2 * pi);
      final startPoint = Offset(
        center.dx + cos(angle) * (radius + 5),
        center.dy + sin(angle) * (radius + 5),
      );
      final endPoint = Offset(
        center.dx + cos(angle) * (radius + rayLength),
        center.dy + sin(angle) * (radius + rayLength),
      );
      
      canvas.drawLine(startPoint, endPoint, paint..strokeWidth = 3);
    }
  }

  void _drawCloud(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final offset = Offset(
      size.width * 0.2 + (sin(animation.value * 2 * pi) * 5),
      size.height * 0.4,
    );

    path.moveTo(offset.dx, offset.dy);
    path.quadraticBezierTo(
      offset.dx - 10,
      offset.dy - 20,
      offset.dx + 20,
      offset.dy - 25,
    );
    path.quadraticBezierTo(
      offset.dx + 35,
      offset.dy - 30,
      offset.dx + 50,
      offset.dy - 10,
    );
    path.quadraticBezierTo(
      offset.dx + 65,
      offset.dy,
      offset.dx + 50,
      offset.dy + 15,
    );
    path.quadraticBezierTo(
      offset.dx + 25,
      offset.dy + 25,
      offset.dx,
      offset.dy,
    );

    canvas.drawPath(path, paint);
  }

  void _drawRain(Canvas canvas, Size size, Paint paint) {
    _drawCloud(canvas, size, paint);

    // Draw animated raindrops
    final dropCount = 5;
    for (var i = 0; i < dropCount; i++) {
      final progress = (animation.value + (i / dropCount)) % 1.0;
      final xOffset = size.width * (0.3 + (i * 0.15));
      final yOffset = size.height * (0.6 + (progress * 0.3));

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(xOffset, yOffset),
          width: 4,
          height: 8,
        ),
        paint,
      );
    }
  }

  void _drawDefaultIcon(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 4,
      paint,
    );
  }

  @override
  bool shouldRepaint(WeatherIconPainter oldDelegate) =>
      oldDelegate.animation.value != animation.value;
}
