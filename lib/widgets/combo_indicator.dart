import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ComboIndicator extends StatelessWidget {
  final int streak;

  const ComboIndicator({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentYellow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentYellow.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥 ', style: TextStyle(fontSize: 14)),
          Text(
            'COMBO x$streak!',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
