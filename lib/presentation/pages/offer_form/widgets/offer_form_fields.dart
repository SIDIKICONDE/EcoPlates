import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_form_provider.dart';

/// Section des champs de base du formulaire d'offre
class OfferFormBasicFields extends ConsumerWidget {
  const OfferFormBasicFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    // Espacement adaptatif entre les champs
    final fieldSpacing = EcoPlatesDesignTokens.spacing.sectionSpacing(context);
    final fieldRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final contentPadding = EcoPlatesDesignTokens.spacing.contentPadding(
      context,
    );
    final textSize = EcoPlatesDesignTokens.typography.text(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        TextFormField(
          initialValue: formState.title,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: "Titre de l'offre *",
            hintText: 'Ex: Panier surprise déjeuner',
            prefixIcon: const Icon(Icons.title),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(fontSize: textSize),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le titre est requis';
            }
            if (value.trim().length <
                EcoPlatesDesignTokens.validation.titleMinLength) {
              return 'Au moins ${EcoPlatesDesignTokens.validation.titleMinLength} caractères';
            }
            if (value.trim().length >
                EcoPlatesDesignTokens.validation.titleMaxLength) {
              return 'Maximum ${EcoPlatesDesignTokens.validation.titleMaxLength} caractères';
            }
            return null;
          },
          onChanged: (value) {
            ref
                .read<OfferFormNotifier>(offerFormProvider.notifier)
                .updateTitle(value);
          },
        ),

        SizedBox(height: fieldSpacing),

        // Description
        TextFormField(
          initialValue: formState.description,
          maxLines: EcoPlatesDesignTokens.layout.descriptionLines(context),
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Description *',
            hintText:
                'Décrivez votre offre (ingrédients, quantité, particularités...)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
            contentPadding: contentPadding,
            alignLabelWithHint: true,
          ),
          style: TextStyle(fontSize: textSize),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La description est requise';
            }
            if (value.trim().length <
                EcoPlatesDesignTokens.validation.descriptionMinLength) {
              return 'Au moins ${EcoPlatesDesignTokens.validation.descriptionMinLength} caractères';
            }
            return null;
          },
          onChanged: (value) {
            ref
                .read<OfferFormNotifier>(offerFormProvider.notifier)
                .updateDescription(value);
          },
        ),

        SizedBox(height: fieldSpacing),

        // Type d'offre
        InkWell(
          onTap: () => _showOfferTypeModal(context, ref, formState.type),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: "Type d'offre *",
              prefixIcon: const Icon(Icons.restaurant_menu),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fieldRadius),
              ),
              contentPadding: contentPadding,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              formState.customType ?? _getOfferTypeLabel(formState.type),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: textSize,
              ),
            ),
          ),
        ),

        SizedBox(height: fieldSpacing),

        // Catégorie alimentaire
        InkWell(
          onTap: () async =>
              _showFoodCategoryModal(context, ref, formState.category),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Catégorie alimentaire *',
              prefixIcon: const Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fieldRadius),
              ),
              contentPadding: contentPadding,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              formState.customCategory ??
                  Categories.labelOf(formState.category),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: textSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showOfferTypeModal(
    BuildContext context,
    WidgetRef ref,
    OfferType currentType,
  ) async {
    // Hauteur maximale adaptative pour la modale
    final modalMaxHeight =
        MediaQuery.of(context).size.height *
        EcoPlatesDesignTokens.layout.modalHeightFactor(context);

    // Styles responsives pour la modale
    final titleSize = EcoPlatesDesignTokens.typography.text(context);
    final subtitleSize = EcoPlatesDesignTokens.typography.hint(context);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: modalMaxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Types prédéfinis
                  ...OfferType.values.map((type) {
                    final isSelected = type == currentType;

                    return ListTile(
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        size: EcoPlatesDesignTokens.size.icon(context),
                      ),
                      title: Text(
                        _getOfferTypeLabel(type),
                        style: TextStyle(fontSize: titleSize),
                      ),
                      subtitle: Text(
                        _getOfferTypeDescription(type),
                        style: TextStyle(fontSize: subtitleSize),
                      ),
                      contentPadding: EcoPlatesDesignTokens.spacing
                          .contentPadding(context),
                      onTap: () {
                        ref
                            .read<OfferFormNotifier>(offerFormProvider.notifier)
                            .updateType(type);
                        Navigator.of(context).pop();
                      },
                    );
                  }),
                  // Séparateur
                  const Divider(),
                  // Option personnalisée
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                    title: Text(
                      'Type personnalisé',
                      style: TextStyle(fontSize: titleSize),
                    ),
                    subtitle: Text(
                      "Définir votre propre type d'offre",
                      style: TextStyle(fontSize: subtitleSize),
                    ),
                    contentPadding: EcoPlatesDesignTokens.spacing
                        .contentPadding(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _showCustomTypeDialog(context, ref);
                    },
                  ),
                  // Espacement en bas
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.dialogGap(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCustomTypeDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController();

    // Espacement et styles responsives pour le dialogue
    final dialogPadding = EcoPlatesDesignTokens.spacing.contentPadding(context);
    final fieldRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final titleSize = EcoPlatesDesignTokens.typography.modalTitle(context);
    final contentSize = EcoPlatesDesignTokens.typography.modalContent(context);
    final textSize = EcoPlatesDesignTokens.typography.text(context);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Type d'offre personnalisé",
            style: TextStyle(fontSize: titleSize),
          ),
          contentPadding: dialogPadding,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Entrez le nom de votre type d'offre personnalisé :",
                style: TextStyle(fontSize: contentSize),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.validation.dialogContentSpacing,
              ),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "Type d'offre",
                  hintText: 'Ex: Menu spécial, Box déjeuner...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fieldRadius),
                  ),
                  contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                    context,
                  ),
                ),
                style: TextStyle(fontSize: textSize),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    // Pour l'instant, on utilise le type "autre" mais on stocke le nom personnalisé
                    ref
                        .read<OfferFormNotifier>(offerFormProvider.notifier)
                        .updateType(OfferType.autre);
                    ref
                        .read<OfferFormNotifier>(offerFormProvider.notifier)
                        .updateCustomType(value.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  // Pour l'instant, on utilise le type "autre" mais on stocke le nom personnalisé
                  ref
                      .read<OfferFormNotifier>(offerFormProvider.notifier)
                      .updateType(OfferType.autre);
                  ref
                      .read<OfferFormNotifier>(offerFormProvider.notifier)
                      .updateCustomType(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCustomCategoryDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController();

    // Espacement et styles responsives pour le dialogue
    final dialogPadding = EcoPlatesDesignTokens.spacing.contentPadding(context);
    final fieldRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final titleSize = EcoPlatesDesignTokens.typography.modalTitle(context);
    final contentSize = EcoPlatesDesignTokens.typography.modalContent(context);
    final textSize = EcoPlatesDesignTokens.typography.text(context);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Catégorie alimentaire personnalisée',
            style: TextStyle(fontSize: titleSize),
          ),
          contentPadding: dialogPadding,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Entrez le nom de votre catégorie alimentaire personnalisée :',
                style: TextStyle(fontSize: contentSize),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.validation.dialogContentSpacing,
              ),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Catégorie alimentaire',
                  hintText: 'Ex: Produits bio, Sans gluten...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fieldRadius),
                  ),
                  contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                    context,
                  ),
                ),
                style: TextStyle(fontSize: textSize),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    // Pour l'instant, on utilise la catégorie "autre" mais on stocke le nom personnalisé
                    ref
                        .read<OfferFormNotifier>(offerFormProvider.notifier)
                        .updateCategory(FoodCategory.autre);
                    ref
                        .read<OfferFormNotifier>(offerFormProvider.notifier)
                        .updateCustomCategory(value.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  // Pour l'instant, on utilise la catégorie "autre" mais on stocke le nom personnalisé
                  ref
                      .read<OfferFormNotifier>(offerFormProvider.notifier)
                      .updateCategory(FoodCategory.autre);
                  ref
                      .read<OfferFormNotifier>(offerFormProvider.notifier)
                      .updateCustomCategory(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFoodCategoryModal(
    BuildContext context,
    WidgetRef ref,
    FoodCategory currentCategory,
  ) async {
    // Hauteur maximale adaptative pour la modale
    final modalMaxHeight =
        MediaQuery.of(context).size.height *
        EcoPlatesDesignTokens.layout.modalHeightFactor(context);

    // Styles responsives pour la modale
    final titleSize = EcoPlatesDesignTokens.typography.text(context);
    final subtitleSize = EcoPlatesDesignTokens.typography.hint(context);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: modalMaxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Catégories prédéfinies
                  ...FoodCategory.values.map((category) {
                    final isSelected = category == currentCategory;

                    return ListTile(
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        size: EcoPlatesDesignTokens.size.icon(context),
                      ),
                      title: Text(
                        Categories.labelOf(category),
                        style: TextStyle(fontSize: titleSize),
                      ),
                      contentPadding: EcoPlatesDesignTokens.spacing
                          .contentPadding(context),
                      onTap: () {
                        ref
                            .read<OfferFormNotifier>(offerFormProvider.notifier)
                            .updateCategory(category);
                        Navigator.of(context).pop();
                      },
                    );
                  }),
                  // Séparateur
                  const Divider(),
                  // Option personnalisée
                  ListTile(
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                    title: Text(
                      'Catégorie personnalisée',
                      style: TextStyle(fontSize: titleSize),
                    ),
                    subtitle: Text(
                      'Définir votre propre catégorie',
                      style: TextStyle(fontSize: subtitleSize),
                    ),
                    contentPadding: EcoPlatesDesignTokens.spacing
                        .contentPadding(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _showCustomCategoryDialog(context, ref);
                    },
                  ),
                  // Espacement en bas
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.dialogGap(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getOfferTypeLabel(OfferType type) {
    return switch (type) {
      OfferType.panier => 'Panier surprise',
      OfferType.plat => 'Plat spécifique',
      OfferType.boulangerie => 'Boulangerie',
      OfferType.fruits => 'Fruits et légumes',
      OfferType.epicerie => 'Épicerie',
      OfferType.autre => 'Autre',
    };
  }

  String _getOfferTypeDescription(OfferType type) {
    return switch (type) {
      OfferType.panier => 'Panier avec différents produits surprise',
      OfferType.plat => 'Plat préparé spécifique',
      OfferType.boulangerie => 'Produits de boulangerie et pâtisserie',
      OfferType.fruits => 'Fruits, légumes et produits frais',
      OfferType.epicerie => 'Produits d"épicerie générale',
      OfferType.autre => "Autre type d'offre",
    };
  }
}
