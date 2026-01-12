import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/login/login_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/pages/login_page.dart';
import 'package:incisive/ui/widgets/logout_dialog.dart';
import 'package:incisive/utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfilePage extends StatelessWidget {
  static const routeName = '/userProfilePage';

  const UserProfilePage({super.key});

  static const double headerHeight = 240;
  static const double avatarRadius = 54;

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFFFF8E8),
      elevation: 0,
      title: const Text(
        'Profilo',
        style: TextStyle(
          fontSize: 25,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        ),
      ],
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      extendBodyBehindAppBar: true,
      appBar: appbar,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final user = state is ResultProfileState ? state.user : Constants.mockedUser;
          return Stack(
            children: [
              const _TopHeader(height: headerHeight),

              Positioned(
                top: headerHeight - avatarRadius - 30,
                left: 0,
                right: 0,
                child: const _AvatarSection(),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: headerHeight - appbar.preferredSize.height),
                  child: Skeletonizer(
                    enabled: state is LoadingProfileState || state is InitialProfileState,
                    child: Column(
                      children: [
                        _InfoField(
                          icon: Icons.person,
                          text: '${user.firstName} ${user.lastName}',
                        ),
                        SizedBox(height: 12),
                        _InfoField(
                          icon: Icons.email,
                          text: user.email,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),

              // LOGOUT IN BASSO
              const _LogoutAlignedBottom(),
            ],
          );
        },
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final double height;
  const _TopHeader({required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        height: height,
        color: Color.fromARGB(255, 141, 90, 35),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 54;
    return CircleAvatar(
      radius: avatarRadius,
      backgroundColor: const Color(0xFFF7D85B),
      child: CircleAvatar(
        radius: avatarRadius - 8,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 48,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoField({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 248, 234, 200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutAlignedBottom extends StatelessWidget {
  const _LogoutAlignedBottom();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 32,
      child: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 141, 90, 35),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () async {
            final bool res = await showDialog(
              context: context,
              builder: (ctx) => LogoutDialog(),
            );
            if (res && context.mounted) {
              await context.read<LoginBloc>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginPage.routeName,
                  (Route<dynamic> route) => false,
                );
              }
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ),
    );
  }
}
