import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TimerBadge extends StatelessWidget {
  final int timeLeft;

  const TimerBadge({super.key, required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    final bool isLow = timeLeft <= 5;
    final color = isLow ? AppColors.wrongRed : AppColors.primaryCyan;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            '${timeLeft}s',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
