import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/categories.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_form_provider.dart';

/// Section des champs de base du formulaire d'offre
class OfferFormBasicFields extends ConsumerWidget {
  const OfferFormBasicFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        TextFormField(
          initialValue: formState.title,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: "Titre de l'offre *",
            hintText: 'Ex: Panier surprise déjeuner',
            prefixIcon: Icon(Icons.title),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le titre est requis';
            }
            if (value.trim().length < 5) {
              return 'Au moins 5 caractères';
            }
            if (value.trim().length > 100) {
              return 'Maximum 100 caractères';
            }
            return null;
          },
          onChanged: (value) {
            ref.read(offerFormProvider.notifier).updateTitle(value);
          },
        ),

        const SizedBox(height: 16),

        // Description
        TextFormField(
          initialValue: formState.description,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Description *',
            hintText:
                'Décrivez votre offre (ingrédients, quantité, particularités...)',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La description est requise';
            }
            if (value.trim().length < 20) {
              return 'Au moins 20 caractères';
            }
            return null;
          },
          onChanged: (value) {
            ref.read(offerFormProvider.notifier).updateDescription(value);
          },
        ),

        const SizedBox(height: 16),

        // Type d'offre
        InkWell(
          onTap: () => _showOfferTypeModal(context, ref, formState.type),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Type d\'offre *',
              prefixIcon: Icon(Icons.restaurant_menu),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              formState.customType ?? _getOfferTypeLabel(formState.type),
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Catégorie alimentaire
        InkWell(
          onTap: () => _showFoodCategoryModal(context, ref, formState.category),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Catégorie alimentaire *',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              formState.customCategory ??
                  Categories.labelOf(formState.category),
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      ],
    );
  }

  void _showOfferTypeModal(
    BuildContext context,
    WidgetRef ref,
    OfferType currentType,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      ),
                      title: Text(_getOfferTypeLabel(type)),
                      subtitle: Text(_getOfferTypeDescription(type)),
                      onTap: () {
                        ref.read(offerFormProvider.notifier).updateType(type);
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
                    ),
                    title: const Text('Type personnalisé'),
                    subtitle: const Text('Définir votre propre type d\'offre'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showCustomTypeDialog(context, ref);
                    },
                  ),
                  // Espacement en bas
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCustomTypeDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Type d\'offre personnalisé'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Entrez le nom de votre type d\'offre personnalisé :',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Type d\'offre',
                  hintText: 'Ex: Menu spécial, Box déjeuner...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    // Pour l'instant, on utilise le type "autre" mais on stocke le nom personnalisé
                    ref
                        .read(offerFormProvider.notifier)
                        .updateType(OfferType.autre);
                    ref
                        .read(offerFormProvider.notifier)
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
                      .read(offerFormProvider.notifier)
                      .updateType(OfferType.autre);
                  ref
                      .read(offerFormProvider.notifier)
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

  void _showCustomCategoryDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Catégorie alimentaire personnalisée'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Entrez le nom de votre catégorie alimentaire personnalisée :',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Catégorie alimentaire',
                  hintText: 'Ex: Produits bio, Sans gluten...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    // Pour l'instant, on utilise la catégorie "autre" mais on stocke le nom personnalisé
                    ref
                        .read(offerFormProvider.notifier)
                        .updateCategory(FoodCategory.autre);
                    ref
                        .read(offerFormProvider.notifier)
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
                      .read(offerFormProvider.notifier)
                      .updateCategory(FoodCategory.autre);
                  ref
                      .read(offerFormProvider.notifier)
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

  void _showFoodCategoryModal(
    BuildContext context,
    WidgetRef ref,
    FoodCategory currentCategory,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      ),
                      title: Text(Categories.labelOf(category)),
                      onTap: () {
                        ref
                            .read(offerFormProvider.notifier)
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
                    ),
                    title: const Text('Catégorie personnalisée'),
                    subtitle: const Text('Définir votre propre catégorie'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showCustomCategoryDialog(context, ref);
                    },
                  ),
                  // Espacement en bas
                  const SizedBox(height: 16),
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
      OfferType.epicerie => 'Produits d\'épicerie générale',
      OfferType.autre => 'Autre type d\'offre',
    };
  }
}
