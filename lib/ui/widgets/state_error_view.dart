import 'package:flutter/material.dart';
import 'package:incisive/utils/incisive_colors.dart';

class StateErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const StateErrorView({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.black38),
          const SizedBox(height: 12),
          Text(
            message ?? 'Errore nel caricamento',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: IncisiveColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              child: const Text('Riprova'),
            ),
          ],
        ],
      ),
    );
  }
}