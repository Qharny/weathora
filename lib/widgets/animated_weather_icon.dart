import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWeatherIcon extends StatefulWidget {
  final String condition;
  final double size;

  const AnimatedWeatherIcon({
    super.key,
    required this.condition,
    this.size = 64,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  late AnimationController _floatController;
  
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    
    // Rotation animation with variable speed
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Enhanced bounce animation with spring effect
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -15)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -15, end: 0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 70.0,
      ),
    ]).animate(_bounceController);

    // Breathing scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50.0,
      ),
    ]).animate(_scaleController);

    // Shake animation for thunder
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -5, end: 5)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 5, end: -5)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -5, end: 0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50.0,
      ),
    ]).animate(_shakeController);

    // Floating animation for clouds
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 10)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 10, end: 0)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50.0,
      ),
    ]).animate(_floatController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  String _getWeatherIcon(String condition) {
    final Map<String, String> weatherIcons = {
      'sunny': 'https://openweathermap.org/img/wn/01d@2x.png',
      'cloudy': 'https://openweathermap.org/img/wn/03d@2x.png',
      'partly cloudy': 'https://openweathermap.org/img/wn/02d@2x.png',
      'overcast': 'https://openweathermap.org/img/wn/04d@2x.png',
      'rain': 'https://openweathermap.org/img/wn/10d@2x.png',
      'drizzle': 'https://openweathermap.org/img/wn/10d@2x.png',
      'snow': 'https://openweathermap.org/img/wn/13d@2x.png',
      'light snow': 'https://openweathermap.org/img/wn/13d@2x.png',
      'thunderstorm': 'https://openweathermap.org/img/wn/11d@2x.png',
      'fog': 'https://openweathermap.org/img/wn/50d@2x.png',
      'wind': 'https://openweathermap.org/img/wn/50d@2x.png',
    };

    return weatherIcons[condition.toLowerCase()] ?? 'https://openweathermap.org/img/wn/01d@2x.png';
  }

  Widget _buildComplexAnimation(Widget child, String condition) {
    switch (condition.toLowerCase()) {
      case 'thunderstorm':
        return AnimatedBuilder(
          animation: Listenable.merge([_shakeAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: child,
        );

      case 'rain':
        return AnimatedBuilder(
          animation: Listenable.merge([_bounceAnimation, _rotationController]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                math.sin(_rotationController.value * 2 * math.pi) * 5,
                _bounceAnimation.value,
              ),
              child: child,
            );
          },
          child: child,
        );

      case 'snow':
        return AnimatedBuilder(
          animation: Listenable.merge([_bounceAnimation, _rotationController]),
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_rotationController.value * 2 * math.pi) * 0.1,
              child: Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              ),
            );
          },
          child: child,
        );
      case 'light snow':
        return AnimatedBuilder(
          animation: Listenable.merge([_bounceAnimation, _rotationController]),
          builder: (context, child) {
            return Transform.rotate(
              angle: math.sin(_rotationController.value * 2 * math.pi) * 0.1,
              child: Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              ),
            );
          },
          child: child,
        );

      case 'wind':
        return RotationTransition(
          turns: _rotationController,
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_bounceAnimation.value, 0),
                child: child,
              );
            },
            child: child,
          ),
        );

      case 'cloudy':
      case 'overcast':
      case 'partly cloudy':
        return AnimatedBuilder(
          animation: Listenable.merge([_floatAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                math.sin(_floatController.value * math.pi) * 8,
                _floatAnimation.value,
              ),
              child: Transform.scale(
                scale: 0.9 + (_scaleAnimation.value - 1.0) * 0.2,
                child: child,
              ),
            );
          },
          child: child,
        );

      case 'sunny':
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * math.pi,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: child,
        );

      default:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            )),
            child: child,
          ),
        );
      },
      child: _buildComplexAnimation(
        Image.network(
          _getWeatherIcon(widget.condition),
          key: ValueKey<String>(widget.condition),
          width: widget.size,
          height: widget.size,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.wb_sunny,
              size: widget.size,
              color: Colors.white,
            );
          },
        ),
        widget.condition,
      ),
    );
  }
}