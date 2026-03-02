import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/breathing/breathing_bloc.dart';
import 'package:incisive/state_management/blocs/profile/profile_bloc.dart';
import 'package:incisive/ui/widgets/breathing_dialog.dart';
import 'package:incisive/ui/widgets/loading_spinner.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isRunning = false;
  String _phaseText = 'Premi per iniziare';

  Timer? _phaseTimer;
  int _phaseIndex = 0;

  static const int _totalCycles = 3;
  int _completedCycles = 0;

  final List<_BreathingPhase> _phases = const [
    _BreathingPhase(text: 'Inspira', duration: 4),
    _BreathingPhase(text: 'Trattieni', duration: 2),
    _BreathingPhase(text: 'Espira', duration: 6),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startBreathing() {
    setState(() {
      _isRunning = true;
      _phaseIndex = 0;
      _completedCycles = 0;
      _phaseText = _phases[0].text;
    });

    _controller.forward(from: 0);
    _runPhase();
  }

  void _cancelBreathing() {
    _phaseTimer?.cancel();
    _controller.reset();
    _controller.stop();

    setState(() {
      _isRunning = false;
      _phaseText = 'Premi per iniziare';
    });
  }

  void _runPhase() {
    final phase = _phases[_phaseIndex];

    setState(() {
      _phaseText = phase.text;
    });

    if (phase.text == 'Inspira') {
      _controller.forward();
    } else if (phase.text == 'Espira') {
      _controller.reverse();
    }

    _phaseTimer = Timer(
      Duration(seconds: phase.duration),
      () {
        if (!_isRunning) return;

        _phaseIndex++;

        // Se abbiamo finito un giro completo
        if (_phaseIndex >= _phases.length) {
          _phaseIndex = 0;
          _completedCycles++;

          if (_completedCycles >= _totalCycles) {
            _finishSession();
            return;
          }
        }

        _runPhase();
      },
    );
  }

  void _finishSession() {
    _cancelBreathing();

    Future.delayed(const Duration(milliseconds: 100), () async {
      if (!mounted) return;

      context.read<BreathingBloc>().completeBreathing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BreathingBloc, BaseState>(
      listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore nel completare la sessione: ${state.errorString}'),
            ),
          );
        } else if (state is Success<int>) {
          context.read<ProfileBloc>().getProfile();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => BreathingDialog(points: state.data > 0 ? state.data : null),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is Loading,
          spinner: const LoadingSpinner(),
          child: Scaffold(
            backgroundColor: const Color(0xFFB7C7A3),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: const Color.fromARGB(255, 52, 73, 35),
            ),
            body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isRunning) ...[
                      const SizedBox(height: 16),
                      BreathingProgressDots(
                        total: _totalCycles,
                        completed: _completedCycles,
                      ),
                    ],
                    const Spacer(),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEFEBD8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.spa,
                            size: 64,
                            color: Color(0xFF6B8E4E),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    // TESTO FASE
                    Text(
                      _phaseText,
                      style: const TextStyle(
                        fontFamily: 'Nunito Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3E4E3A),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B8E4E),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: _isRunning ? _cancelBreathing : _startBreathing,
                        child: Text(
                          _isRunning ? 'Termina' : 'Inizia',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class _BreathingPhase {
  final String text;
  final int duration;

  const _BreathingPhase({
    required this.text,
    required this.duration,
  });
}

class BreathingProgressDots extends StatelessWidget {
  final int total;
  final int completed;

  const BreathingProgressDots({
    super.key,
    required this.total,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final bool isFilled = index < completed;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isFilled
                    ? const Color(0xFF6B8E4E) // verde
                    : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF6B8E4E),
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}
