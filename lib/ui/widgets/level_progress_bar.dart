import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';

class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({super.key});

  static const double height = 40;
  static const double levelSize = 36;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, BaseState>(
      builder: (context, state) {
        if (state is! Success<UserModel>) {
          return const SizedBox(height: height);
        }

        final user = state.data;

        return SizedBox(
          height: height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Livello (cerchio)
              Container(
                width: levelSize,
                height: levelSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2E7D32), // verde scuro
                ),
                alignment: Alignment.center,
                child: Text(
                  user.level.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // 🔹 Progress bar (attaccata)
              Container(
                height: 16,
                width: 110,
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFA5D6A7), // verde chiaro
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: user.progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32), // verde scuro
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
