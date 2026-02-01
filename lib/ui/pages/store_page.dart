import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/user_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';

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
        body: Column(
          children: const [
            LevelHeader(),
            Material(
              color: Color(0xFFFFF8E8),
              child: TabBar(
                indicatorColor: Color.fromARGB(255, 141, 90, 35),
                labelColor: Color.fromARGB(255, 141, 90, 35),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Sfondo"),
                  Tab(text: "Avatar"),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  ColorsProgressTab(),
                  AvatarShopTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelHeader extends StatelessWidget {
  const LevelHeader({super.key});

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
    return BlocBuilder<ProfileBloc, BaseState>(
      builder: (context, state) {
        if (state is! Success<UserModel>) {
          return const SizedBox(height: 100);
        }

        final user = state.data;
        return Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFFFF8E8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Livello ${user.level}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 141, 90, 35),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: levelProgress(user.points, user.level),
                backgroundColor: Colors.brown.shade100,
                color: const Color.fromARGB(255, 141, 90, 35),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.eco, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    "${user.points - user.spentPoints} foglie disponibili",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 141, 90, 35),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ColorsProgressTab extends StatelessWidget {
  const ColorsProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final int userLevel = 12;

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

        final reached = userLevel >= levelRequired;

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
  const AvatarShopTab({super.key});

  @override
  Widget build(BuildContext context) {
    final availablePoints = 340;

    final avatars = [
      {"id": 1, "name": "Pixel Foglia", "cost": 500},
      {"id": 2, "name": "Pixel Stellina", "cost": 500},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final canBuy = availablePoints >= (avatar["cost"] as int);

        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 30),
              const SizedBox(height: 8),
              Text(avatar["name"] as String),
              const SizedBox(height: 6),
              Text("${avatar["cost"]} foglie"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: canBuy ? () {} : null,
                child: Text(canBuy ? "Acquista" : "Non disponibile"),
              ),
            ],
          ),
        );
      },
    );
  }
}
