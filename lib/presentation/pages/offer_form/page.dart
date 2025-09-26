import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/food_offer.dart';
import '../../providers/offer_form_provider.dart';
import 'widgets/offer_form_actions.dart';
import 'widgets/offer_form_fields.dart';
import 'widgets/offer_form_images.dart';
import 'widgets/offer_form_preferences.dart';
import 'widgets/offer_form_price_quantity.dart';
import 'widgets/offer_form_schedule.dart';

/// Widget amélioré pour les sections du formulaire avec icône et titre
class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
    this.isCompleted = false,
    this.isRequired = false,
    this.isCurrent = false,
    this.onSectionTap,
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
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primaryContainer.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent
                ? colorScheme.primary.withValues(alpha: 0.4)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: isCurrent ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCurrent
                    ? colorScheme.primary.withOpacity(0.1)
                    : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Icône avec statut
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isCompleted
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                              const SizedBox(width: 4),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Indicateur de statut
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
            // Contenu de la section
            Padding(padding: const EdgeInsets.all(16), child: child),
          ],
        ),
      ),
    );
  }
}

/// Indicateur de progression du formulaire
class _FormProgressIndicator extends StatelessWidget {
  const _FormProgressIndicator({required this.progress, required this.steps});

  final double progress;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Barre de progression
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Étapes
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = index < (progress * steps.length);
              final isCurrent = index == (progress * steps.length).floor();

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? colorScheme.primary
                              : isCurrent
                              ? colorScheme.primary.withValues(alpha: 0.5)
                              : colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isCompleted || isCurrent
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.normal,
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

/// Page unifiée pour créer ou modifier une offre alimentaire
///
/// Si [offer] est null, on est en mode création
/// Si [offer] est fourni, on est en mode édition
class OfferFormPage extends ConsumerStatefulWidget {
  const OfferFormPage({this.offer, super.key});

  final FoodOffer? offer;

  @override
  ConsumerState<OfferFormPage> createState() => _OfferFormPageState();
}

enum FormSection {
  images,
  basicInfo,
  priceQuantity,
  schedule,
  preferences,
  actions,
}

class _OfferFormPageState extends ConsumerState<OfferFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  FormSection _currentSection = FormSection.images;

  // Mode création ou édition
  bool get isEditMode => widget.offer != null;

  @override
  void initState() {
    super.initState();
    // Initialiser le formulaire avec les données existantes ou des valeurs par défaut
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEditMode) {
        ref.read(offerFormProvider.notifier).loadOffer(widget.offer!);
      } else {
        ref.read(offerFormProvider.notifier).resetForm();
      }
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final formState = ref.read(offerFormProvider);

