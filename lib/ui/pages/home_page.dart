import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/state_management/blocs/avatar/avatar_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/components/bedroom_game.dart';
import 'package:incisive/ui/components/garden_game.dart';
import 'package:incisive/ui/components/living_room_game.dart';
import 'package:incisive/ui/components/square_game.dart';
import 'package:incisive/ui/widgets/home_toolbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  double _currentPage = 0.0;
  int currentIndex = 0;
  bool _isAnimating = false;

  final List<String> _images = [
    'assets/images/bedroom_unity.png',
    'assets/images/living_unity.png',
    'assets/images/garden_unity.png',
    'assets/images/square.png',
  ];

  Widget _buildFloatingBar() {
    return Positioned(
      bottom: 5,
      left: 30,
      right: 30,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color.fromARGB(128, 218, 193, 150),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.bed, 0),
                  _navItem(Icons.chair, 1),
                  _navItem(Icons.grass_sharp, 2),
                  _navItem(Icons.location_city, 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        _isAnimating = true;

        setState(() {
          currentIndex = index;
        });

        _controller
            .animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            )
            .then((_) {
              _isAnimating = false;
            });
      },

      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 141, 90, 35) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.white : Colors.white,
        ),
      ),
    );
  }

  late final BedroomGame bedroomGame;
  late final LivingRoomGame livingRoomGame;
  late final GardenGame gardenGame;
  late final SquareGame squareGame;

  Widget Function(dynamic) _getLoadingBuilder() {
    return (context) {
      return Container(
        color: const Color(0xFFFFF8E8),
        child: const Center(
          child: CircularProgressIndicator(color: Color.fromARGB(255, 141, 90, 35)),
        ),
      );
    };
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().getProfile();
    context.read<AvatarBloc>().getAvatars();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0.0;
      });
    });

    bedroomGame = BedroomGame(
      onDiaryTap: () {
        context.push(AppRoutes.diary);
      },
      onPetTap: () => context.push(AppRoutes.chat),
    );

    livingRoomGame = LivingRoomGame(
      onBlackboardTap: () {
        context.read<GratitudePageBloc>().getGratitudePage(DateTime.now());
        context.push(AppRoutes.gratitude);
      },
    );

    gardenGame = GardenGame(onStatueTap: () => context.push(AppRoutes.breathing));

    squareGame = SquareGame(onBulletinBoardTap: () => context.push(AppRoutes.social));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOverlayOpacity() {
    final diff = (_currentPage - _currentPage.round()).abs();
    return (diff * 4).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (index) {
              if (_isAnimating) return;

              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return switch (index) {
                0 => GameWidget(
                  game: bedroomGame,
                  loadingBuilder: _getLoadingBuilder(),
                ),
                1 => GameWidget(
                  game: livingRoomGame,
                  loadingBuilder: _getLoadingBuilder(),
                ),
                2 => GameWidget(
                  game: gardenGame,
                  loadingBuilder: _getLoadingBuilder(),
                ),
                3 => GameWidget(
                  game: squareGame,
                  loadingBuilder: _getLoadingBuilder(),
                ),
                _ => const SizedBox.shrink(),
              };
            },
          ),
          HomeToolbar(),
          IgnorePointer(child: Container(color: Colors.black.withValues(alpha: _calculateOverlayOpacity()))),
          _buildFloatingBar(),
        ],
      ),
    );
  }
}

class StanzaWidget extends StatelessWidget {
  final String imagePath;
  final int stanzaIndex;

  const StanzaWidget({super.key, required this.imagePath, required this.stanzaIndex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
            if (stanzaIndex == 0)
              Positioned(
                left: width * 0.1,
                top: height * 0.503,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.diary),
                  child: Hero(
                    tag: "diary",
                    transitionOnUserGestures: true,
                    child: Image.asset('assets/images/diary.png', width: width * 0.12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
