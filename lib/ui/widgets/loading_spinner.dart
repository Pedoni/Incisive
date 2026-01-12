import 'package:flutter/material.dart';

class LoadingSpinner extends StatefulWidget {
  const LoadingSpinner({super.key});

  @override
  State<LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner> with TickerProviderStateMixin {
  late final AnimationController _outerController;
  late final AnimationController _innerController;

  @override
  void initState() {
    super.initState();

    _outerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _innerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // OUTER SPINNER (antiorario)
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(_outerController),
            child: SizedBox(
              width: 160,
              height: 160,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xFF8D5A23), // marrone scuro
                ),
              ),
            ),
          ),

          // INNER SPINNER (orario)
          RotationTransition(
            turns: _innerController,
            child: SizedBox(
              width: 160 * 0.6,
              height: 160 * 0.6,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xFFB89B6A), // marrone chiaro
                ),
              ),
            ),
          ),

          // LOGO CENTRALE
          Image.asset(
            'assets/images/logo_white.png',
            width: 80,
            height: 80,
          ),
        ],
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget spinner;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    required this.spinner,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: AnimatedOpacity(
                opacity: isLoading ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(child: spinner),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
