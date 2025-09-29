import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    // Valeurs en dur
    const chipSpacing = 8.0;
    const sectionSpacing = 16.0;
    const mediumSpacing = 12.0;

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
              onTap: () =>
                  ref.read(offerFormProvider.notifier).toggleVegetarian(),
            ),
            _buildFoodPreferenceChip(
              context,
              ref,
              label: l10n.offerFormPreferencesVegan,
              icon: Icons.grass,
              isSelected: formState.isVegan,
              onTap: () => ref.read(offerFormProvider.notifier).toggleVegan(),
            ),
            _buildFoodPreferenceChip(
              context,
              ref,
              label: l10n.offerFormPreferencesHalal,
              icon: Icons.mosque,
              isSelected: formState.isHalal,
              onTap: () => ref.read(offerFormProvider.notifier).toggleHalal(),
            ),
          ],
        ),

        SizedBox(height: sectionSpacing),

        // Allergènes
        Text(
          l10n.offerFormPreferencesAllergens,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),

        // Liste des allergènes courants
        Wrap(
          spacing: chipSpacing,
          runSpacing: chipSpacing,
          children: _commonAllergens.map((allergen) {
            final isSelected = formState.allergens.contains(allergen);
            return FilterChip(
              label: Text(
                allergen,
                style: TextStyle(fontSize: 14.0),
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
                    .read(offerFormProvider.notifier)
                    .updateAllergens(currentAllergens);
              },
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                style: TextStyle(fontSize: 16.0),
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty &&
                      !formState.allergens.contains(value.trim())) {
                    final currentAllergens = List<String>.from(
                      formState.allergens,
                    )..add(value.trim());
                    ref
                        .read(offerFormProvider.notifier)
                        .updateAllergens(currentAllergens);
                  }
                },
              ),
            ),
            SizedBox(width: 8.0),
            IconButton(
              icon: Icon(Icons.add, size: 24.0),
              onPressed: () {
                // TODO: Implémenter l'ajout d'allergène personnalisé
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.offerFormPreferencesFeatureToImplement,
                      style: TextStyle(fontSize: 14.0),
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
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.5),
                width: 1.0,
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
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      l10n.offerFormPreferencesDeclaredAllergens,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Wrap(
                  spacing: chipSpacing,
                  runSpacing: 6.0,
                  children: formState.allergens.map((allergen) {
                    return Chip(
                      label: Text(
                        allergen,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.errorContainer,
                      deleteIcon: Icon(
                        Icons.close,
                        size: 18.0,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      onDeleted: () {
                        final currentAllergens = List<String>.from(
                          formState.allergens,
                        )..remove(allergen);
                        ref
                            .read(offerFormProvider.notifier)
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
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: theme.colorScheme.primary,
                    size: 20.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    l10n.offerFormPreferencesImportantInfo,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                l10n.offerFormPreferencesAllergenInfoText,
                style: TextStyle(
                  fontSize: 12.0,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
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

    // Valeurs en dur
    const chipRadius = 20.0;
    const iconSize = 18.0;
    const checkIconSize = 16.0;
    const textSize = 14.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(chipRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(chipRadius),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
              size: iconSize,
            ),
            SizedBox(width: 6.0),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: textSize,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 6.0),
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
