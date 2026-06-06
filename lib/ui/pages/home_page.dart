import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/chat_session.dart';
import 'package:incisive/navigation/app_routes.dart';
import 'package:incisive/state_management/blocs/avatar/avatar_bloc.dart';
import 'package:incisive/state_management/blocs/gratitude_page/gratitude_page_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/components/bedroom_game.dart';
import 'package:incisive/ui/components/garden_game.dart';
import 'package:incisive/ui/components/living_room_game.dart';
import 'package:incisive/ui/components/square_game.dart';
import 'package:incisive/ui/widgets/home_toolbar.dart';
import 'package:incisive/ui/widgets/tutorial_manager.dart';
import 'package:incisive/utils/incisive_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

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

  final GlobalKey toolbarLevelKey = GlobalKey();
  final GlobalKey toolbarProfileKey = GlobalKey();
  final GlobalKey toolbarShopKey = GlobalKey();
  final GlobalKey navBedroomKey = GlobalKey();
  final GlobalKey navLivingRoomKey = GlobalKey();
  final GlobalKey navGardenKey = GlobalKey();
  final GlobalKey navSquareKey = GlobalKey();

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
                  _navItem(Icons.bed, 0, key: navBedroomKey),
                  _navItem(Icons.chair, 1, key: navLivingRoomKey),
                  _navItem(Icons.grass_sharp, 2, key: navGardenKey),
                  _navItem(Icons.location_city, 3, key: navSquareKey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, {GlobalKey? key}) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      key: key,
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
          color: isSelected ? IncisiveColors.primary : Colors.transparent,
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
          child: CircularProgressIndicator(color: IncisiveColors.primary),
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _maybeStartTutorial();
      await _checkPendingNotification();
    });

  }

    Future<void> _maybeStartTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final questionnaireDone = prefs.getBool('questionnaire_done') ?? false;

    if (!questionnaireDone) return;
 
    final should = await TutorialManager.shouldShowTutorial();
    if (!should || !mounted) return;
    _showWelcomeDialog();
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👋', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text(
                'Benvenuto in Incisive!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D5A23),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Il tuo spazio digitale per il benessere mentale.\n\nEsplora le stanze, scrivi nel diario, pratica la gratitudine e connettiti con gli altri.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 15,
                  color: Color(0xFF4A3728),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _startTutorial();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D5A23),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Inizia il tour →',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  TutorialManager.markTutorialDone();
                },
                child: const Text(
                  'Salta',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 14,
                    color: Color(0xFF8D5A23),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTutorial() {
    final targets = TutorialManager.buildTargets(
      levelKey: toolbarLevelKey,
      profileKey: toolbarProfileKey,
      shopKey: toolbarShopKey,
      bedroomKey: navBedroomKey,
      livingRoomKey: navLivingRoomKey,
      gardenKey: navGardenKey,
      squareKey: navSquareKey,
    );

    TutorialManager.build(
      context: context,
      targets: targets,
      onStepShown: (index) {
        _isAnimating = true;
        setState(() => currentIndex = index);
        _controller
            .animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            )
            .then((_) => _isAnimating = false);
      },
    ).show(context: context);
  }

  Future<void> _checkPendingNotification() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastChecked = prefs.getString('notification_last_checked');
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split('T')[0];

      if (lastChecked == today) return;

      final data = await Supabase.instance.client
        .from('scheduled_notifications')
        .select()
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
        .lte('scheduled_for', today)
        .gte('scheduled_for', sevenDaysAgo)
        .eq('is_read', false)
        .order('scheduled_for', ascending: false)
        .limit(1)
        .maybeSingle();

      if (data == null || !mounted) return;

      await Supabase.instance.client
          .from('scheduled_notifications')
          .update({'is_read': true})
          .eq('id', data['id']);

      await prefs.setString('notification_last_checked', today);

      _showNotificationDialog(data['id'], data['message']);
    } catch (e) {
      // ignore: avoid_print
      print('[Notification] Errore: $e');
    }
  }

  void _showNotificationDialog(String id, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/cat_thumb.png'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pixel vuole sapere...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D5A23),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 15,
                  color: Color(0xFF4A3728),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ChatSession.messages.clear();
                    ChatSession.messages.insert(0, ChatMessage(false, message));
                    context.push(AppRoutes.chat);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D5A23),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Vai alla chat',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'Non ora',
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 14,
                    color: Color(0xFF8D5A23),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          HomeToolbar(
            levelKey: toolbarLevelKey,
            profileKey: toolbarProfileKey,
            shopKey: toolbarShopKey,
          ),
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