      if (isEditMode) {
        // Mode édition : mettre à jour l'offre existante
        await ref
            .read(offerFormProvider.notifier)
            .updateOffer(widget.offer!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offre "${formState.title}" mise à jour'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Mode création : créer une nouvelle offre
        await ref.read(offerFormProvider.notifier).createOffer();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offre "${formState.title}" créée avec succès'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      if (mounted) {
        context.pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteOffer() async {
    if (!isEditMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer l'offre ?"),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${widget.offer!.title}" ?\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      try {
        await ref
            .read(offerFormProvider.notifier)
            .deleteOffer(widget.offer!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offre "${widget.offer!.title}" supprimée'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } on Exception catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la suppression : $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  /// Calcule la progression du formulaire (0.0 à 1.0)
  double _calculateProgress(OfferFormState state) {
    int completedFields = 0;
    int totalFields = 6; // Images, titre, description, type, catégorie, prix

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Modifier l'offre" : 'Nouvelle offre'),
        centerTitle: true,
        actions: [
          // Bouton de suppression seulement en mode édition
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteOffer,
              tooltip: 'Supprimer',
            ),
          // Bouton de validation
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Enregistrer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(offerFormProvider);
          final progress = _calculateProgress(formState);

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Indicateur de progression (seulement en mode création)
                  if (!isEditMode) ...[
                    _FormProgressIndicator(
                      progress: progress,
                      steps: const [
                        'Photo',
                        'Détails',
                        'Prix',
                        'Horaires',
                        'Préférences',
                      ],
                    ),
                  ],

                  // Infos système en mode édition
                  if (isEditMode) ...[
                    _buildSystemInfo(theme),
                    const SizedBox(height: 24),
                  ],

                  // Section Images
                  _FormSection(
                    icon: Icons.photo_camera,
                    title: "Photo de l'offre",
                    subtitle:
                        'Ajoutez une belle image pour attirer les clients',
                    isRequired: true,
                    isCompleted: formState.images.isNotEmpty,
                    isCurrent: _currentSection == FormSection.images,
                    onSectionTap: () =>
                        setState(() => _currentSection = FormSection.images),
                    child: const OfferFormImages(),
                  ),

                  // Section Informations de base
                  _FormSection(
                    icon: Icons.description,
                    title: 'Informations de base',
                    subtitle: "Titre, description et type d'offre",
                    isRequired: true,
                    isCompleted:
                        formState.title.trim().isNotEmpty &&
                        formState.description.trim().isNotEmpty &&
                        formState.type != OfferType.panier,
                    isCurrent: _currentSection == FormSection.basicInfo,
                    onSectionTap: () =>
                        setState(() => _currentSection = FormSection.basicInfo),
                    child: const OfferFormBasicFields(),
                  ),

                  // Section Prix et Quantité
                  _FormSection(
                    icon: Icons.euro,
                    title: 'Prix et Quantité',
                    subtitle: 'Définissez le tarif et le nombre disponible',
                    isRequired: true,
                    isCompleted:
                        formState.originalPrice > 0 && formState.quantity > 0,
                    isCurrent: _currentSection == FormSection.priceQuantity,
                    onSectionTap: () => setState(
                      () => _currentSection = FormSection.priceQuantity,
                    ),
                    child: const OfferFormPriceQuantityFields(),
                  ),

                  // Section Horaires de collecte
                  _FormSection(
                    icon: Icons.schedule,
                    title: 'Horaires de collecte',
                    subtitle:
                        'Quand les clients peuvent récupérer leur commande',
                    isRequired: true,
                    isCompleted:
                        formState.pickupStartTime != null &&
                        formState.pickupEndTime != null,
                    isCurrent: _currentSection == FormSection.schedule,
                    onSectionTap: () =>
                        setState(() => _currentSection = FormSection.schedule),
                    child: const OfferFormScheduleFields(),
                  ),

                  // Section Préférences alimentaires
                  _FormSection(
                    icon: Icons.restaurant_menu,
                    title: 'Préférences alimentaires',
                    subtitle: 'Informations sur les régimes et allergènes',
                    isCompleted:
                        formState.isVegetarian ||
                        formState.isVegan ||
                        formState.allergens.isNotEmpty,
                    isCurrent: _currentSection == FormSection.preferences,
                    onSectionTap: () => setState(
                      () => _currentSection = FormSection.preferences,
                    ),
                    child: const OfferFormPreferencesFields(),
                  ),

                  // Section Informations avancées
                  _FormSection(
                    icon: Icons.settings,
                    title: 'Paramètres avancés',
                    subtitle: 'Tags, statut et options supplémentaires',
                    isCompleted: formState.tags.isNotEmpty,
                    isCurrent: _currentSection == FormSection.actions,
                    onSectionTap: () =>
                        setState(() => _currentSection = FormSection.actions),
                    child: const OfferFormActions(),
                  ),

                  const SizedBox(
                    height: 100,
                  ), // Espace pour éviter le clavier + FAB
                ],
              ),
            ),
          );
        },
      ),

      // FAB pour sauvegarder rapidement (seulement en mode création)
      floatingActionButton: !isEditMode
          ? Consumer(
              builder: (context, ref, child) {
                final formState = ref.watch(offerFormProvider);
                final progress = _calculateProgress(formState);
                final canSave = progress > 0.5; // Au moins 50% complété

                return AnimatedScale(
                  scale: canSave ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton.extended(
                    onPressed: canSave && !_isSubmitting ? _submitForm : null,
                    backgroundColor: canSave
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    foregroundColor: canSave
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    icon: Icon(
                      _isSubmitting ? Icons.hourglass_empty : Icons.save,
                      size: 20,
                    ),
                    label: Text(
                      _isSubmitting
                          ? 'Sauvegarde...'
                          : 'Sauvegarder (${(progress * 100).round()}%)',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildSystemInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16),
              const SizedBox(width: 8),
              Text(
                'Informations système',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              Text(
                'ID: ${widget.offer!.id}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Créée: ${_formatDateTime(widget.offer!.createdAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Modifiée: ${_formatDateTime(widget.offer!.updatedAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
