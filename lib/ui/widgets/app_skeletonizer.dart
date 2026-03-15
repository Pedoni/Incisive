import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppSkeletonizer extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const AppSkeletonizer({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Color.fromARGB(255, 238, 229, 207),
        highlightColor: Color.fromARGB(255, 217, 204, 173),
        duration: Duration(seconds: 1),
      ),
      enabled: enabled,
      child: child,
    );
  }
}