import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/avatar_model.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/avatar/avatar_bloc.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/login/login_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/widgets/logout_dialog.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: const Color.fromARGB(255, 141, 90, 35),
      foregroundColor: const Color(0xFFFFF8E8),
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
      appBar: appBar,
      body: BlocBuilder<ProfileBloc, BaseState>(
        builder: (context, state) {
          final user = state is Success ? state.data as UserModel : Constants.mockedUser;

          return Skeletonizer(
            enabled: state is Loading || state is Initial,
            child: Column(
              children: [
                // HEADER + AVATAR
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 141, 90, 35),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: _AvatarSection(user: user, loading: state is Loading || state is Initial),
                ),

                const SizedBox(height: 24),

                // INFO
                _InfoField(
                  icon: Icons.person,
                  text: '${user.firstName} ${user.lastName}',
                ),
                const SizedBox(height: 12),
                _InfoField(
                  icon: Icons.email,
                  text: user.email,
                ),

                const Spacer(),

                // LOGOUT
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 141, 90, 35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      final bool res = await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) => const LogoutDialog(),
                      );
                      if (res && context.mounted) {
                        await context.read<LoginBloc>().logout();
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final UserModel user;
  final bool loading;

  const _AvatarSection({
    required this.user,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarBloc, BaseState>(
      builder: (context, state) {
        String? avatarAsset;

        if (state is Success<List<AvatarModel>>) {
          final equippedAvatar = state.data.firstWhere(
            (a) => a.equipped,
            orElse: () => state.data.first,
          );

          avatarAsset = equippedAvatar.asset;
        }

        return GestureDetector(
          onTap:
              avatarAsset == null
                  ? () {}
                  : () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            content: Image.asset("assets/images/$avatarAsset"),
                          ),
                    );
                  },
          child: CircleAvatar(
            radius: 54,
            backgroundColor: const Color.fromARGB(255, 212, 173, 18),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: getUserBackgroundColor(user.level),
              child:
                  loading || avatarAsset == null
                      ? null
                      : Image.asset(
                        "assets/images/$avatarAsset",
                      ),
            ),
          ),
        );
      },
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 248, 234, 200),
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
