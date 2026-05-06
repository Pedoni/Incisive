import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:incisive/models/user_preferences_model.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/questionnaire/questionnaire_bloc.dart';
import 'package:incisive/ui/pages/home_page.dart';
import 'package:incisive/utils/incisive_colors.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  static const routeName = '/questionnaire';

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage>
    with SingleTickerProviderStateMixin {
  int _currentQuestion = 0;
  final Map<int, String> _answers = {};

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const int _totalQuestions = 4;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectAnswer(String value) {
    setState(() => _answers[_currentQuestion] = value);
  }

  Future<void> _goNext() async {
    if (_answers[_currentQuestion] == null) return;

    context
        .read<QuestionnaireBloc>()
        .add(AnswerSelected(questionIndex: _currentQuestion, value: _answers[_currentQuestion]!));

    if (_currentQuestion < _totalQuestions - 1) {
      await _animController.reverse();
      setState(() => _currentQuestion++);
      _animController.forward();
    } else {
      context.read<QuestionnaireBloc>().add(SubmitQuestionnaire());
    }
  }

  void _goBack() {
    if (_currentQuestion == 0) return;
    _animController.reverse().then((_) {
      setState(() => _currentQuestion--);
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionnaireBloc, BaseState>(
      listener: (context, state) {
        if (state is Success<void>) {
          context.go(HomePage.routeName);
        } else if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorString ?? 'Errore durante il salvataggio'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: IncisiveColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildQuestionCard(),
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          AnimatedOpacity(
            opacity: _currentQuestion > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: _currentQuestion > 0 ? _goBack : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF8D5A23),
                ),
              ),
            ),
          ),
          const Spacer(),
          // pixel avatar
          Image.asset(
            'assets/images/pixel.png',
            width: 80,
            height: 80,
          ),
          const Spacer(),
          // pulsante salta
          if (_currentQuestion == 0)
            TextButton(
              onPressed: () {
                context.read<QuestionnaireBloc>().add(SkipQuestionnaire());
              },
              child: const Text(
                'Salta',
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 14,
                  color: Color(0xFFB08040),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Domanda ${_currentQuestion + 1} di $_totalQuestions',
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 13,
              color: Color(0xFFB08040),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentQuestion + 1) / _totalQuestions,
              backgroundColor: const Color(0xFFE8D9C0),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF8D5A23)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final q = QuestionnaireData.questions[_currentQuestion];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            q.question,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: IncisiveColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          ...q.options.map(
            (opt) => _buildOptionTile(opt),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(QuestionnaireOption opt) {
    final isSelected = _answers[_currentQuestion] == opt.value;

    return GestureDetector(
      onTap: () => _selectAnswer(opt.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? IncisiveColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? IncisiveColors.primary
                : const Color(0xFFE0CEAB),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? IncisiveColors.primary.withValues(alpha: 0.20)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(opt.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                opt.label,
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF4A3728),
                  height: 1.35,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final isLast = _currentQuestion == _totalQuestions - 1;
    final canProceed = _answers[_currentQuestion] != null;

    return BlocBuilder<QuestionnaireBloc, BaseState>(
      builder: (context, state) {
        final isLoading = state is Loading;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: canProceed && !isLoading ? _goNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: IncisiveColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFD4BC9A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: canProceed ? 4 : 0,
                shadowColor: Color(0xFF8D5A23).withValues(alpha: 0.4),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLast ? 'Inizia l\'avventura 🐾' : 'Avanti',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isLast) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
