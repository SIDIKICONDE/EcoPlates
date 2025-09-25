import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/offer_form_provider.dart';

/// Section des préférences alimentaires du formulaire d'offre
class OfferFormPreferencesFields extends ConsumerWidget {
  const OfferFormPreferencesFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Options alimentaires
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFoodPreferenceChip(
              context,
              ref,
              label: 'Végétarien',
              icon: Icons.eco,
              isSelected: formState.isVegetarian,
              onTap: () =>
                  ref.read(offerFormProvider.notifier).toggleVegetarian(),
            ),
            _buildFoodPreferenceChip(
              context,
              ref,
              label: 'Végan',
              icon: Icons.grass,
              isSelected: formState.isVegan,
              onTap: () => ref.read(offerFormProvider.notifier).toggleVegan(),
            ),
            _buildFoodPreferenceChip(
              context,
              ref,
              label: 'Halal',
              icon: Icons.mosque,
              isSelected: formState.isHalal,
              onTap: () => ref.read(offerFormProvider.notifier).toggleHalal(),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Allergènes
        Text(
          'Allergènes',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Liste des allergènes courants
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonAllergens.map((allergen) {
            final isSelected = formState.allergens.contains(allergen);
            return FilterChip(
              label: Text(allergen),
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
              selectedColor: theme.colorScheme.secondaryContainer,
              checkmarkColor: theme.colorScheme.onSecondaryContainer,
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Champ pour ajouter un allergène personnalisé
        Row(
          children: [
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Allergène personnalisé',
                  hintText: 'Ex: Sulfites, colorants...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty &&
                      !formState.allergens.contains(value.trim())) {
                    final currentAllergens = List<String>.from(
                      formState.allergens,
                    );
                    currentAllergens.add(value.trim());
                    ref
                        .read(offerFormProvider.notifier)
                        .updateAllergens(currentAllergens);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implémenter l'ajout d'allergène personnalisé
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à implémenter')),
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
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
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Allergènes déclarés',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: formState.allergens.map((allergen) {
                    return Chip(
                      label: Text(
                        allergen,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.errorContainer,
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      onDeleted: () {
                        final currentAllergens = List<String>.from(
                          formState.allergens,
                        );
                        currentAllergens.remove(allergen);
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
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.health_and_safety,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Informations importantes',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Déclaration optionnelle mais recommandée pour la sécurité des clients allergiques.',
                style: TextStyle(
                  fontSize: 12,
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check,
                size: 16,
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
