import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/offer_form_provider.dart';

/// Section des préférences alimentaires du formulaire d'offre
class OfferFormPreferencesFields extends ConsumerWidget {
  const OfferFormPreferencesFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);
    final l10n = AppLocalizations.of(context);

    // Design tokens responsives
    final chipSpacing = EcoPlatesDesignTokens.spacing.interfaceGap(context);
    final sectionSpacing = EcoPlatesDesignTokens.spacing.sectionSpacing(
      context,
    );
    final mediumSpacing = EcoPlatesDesignTokens.spacing.dialogGap(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Options alimentaires
        Wrap(
          spacing: chipSpacing,
          runSpacing: chipSpacing,
          children: [
            _buildFoodPreferenceChip(
              context,
              ref,
              label: l10n.offerFormPreferencesVegetarian,
              icon: Icons.eco,
              isSelected: formState.isVegetarian,
              onTap: () => ref
                  .read<OfferFormNotifier>(offerFormProvider.notifier)
                  .toggleVegetarian(),
            ),
            _buildFoodPreferenceChip(
              context,
              ref,
              label: l10n.offerFormPreferencesVegan,
              icon: Icons.grass,
              isSelected: formState.isVegan,
              onTap: () => ref
                  .read<OfferFormNotifier>(offerFormProvider.notifier)
                  .toggleVegan(),
            ),
            _buildFoodPreferenceChip(
              context,
              ref,
              label: l10n.offerFormPreferencesHalal,
              icon: Icons.mosque,
              isSelected: formState.isHalal,
              onTap: () => ref
                  .read<OfferFormNotifier>(offerFormProvider.notifier)
                  .toggleHalal(),
            ),
          ],
        ),

        SizedBox(height: sectionSpacing),

        // Allergènes
        Text(
          l10n.offerFormPreferencesAllergens,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: EcoPlatesDesignTokens.typography.bold,
            fontSize: EcoPlatesDesignTokens.typography.text(context),
          ),
        ),
        SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),

        // Liste des allergènes courants
        Wrap(
          spacing: chipSpacing,
          runSpacing: chipSpacing,
          children: _commonAllergens.map((allergen) {
            final isSelected = formState.allergens.contains(allergen);
            return FilterChip(
              label: Text(
                allergen,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                final currentAllergens = List<String>.from(formState.allergens);
                if (selected) {
                  if (!currentAllergens.contains(allergen)) {
                    currentAllergens.add(allergen);
                  }
                } else {
                  currentAllergens.remove(allergen);
                }
                ref
                    .read<OfferFormNotifier>(offerFormProvider.notifier)
                    .updateAllergens(currentAllergens);
              },
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(
                    alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
                  ),
              selectedColor: theme.colorScheme.secondaryContainer,
              checkmarkColor: theme.colorScheme.onSecondaryContainer,
            );
          }).toList(),
        ),

        SizedBox(height: mediumSpacing),

        // Champ pour ajouter un allergène personnalisé
        Row(
          children: [
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.offerFormPreferencesCustomAllergen,
                  hintText: l10n.offerFormPreferencesCustomAllergenHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.fieldRadius(context),
                    ),
                  ),
                  contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                    context,
                  ),
                ),
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                ),
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty &&
                      !formState.allergens.contains(value.trim())) {
                    final currentAllergens = List<String>.from(
                      formState.allergens,
                    )..add(value.trim());
                    ref
                        .read<OfferFormNotifier>(offerFormProvider.notifier)
                        .updateAllergens(currentAllergens);
                  }
                },
              ),
            ),
            SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
            IconButton(
              icon: Icon(
                Icons.add,
                size: EcoPlatesDesignTokens.size.icon(context),
              ),
              onPressed: () {
                // TODO: Implémenter l'ajout d'allergène personnalisé
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.offerFormPreferencesFeatureToImplement,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.text(
                          context,
                        ),
                      ),
                    ),
                  ),
                );
              },
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),

        // Affichage des allergènes sélectionnés
        if (formState.allergens.isNotEmpty) ...[
          SizedBox(height: mediumSpacing),
          Container(
            padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(
                alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.fieldRadius(context),
              ),
              border: Border.all(
                color: theme.colorScheme.error.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: theme.colorScheme.error,
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens.spacing.microGap(context),
                    ),
                    Text(
                      l10n.offerFormPreferencesDeclaredAllergens,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                        color: theme.colorScheme.error,
                        fontSize: EcoPlatesDesignTokens.typography.text(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                Wrap(
                  spacing: chipSpacing,
                  runSpacing: EcoPlatesDesignTokens.spacing.microGap(context),
                  children: formState.allergens.map((allergen) {
                    return Chip(
                      label: Text(
                        allergen,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: EcoPlatesDesignTokens.typography.medium,
                          fontSize: EcoPlatesDesignTokens.typography.text(
                            context,
                          ),
                        ),
                      ),
                      backgroundColor: theme.colorScheme.errorContainer,
                      deleteIcon: Icon(
                        Icons.close,
                        size: EcoPlatesDesignTokens.size.indicator(context),
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      onDeleted: () {
                        final currentAllergens = List<String>.from(
                          formState.allergens,
                        )..remove(allergen);
                        ref
                            .read<OfferFormNotifier>(offerFormProvider.notifier)
                            .updateAllergens(currentAllergens);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],

        // Informations sur les allergies
        SizedBox(height: mediumSpacing),
        Container(
          padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.fieldRadius(context),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: theme.colorScheme.primary,
                    size: EcoPlatesDesignTokens.size.icon(context),
                  ),
                  SizedBox(
                    width: EcoPlatesDesignTokens.spacing.microGap(context),
                  ),
                  Text(
                    l10n.offerFormPreferencesImportantInfo,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                      color: theme.colorScheme.primary,
                      fontSize: EcoPlatesDesignTokens.typography.text(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
              Text(
                l10n.offerFormPreferencesAllergenInfoText,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  height: EcoPlatesDesignTokens.layout.textLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodPreferenceChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    // Design tokens responsives
    final chipPadding = EcoPlatesDesignTokens.spacing
        .contentPadding(context)
        .copyWith(
          left: EcoPlatesDesignTokens.spacing.dialogGap(context),
          right: EcoPlatesDesignTokens.spacing.dialogGap(context),
        );
    final chipSpacing = EcoPlatesDesignTokens.spacing.interfaceGap(context);
    final chipRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final iconSize = EcoPlatesDesignTokens.size.icon(context);
    final checkIconSize = EcoPlatesDesignTokens.size.indicator(context);
    final textSize = EcoPlatesDesignTokens.typography.text(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(chipRadius),
      child: Container(
        padding: chipPadding,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
                ),
          borderRadius: BorderRadius.circular(chipRadius),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
            width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: chipSpacing),
            Text(
              label,
              style: TextStyle(
                fontWeight: EcoPlatesDesignTokens.typography.medium,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: textSize,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
              Icon(
                Icons.check,
                size: checkIconSize,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Liste des allergènes courants
const List<String> _commonAllergens = [
  'Gluten',
  'Lait',
  'Œufs',
  'Arachides',
  'Fruits à coque',
  'Poisson',
  'Crustacés',
  'Moutarde',
  'Sésame',
  'Soja',
  'Céleri',
  'Sulfites',
];
