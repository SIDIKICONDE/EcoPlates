import 'package:flutter/material.dart';

import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_form_provider.dart';
import '../widgets/offer_form_actions.dart';
import '../widgets/offer_form_fields.dart';
import '../widgets/offer_form_images.dart';
import '../widgets/offer_form_preferences.dart';
import '../widgets/offer_form_price_quantity.dart';
import '../widgets/offer_form_schedule.dart';

/// Configuration d'une section du formulaire
class FormSectionConfig {
  const FormSectionConfig({
    required this.section,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.isRequired,
    required this.isCompleted,
  });

  final FormSection section;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final bool isRequired;
  final bool Function(OfferFormState) isCompleted;
}

/// Helper pour créer la liste des sections du formulaire
class FormSectionsBuilder {
  static List<FormSectionConfig> buildSections(
    OfferFormState formState,
    FormSection currentSection,
    void Function(FormSection) onSectionChanged,
  ) {
    return [
      FormSectionConfig(
        section: FormSection.images,
        icon: Icons.photo_camera,
        title: "Photo de l'offre",
        subtitle: 'Ajoutez une belle image pour attirer les clients',
        child: const OfferFormImages(),
        isRequired: true,
        isCompleted: (state) => state.images.isNotEmpty,
      ),
      FormSectionConfig(
        section: FormSection.basicInfo,
        icon: Icons.description,
        title: 'Informations de base',
        subtitle: "Titre, description et type d'offre",
        child: const OfferFormBasicFields(),
        isRequired: true,
        isCompleted: (state) =>
            state.title.trim().isNotEmpty &&
            state.description.trim().isNotEmpty &&
            state.type != OfferType.panier,
      ),
      FormSectionConfig(
        section: FormSection.priceQuantity,
        icon: Icons.euro,
        title: 'Prix et Quantité',
        subtitle: 'Définissez le tarif et le nombre disponible',
        child: const OfferFormPriceQuantityFields(),
        isRequired: true,
        isCompleted: (state) => state.originalPrice > 0 && state.quantity > 0,
      ),
      FormSectionConfig(
        section: FormSection.schedule,
        icon: Icons.schedule,
        title: 'Horaires de collecte',
        subtitle: 'Quand les clients peuvent récupérer leur commande',
        child: const OfferFormScheduleFields(),
        isRequired: true,
        isCompleted: (state) =>
            state.pickupStartTime != null && state.pickupEndTime != null,
      ),
      FormSectionConfig(
        section: FormSection.preferences,
        icon: Icons.restaurant_menu,
        title: 'Préférences alimentaires',
        subtitle: 'Informations sur les régimes et allergènes',
        child: const OfferFormPreferencesFields(),
        isRequired: false,
        isCompleted: (state) =>
            state.isVegetarian || state.isVegan || state.allergens.isNotEmpty,
      ),
      FormSectionConfig(
        section: FormSection.actions,
        icon: Icons.settings,
        title: 'Paramètres avancés',
        subtitle: 'Tags, statut et options supplémentaires',
        child: const OfferFormActions(),
        isRequired: false,
        isCompleted: (state) => state.tags.isNotEmpty,
      ),
    ];
  }
}

enum FormSection {
  images,
  basicInfo,
  priceQuantity,
  schedule,
  preferences,
  actions,
}
