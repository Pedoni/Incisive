import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/avatar_model.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/avatar/avatar_bloc.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/state_management/blocs/purchase/purchase_bloc.dart';
import 'package:incisive/utils/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StorePage extends StatelessWidget {
  static const routeName = '/storePage';

  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text(
            "Shop",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 141, 90, 35),
            ),
          ),
          foregroundColor: const Color.fromARGB(255, 141, 90, 35),
          backgroundColor: const Color(0xFFFFF8E8),
        ),
        body: BlocListener<PurchaseBloc, BaseState>(
          listener: (context, state) {
            if (state is Success<String>) {
              context.read<ProfileBloc>().getProfile();
            }
          },
          child: BlocConsumer<ProfileBloc, BaseState>(
            listener: (context, state) {
              if (state is Success<UserModel>) {
                context.read<AvatarBloc>().getAvatars();
              }
            },
            builder: (context, state) {
              final user = state is Success ? state.data as UserModel : Constants.mockedUser;
              return Column(
                children: [
                  _LevelHeader(user: user),
                  Material(
                    color: Color(0xFFFFF8E8),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Color.fromARGB(255, 141, 90, 35),
                      labelColor: Color.fromARGB(255, 141, 90, 35),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Avatar"),
                        Tab(text: "Sfondo"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Color(0xFFFFF8E8),
                      child: TabBarView(
                        children: [
                          _AvatarShopTab(user: user),
                          _ColorsProgressTab(user: user),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LevelHeader extends StatelessWidget {
  final UserModel user;

  const _LevelHeader({required this.user});

  int pointsRequiredForLevel(int level) {
    return 100 + (level - 1) * 10;
  }

  int totalPointsToReachLevel(int level) {
    int total = 0;
    for (int i = 1; i < level; i++) {
      total += pointsRequiredForLevel(i);
    }
    return total;
  }

  double levelProgress(int totalPoints, int level) {
    final pointsForCurrentLevel = totalPointsToReachLevel(level);
    final pointsForNextLevel = pointsRequiredForLevel(level);

    final pointsIntoLevel = totalPoints - pointsForCurrentLevel;

    return (pointsIntoLevel / pointsForNextLevel).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final userLoading = user.id == "mocked_user_id";
    return Skeletonizer(
      enabled: userLoading,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFFFF8E8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Livello ${user.level}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 141, 90, 35),
                  ),
                ),
                Text(
                  "${user.points}/${totalPointsToReachLevel(user.level + 1)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 141, 90, 35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: levelProgress(user.points, user.level),
              backgroundColor: Colors.brown.shade100,
              color: const Color.fromARGB(255, 141, 90, 35),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.eco, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  "${user.points - user.spentPoints} foglie disponibili",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 141, 90, 35),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorsProgressTab extends StatelessWidget {
  final UserModel user;

  const _ColorsProgressTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final milestones = [
      (1, Colors.white),
      (5, Colors.blue),
      (10, Colors.green),
      (20, Colors.red),
      (50, const Color.fromARGB(255, 184, 115, 51)),
      (75, const Color.fromARGB(255, 152, 151, 151)),
      (100, const Color.fromARGB(255, 224, 191, 0)),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final levelRequired = milestones[index].$1;
        final color = milestones[index].$2;

        final reached = user.level >= levelRequired;

        return Card(
          color: const Color.fromARGB(255, 247, 230, 193),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: color),
            title: Text("Livello $levelRequired"),
            trailing: reached ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.lock_outline),
          ),
        );
      },
    );
  }
}

class _AvatarShopTab extends StatelessWidget {
  final UserModel user;

  const _AvatarShopTab({required this.user});

  Widget _avatarButton(BuildContext context, AvatarModel avatar, UserModel user) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: avatar.owned ? Colors.grey.shade400 : const Color(0xFF2E7D32),
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey.shade400,
      disabledForegroundColor: Colors.white,
    );

    final availableLeaves = user.points - user.spentPoints;

    if (!avatar.owned) {
      return ElevatedButton(
        style: style,
        onPressed:
            availableLeaves >= avatar.cost
                ? () {
                  context.read<PurchaseBloc>().purchaseAvatar(avatar.id);
                }
                : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar.cost > 0) ...[
              const Icon(Icons.eco, color: Color.fromARGB(255, 74, 202, 78)),
              const SizedBox(width: 6),
            ],
            Text(avatar.cost == 0 ? "Gratis" : avatar.cost.toString()),
          ],
        ),
      );
    }

    if (avatar.equipped) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: const Color(0xFF2E7D32),
          disabledForegroundColor: Colors.white,
        ),
        onPressed: null,
        child: const Text("In uso"),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 235, 250, 221),
        foregroundColor: const Color(0xFF2E7D32),
      ),
      onPressed: () {
        context.read<PurchaseBloc>().equipAvatar(avatar.id);
      },
      child: const Text("Usa"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvatarBloc, BaseState>(
      builder: (context, state) {
        final userLoading = user.id == "mocked_user_id";
        final loading = state is Loading || state is Initial;
        final avatars = state is Success ? state.data as List<AvatarModel> : Constants.mockedAvatars;
        avatars.sort((a, b) => a.name.compareTo(b.name));
        return Skeletonizer(
          enabled: userLoading || loading,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              final avatar = avatars[index];

              return Stack(
                children: [
                  Positioned.fill(
                    child: Card(
                      elevation: 2,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      content: Image.asset("assets/images/${avatar.asset}"),
                                    ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color.fromARGB(255, 249, 220, 165),
                              child:
                                  userLoading || loading
                                      ? const SizedBox.shrink()
                                      : Image.asset(
                                        "assets/images/${avatar.asset}",
                                      ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(avatar.name),
                          const SizedBox(height: 6),
                          _avatarButton(context, avatar, user),
                        ],
                      ),
                    ),
                  ),
                  if (avatar.owned)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: const Icon(
                        Icons.check_circle,
                        color: Color(0xFF2E7D32),
                        size: 26,
                      ),
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
