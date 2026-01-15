import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/pages/user_profile_page.dart';

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
            height: toolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 141, 90, 35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        BlocBuilder<ProfileBloc, BaseState>(
                          builder: (context, state) {
                            return state is Success<UserModel>
                                ? Text(
                                  state.data.points.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                                : SizedBox();
                          },
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/leaf.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: SizedBox()),
                  _TopIcon(
                    icon: Icons.person_2,
                    onTap: () {
                      context.read<ProfileBloc>().getProfile();
                      Navigator.pushNamed(context, UserProfilePage.routeName);
                    },
                  ),
                  SizedBox(width: 15),
                  _TopIcon(
                    icon: Icons.settings,
                    onTap: () {},
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
