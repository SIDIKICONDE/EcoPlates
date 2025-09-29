import 'package:flutter/material.dart';

/// Indicateur de progression du formulaire
class FormProgressIndicator extends StatelessWidget {
  const FormProgressIndicator({
    required this.progress,
    required this.steps,
    super.key,
  });

  final double progress;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.1),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          // Barre de progression et pourcentage
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                  minHeight: 8.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Étapes
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = index < (progress * steps.length);
              final isCurrent = index == (progress * steps.length).floor();

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    children: [
                      Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? colorScheme.primary
                              : isCurrent
                              ? colorScheme.primary.withOpacity(0.5)
                              : colorScheme.surfaceContainerHighest,
                        ),
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: 16.0,
                                color: colorScheme.onPrimary,
                              )
                            : isCurrent
                            ? Icon(
                                Icons.radio_button_unchecked,
                                size: 16.0,
                                color: colorScheme.primary,
                              )
                            : null,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        step,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 12.0,
                          color: isCompleted || isCurrent
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
