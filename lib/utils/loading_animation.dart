import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Small reusable loading animation that uses the app logo.
/// Keep this widget in `utils/` so it's easy to reuse across the app.
class LoadingAnimation extends StatefulWidget {
  final double size;
  const LoadingAnimation({super.key, this.size = 80});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 0.9,
        end: 1.05,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.05,
        end: 0.9,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 50,
    ),
  ]).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Transform.scale(scale: _scale.value, child: child),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Image(
                  image: AssetImage('assets/images/Logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
