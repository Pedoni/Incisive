import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialManager {
  static const String _tutorialKey = 'home_tutorial_done';

  static Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_tutorialKey) ?? false);
  }

  static Future<void> markTutorialDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialKey, true);
  }

  /// resetta il tutorial (utile per debug)
  static Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialKey);
  }

  static List<TargetFocus> buildTargets({
    required GlobalKey levelKey,
    required GlobalKey profileKey,
    required GlobalKey shopKey,
    required GlobalKey bedroomKey,
    required GlobalKey livingRoomKey,
    required GlobalKey gardenKey,
    required GlobalKey squareKey,
  }) {
    return [
      _buildTarget(
        key: bedroomKey,
        identify: 'bedroom',
        title: '🛏️ La Stanza',
        body: 'Questo è il tuo spazio privato. Qui puoi scrivere nel diario cliccando l\'icona sul comodino e interagire con il tuo assistente virtuale cliccando sulla cuccia di Pixel.',
        align: ContentAlign.top,
        shape: ShapeLightFocus.Circle,
      ),
      _buildTarget(
        key: livingRoomKey,
        identify: 'living_room',
        title: '🪑 Il Salotto',
        body: 'Nel salotto puoi fermarti a riflettere e scrivere i tuoi pensieri di gratitudine cliccando sulla lavagna.',
        align: ContentAlign.top,
        shape: ShapeLightFocus.Circle,
      ),
      _buildTarget(
        key: gardenKey,
        identify: 'garden',
        title: '🌿 Il Giardino',
        body: 'Il giardino è il luogo della calma. Qui, cliccando sulla statua del Buddha, trovi degli esercizi di respirazione per rilassarti.',
        align: ContentAlign.top,
        shape: ShapeLightFocus.Circle,
      ),
      _buildTarget(
        key: squareKey,
        identify: 'square',
        title: '🏙️ La Piazza',
        body: 'La piazza è il cuore sociale. Cliccando sulla bacheca puoi chiedere consigli o aiutare qualcuno in difficoltà se te la senti, sempre in forma anonima!\n\nRicorda, sei tu a decidere quando e come interagire. Incisive è il tuo spazio, usalo come preferisci!',
        align: ContentAlign.top,
        shape: ShapeLightFocus.Circle,
      ),
      _buildTarget(
        key: levelKey,
        identify: 'level',
        title: '⭐ Il tuo livello',
        body: 'Qui puoi vedere il tuo livello e i tuoi progressi. Più attività completi, più punti guadagni e sali di livello.',
        align: ContentAlign.bottom,
        shape: ShapeLightFocus.RRect,
      ),
      _buildTarget(
        key: profileKey,
        identify: 'profile',
        title: '👤 Profilo',
        body: 'Accedi al tuo profilo per personalizzare il tuo avatar e la tua esperienza.',
        align: ContentAlign.bottom,
        shape: ShapeLightFocus.Circle,
      ),
      _buildTarget(
        key: shopKey,
        identify: 'shop',
        title: '🛒 Negozio',
        body: 'Nel negozio puoi spendere i punti guadagnati per sbloccare nuovi avatar e personalizzazioni.',
        align: ContentAlign.bottom,
        shape: ShapeLightFocus.Circle,
      ),
    ];
  }

  static TargetFocus _buildTarget({
    required GlobalKey key,
    required String identify,
    required String title,
    required String body,
    required ContentAlign align,
    ShapeLightFocus shape = ShapeLightFocus.RRect,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      shape: shape,
      radius: 40,
      paddingFocus: 12,
      enableOverlayTab: true,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return _TutorialCard(title: title, body: body);
          },
        ),
      ],
    );
  }

  static TutorialCoachMark build({
    required BuildContext context,
    required List<TargetFocus> targets,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
    void Function(int index)? onStepShown,
  }) {
    String? _lastTriggered;

    void goToNext(TargetFocus target) {
      if (_lastTriggered == target.identify) return;
      _lastTriggered = target.identify;
      Future.delayed(const Duration(milliseconds: 50), () => _lastTriggered = null);

      final index = targets.indexWhere((t) => t.identify == target.identify);
      final nextIndex = index + 1;
      if (nextIndex < targets.length) {
        // cambia stanza solo quando il prossimo step è una stanza
        const roomIds = ['bedroom', 'living_room', 'garden', 'square'];
        final nextIdentify = targets[nextIndex].identify;
        if (roomIds.contains(nextIdentify)) {
          final roomIndex = roomIds.indexOf(nextIdentify);
          onStepShown?.call(roomIndex);
        }
      }
    }

    return TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF8D5A23),
      opacityShadow: 0.85,
      textSkip: 'Salta',
      textStyleSkip: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 400),
      unFocusAnimationDuration: const Duration(milliseconds: 400),
      pulseAnimationDuration: const Duration(milliseconds: 800),
      onClickTarget: (target) => goToNext(target),
      onClickOverlay: (target) => goToNext(target),
      onFinish: () {
        markTutorialDone();
        onFinish?.call();
      },
      onSkip: () {
        markTutorialDone();
        onSkip?.call();
        return true;
      },
    );
  }
}

/// card mostrata nel tooltip del tutorial
class _TutorialCard extends StatelessWidget {
  final String title;
  final String body;

  const _TutorialCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8D5A23),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 14,
              color: Color(0xFF4A3728),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Tocca lo schermo per continuare →',
              style: TextStyle(
                fontFamily: 'Nunito Sans',
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}