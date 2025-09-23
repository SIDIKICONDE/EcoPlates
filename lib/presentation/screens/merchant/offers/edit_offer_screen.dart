import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/adaptive_widgets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/merchant/offers_management_provider.dart';
import '../../../widgets/create_offer_form.dart';

/// Écran d'édition d'une offre existante
class EditOfferScreen extends ConsumerStatefulWidget {
  final String offerId;

  const EditOfferScreen({super.key, required this.offerId});

  @override
  ConsumerState<EditOfferScreen> createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends ConsumerState<EditOfferScreen> {
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    final offerAsync = ref.watch(offerByIdProvider(widget.offerId));

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Modifier l\'offre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackPress,
        ),
        actions: [
          // Bouton de sauvegarde rapide
          IconButton(icon: const Icon(Icons.save), onPressed: _quickSave),
        ],
      ),
      body: offerAsync.when(
        data: (result) => result.fold(
          (failure) => _buildErrorState(failure.userMessage),
          (offer) => _buildEditForm(offer),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildEditForm(FoodOffer offer) {
    return CreateOfferForm(
      initialOffer: offer,
      isEditing: true,
      onSaved: (updatedOffer) {
        setState(() {
          _hasUnsavedChanges = false;
        });
        context.showSuccess('Offre mise à jour avec succès');
        context.pop();
      },
      onChanged: () {
        setState(() {
          _hasUnsavedChanges = true;
        });
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Erreur de chargement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(offerByIdProvider(widget.offerId));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  // Actions

  Future<void> _handleBackPress() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await context.showConfirmationDialog(
        title: 'Modifications non sauvegardées',
        message:
            'Vous avez des modifications non sauvegardées. Voulez-vous les abandonner ?',
        confirmText: 'Abandonner',
        cancelText: 'Continuer l\'édition',
        isDestructive: true,
      );

      if (shouldDiscard == true && mounted) {
        context.pop();
      }
    } else {
      if (mounted) {
        context.pop();
      }
    }
  }

  Future<void> _quickSave() async {
    // TODO: Implémenter la sauvegarde rapide
    context.showInfo('Sauvegarde rapide à implémenter');
  }
}
