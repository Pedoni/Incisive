import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/state_management/blocs/avatar/avatar_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/widgets/level_bar.dart';

class HomeToolbar extends StatelessWidget {
  const HomeToolbar({super.key});

  static const double toolbarHeight = 72;

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: toolbarHeight + topInset,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LevelBar(),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  _TopIcon(
                    icon: Icons.person_2,
                    onTap: () {
                      context.read<ProfileBloc>().getProfile();
                      context.read<AvatarBloc>().getAvatars();
                      context.push(AppRoutes.userProfile);
                    },
                  ),
                  SizedBox(width: 15),
                  _TopIcon(
                    icon: Icons.store,
                    onTap: () {
                      context.read<ProfileBloc>().getProfile();
                      context.push(AppRoutes.shop);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 141, 90, 35),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          icon,
          size: 28,
          color: const Color(0xFFF3ECDC).withValues(alpha: 0.85),
          shadows: const [
            Shadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
