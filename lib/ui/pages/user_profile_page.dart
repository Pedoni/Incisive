import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/avatar_model.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/avatar/avatar_bloc.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/login/login_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/widgets/logout_dialog.dart';
import 'package:incisive/ui/widgets/state_error_view.dart';
import 'package:incisive/utils/constants.dart';
import 'package:incisive/utils/functions.dart';
import 'package:incisive/utils/incisive_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:incisive/state_management/blocs/questionnaire/questionnaire_bloc.dart';
import 'package:incisive/ui/widgets/preferences_section.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionnaireBloc()..add(LoadPreferences()),
      child: Scaffold(
        backgroundColor: IncisiveColors.background,
        appBar: AppBar(
          backgroundColor: IncisiveColors.primary,
          foregroundColor: IncisiveColors.background,
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
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          ],
        ),
        body: BlocConsumer<ProfileBloc, BaseState>(
          listener: (context, state) {
            if (state is Error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorString ?? 'Errore nel caricamento del profilo.'),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is Error) {
              return StateErrorView(
                message: state.errorString ?? 'Impossibile caricare il profilo.',
                onRetry: () => context.read<ProfileBloc>().getProfile(),
              );
            }

            final user = state is Success ? state.data as UserModel : Constants.mockedUser;
            final isLoading = state is Loading || state is Initial;

            return Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: const BoxDecoration(
                        color: IncisiveColors.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: _AvatarSection(user: user, loading: isLoading),
                    ),
                    const SizedBox(height: 24),
                    _InfoField(icon: Icons.person, text: '${user.firstName} ${user.lastName}'),
                    const SizedBox(height: 12),
                    _InfoField(icon: Icons.email, text: user.email),
                    const SizedBox(height: 24),
                    const PreferencesSection(), 
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: IncisiveColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final UserModel user;
  final bool loading;

  const _AvatarSection({required this.user, required this.loading});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarBloc, BaseState>(
      builder: (context, state) {
        // In caso di errore mostriamo solo il placeholder senza bloccare la pagina,
        // dato che l'avatar è un dettaglio secondario rispetto al profilo.
        String? avatarAsset;
        if (state is Success<List<AvatarModel>>) {
          final equippedAvatar = state.data.firstWhere(
            (a) => a.equipped,
            orElse: () => state.data.first,
          );
          avatarAsset = equippedAvatar.asset;
        }

        return GestureDetector(
          onTap: avatarAsset == null
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
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
              child: loading || avatarAsset == null
                  ? null
                  : Image.asset("assets/images/$avatarAsset"),
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

  const _InfoField({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}