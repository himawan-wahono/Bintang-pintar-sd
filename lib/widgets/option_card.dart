import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class OptionCard extends StatelessWidget {
  final String optionText;
  final int index;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final bool isHidden;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.optionText,
    required this.index,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.isHidden,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return const SizedBox(height: 12);
    }

    Color borderColors = Colors.grey.shade300;
    Color bgColor = Colors.white;
    Color textColor = AppColors.textDark;

    if (isAnswered) {
      if (isCorrect) {
        bgColor = AppColors.successGreen.withValues(alpha: 0.15);
        borderColors = AppColors.successGreen;
        textColor = const Color(0xFF065F46);
      } else if (isSelected && !isCorrect) {
        bgColor = AppColors.wrongRed.withValues(alpha: 0.15);
        borderColors = AppColors.wrongRed;
        textColor = const Color(0xFF991B1B);
      }
    } else if (isSelected) {
      borderColors = AppColors.primaryCyan;
      bgColor = AppColors.primaryCyan.withValues(alpha: 0.1);
    }

    final optionLabels = ['A', 'B', 'C', 'D'];
    final label = index < optionLabels.length ? optionLabels[index] : '${index + 1}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColors, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isAnswered && isCorrect
                        ? AppColors.successGreen
                        : (isAnswered && isSelected
                            ? AppColors.wrongRed
                            : AppColors.primaryCyan.withValues(alpha: 0.15)),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isAnswered
                          ? Colors.white
                          : AppColors.primaryCyan,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (isAnswered && isCorrect)
                  const Icon(Icons.check_circle, color: AppColors.successGreen, size: 26),
                if (isAnswered && isSelected && !isCorrect)
                  const Icon(Icons.cancel, color: AppColors.wrongRed, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
