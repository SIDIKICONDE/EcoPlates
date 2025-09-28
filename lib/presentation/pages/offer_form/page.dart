import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/offer_form_provider.dart';
import 'helpers/form_section_config.dart' as config;
import 'helpers/offer_form_helpers.dart';
import 'helpers/ui_helpers.dart';
import 'widgets/form_progress_indicator.dart';
import 'widgets/form_section.dart' as widgets;

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

class _OfferFormPageState extends ConsumerState<OfferFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  config.FormSection _currentSection = config.FormSection.images;

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
    await OfferFormHelpers.submitForm(
      context: context,
      formKey: _formKey,
      ref: ref,
      isEditMode: isEditMode,
      offer: widget.offer,
      setSubmitting: (value) => setState(() => _isSubmitting = value),
    );
  }

  Future<void> _deleteOffer() async {
    if (!isEditMode) return;

    await OfferFormHelpers.deleteOffer(
      context: context,
      ref: ref,
      offer: widget.offer!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? l10n.offerFormPageEditOffer : l10n.offerFormPageNewOffer,
        ),
        centerTitle: true,
        actions: [
          // Bouton de suppression seulement en mode édition
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteOffer,
              tooltip: l10n.offerFormPageDelete,
            ),
          // Bouton de validation
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? SizedBox(
                    width: EcoPlatesDesignTokens.size.icon(context),
                    height: EcoPlatesDesignTokens.size.icon(context),
                    child: CircularProgressIndicator(
                      strokeWidth: EcoPlatesDesignTokens.layout
                          .buttonBorderWidth(context),
                    ),
                  )
                : Text(
                    l10n.offerFormPageSave,
                    style: TextStyle(
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                    ),
                  ),
          ),
          SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final formState = ref.watch(offerFormProvider);
          final progress = OfferFormHelpers.calculateProgress(formState);
          final sections = config.FormSectionsBuilder.buildSections(
            formState,
            _currentSection,
            (section) => setState(() => _currentSection = section),
          );

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Indicateur de progression (seulement en mode création)
                  if (!isEditMode) ...[
                    FormProgressIndicator(
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
                    OfferFormUiHelpers.buildSystemInfo(
                      context,
                      theme,
                      widget.offer!,
                    ),
                    SizedBox(
                      height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                        context,
                      ),
                    ),
                  ],

                  // Sections du formulaire
                  ...sections.map(
                    (sectionConfig) => widgets.FormSection(
                      icon: sectionConfig.icon,
                      title: sectionConfig.title,
                      subtitle: sectionConfig.subtitle,
                      isRequired: sectionConfig.isRequired,
                      isCompleted: sectionConfig.isCompleted(formState),
                      isCurrent: _currentSection == sectionConfig.section,
                      onSectionTap: () => setState(
                        () => _currentSection = sectionConfig.section,
                      ),
                      child: sectionConfig.child,
                    ),
                  ),

                  SizedBox(
                    height:
                        EcoPlatesDesignTokens.spacing.sectionSpacing(context) *
                        3,
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
                final progress = OfferFormHelpers.calculateProgress(formState);
                final canSave = progress > 0.5; // Au moins 50% complété

                return AnimatedScale(
                  scale: canSave ? EcoPlatesDesignTokens.opacity.overlay : 0.8,
                  duration: const Duration(milliseconds: 250),
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
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                    label: Text(
                      _isSubmitting
                          ? l10n.offerFormPageSaving
                          : 'Sauvegarder (${(progress * 100).round()}%)',
                      style: TextStyle(
                        fontWeight: EcoPlatesDesignTokens.typography.semiBold,
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
