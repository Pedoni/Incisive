import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';

class LevelBar extends StatelessWidget {
  const LevelBar({super.key});

  static const double height = 40;
  static const double badgeSize = 40;
  static const double horizontalPadding = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, BaseState>(
      builder: (context, state) {
        if (state is! Success<UserModel>) {
          return const SizedBox(height: height);
        }

        final user = state.data;

        return Container(
          height: height,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: const Color.fromARGB(128, 189, 213, 182), // verde chiaro base
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge, // IMPORTANTISSIMO
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final startOffset = (badgeSize * 0.5) / totalWidth;
              final effectiveProgress = startOffset + (1 - startOffset) * user.progress.clamp(0.0, 1.0);
              return Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: effectiveProgress,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),

                  // 🔹 Contenuto sopra
                  Row(
                    children: [
                      _LevelBadge(level: user.level),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final int level;

  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: LevelBar.badgeSize,
      height: LevelBar.badgeSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      alignment: Alignment.center,
      child: Text(
        level.toString(),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }
}
