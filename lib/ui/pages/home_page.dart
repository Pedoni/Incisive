import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/state_management/blocs/profile_bloc/profile_bloc.dart';
import 'package:incisive/ui/components/bedroom_game.dart';
import 'package:incisive/ui/components/garden_game.dart';
import 'package:incisive/ui/components/living_room_game.dart';
import 'package:incisive/ui/components/square_game.dart';
import 'package:incisive/ui/pages/chat_page.dart';
import 'package:incisive/ui/pages/diary_page.dart';
import 'package:incisive/ui/pages/gratitude_page.dart';
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
            /*FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, ChatPage.routeName),
              foregroundColor: Color.fromARGB(255, 141, 90, 35),
              shape: const CircleBorder(),
              child: Icon(Icons.pets),
            ),
            SizedBox(height: 20),*/
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

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().getProfile();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? 0.0;
      });
    });

    bedroomGame = BedroomGame(
      onDiaryTap: () {
        Navigator.pushNamed(context, DiaryPage.routeName);
      },
      onPetTap: () => Navigator.pushNamed(context, ChatPage.routeName),
    );

    livingRoomGame = LivingRoomGame(
      onBlackboardTap: () {
        context.read<GratitudePageBloc>().getGratitudePage(DateTime.now());
        Navigator.pushNamed(context, GratitudePage.routeName);
      },
    );

    gardenGame = GardenGame(
      onStatueTap: () {},
    );

    squareGame = SquareGame();
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
                0 => GameWidget(game: bedroomGame),
                1 => GameWidget(game: livingRoomGame),
                2 => GameWidget(game: gardenGame),
                3 => GameWidget(game: squareGame),
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
                  onTap: () {
                    Navigator.pushNamed(context, DiaryPage.routeName);
                  },
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
