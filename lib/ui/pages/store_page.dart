import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/utils/constants.dart';

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
        body: BlocBuilder<ProfileBloc, BaseState>(
          builder: (context, state) {
            final user = state is Success ? state.data as UserModel : Constants.mockedUser;
            return Column(
              children: [
                LevelHeader(user: user),
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
                        AvatarShopTab(user: user),
                        ColorsProgressTab(user: user),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LevelHeader extends StatelessWidget {
  final UserModel user;

  const LevelHeader({super.key, required this.user});

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
    return Container(
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
    );
  }
}

class ColorsProgressTab extends StatelessWidget {
  final UserModel user;

  const ColorsProgressTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final milestones = [
      (1, const Color.fromARGB(255, 217, 216, 216)),
      (5, Colors.blue),
      (10, Colors.green),
      (20, Colors.red),
      (50, const Color.fromARGB(255, 184, 115, 51)),
      (75, const Color.fromARGB(255, 185, 185, 185)),
      (100, const Color.fromARGB(255, 224, 191, 0)),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final levelRequired = milestones[index].$1;
        final color = milestones[index].$2;

        final reached = user.level >= levelRequired;

        return ListTile(
          leading: CircleAvatar(backgroundColor: color),
          title: Text("Livello $levelRequired"),
          trailing: reached ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.lock_outline),
        );
      },
    );
  }
}

class AvatarShopTab extends StatelessWidget {
  final UserModel user;

  const AvatarShopTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avatars = [
      {"id": 1, "name": "Pixel Foglia", "cost": 500},
      {"id": 2, "name": "Pixel Stellina", "cost": 600},
    ];

    return BlocBuilder<ProfileBloc, BaseState>(
      builder: (context, state) {
        final profileLoading = state is Loading || state is Initial;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: profileLoading ? 10 : avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            final canBuy = (user.points - user.spentPoints) >= (avatar["cost"] as int);

            return Card(
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 30, child: Image.asset("assets/images/cat_thumb.png")),
                  const SizedBox(height: 8),
                  Text(avatar["name"] as String),
                  const SizedBox(height: 6),
                  Text("${avatar["cost"]} foglie"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                      disabledForegroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                    onPressed: canBuy ? () {} : null,
                    child: const Text("Acquista"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
