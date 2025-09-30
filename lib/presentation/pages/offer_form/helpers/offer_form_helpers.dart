import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_form_provider.dart';

/// Helper pour les opérations métier du formulaire d'offre
class OfferFormHelpers {
  /// Calcule la progression du formulaire (0.0 à 1.0)
  static double calculateProgress(OfferFormState state) {
    var completedFields = 0;
    const totalFields = 6; // Images, titre, description, type, catégorie, prix

    // Images (requis)
    if (state.images.isNotEmpty) {
      completedFields++;
    }

    // Titre (requis)
    if (state.title.trim().isNotEmpty && state.title.trim().length >= 5) {
      completedFields++;
    }

    // Description (requis)
    if (state.description.trim().isNotEmpty &&
        state.description.trim().length >= 20) {
      completedFields++;
    }

    // Type (requis)
    if (state.type != OfferType.panier) {
      completedFields++; // Changé du défaut
    }

    // Catégorie (requis)
    if (state.category != FoodCategory.dejeuner) {
      completedFields++; // Changé du défaut
    }

    // Prix (requis)
    if (state.originalPrice > 0) {
      completedFields++;
    }

    return completedFields / totalFields;
  }

  /// Soumet le formulaire (création ou mise à jour)
  static Future<void> submitForm({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required WidgetRef ref,
    required bool isEditMode,
    required FoodOffer? offer,
    required void Function(bool) setSubmitting,
  }) async {
    if (!formKey.currentState!.validate()) return;

    setSubmitting(true);

    try {
      final formState = ref.read(offerFormProvider);

      if (isEditMode) {
        // Mode édition : mettre à jour l'offre existante
        await ref.read(offerFormProvider.notifier).updateOffer(offer!.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offre "${formState.title}" mise à jour'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          );
        }
      } else {
        // Mode création : créer une nouvelle offre
        await ref.read(offerFormProvider.notifier).createOffer();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offre "${formState.title}" créée avec succès'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          );
        }
      }

      if (context.mounted) {
        context.pop();
      }
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setSubmitting(false);
      }
    }
  }

  /// Supprime une offre
  static Future<void> deleteOffer({
    required BuildContext context,
    required WidgetRef ref,
    required FoodOffer offer,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Supprimer l'offre",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer l\'offre "${offer.title}" ?\n\nCette action est irréversible.',
          style: TextStyle(
            fontSize: 16.0,
            height: 1.5,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red.shade700,
            ),
            child: Text(
              'Supprimer',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(offerFormProvider.notifier).deleteOffer(offer.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offre "${offer.title}" supprimée'),
              backgroundColor: Colors.orange.shade700,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          );
          context.pop();
        }
      } on Exception catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la suppression : $e'),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
          );
        }
      }
    }
  }
}
