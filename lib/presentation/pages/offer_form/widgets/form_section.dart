import 'package:flutter/material.dart';

/// Widget amélioré pour les sections du formulaire avec icône et titre
class FormSection extends StatelessWidget {
  const FormSection({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
    this.isCompleted = false,
    this.isRequired = false,
    this.isCurrent = false,
    this.onSectionTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isCompleted;
  final bool isRequired;
  final bool isCurrent;
  final VoidCallback? onSectionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onSectionTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primaryContainer.withOpacity(0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isCurrent
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
            width: isCurrent ? 2.0 : 1.0,
          ),
          boxShadow: [
            if (isCurrent)
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.1),
                blurRadius: 8.0,
                offset: Offset(0, 2.0),
              ),
          ],
        ),
        child: Column(
          children: [
            // En-tête de la section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isCurrent
                    ? colorScheme.primary.withOpacity(0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Row(
                children: [
                  // Icône avec statut
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? colorScheme.primary.withOpacity(0.1)
                          : colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : icon,
                      color: isCompleted
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 12.0),
                  // Titre et sous-titre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (isRequired) ...[
                              SizedBox(width: 4.0),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 4.0),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Indicateur de statut
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: 24.0,
                    ),
                ],
              ),
            ),
            // Contenu de la section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
