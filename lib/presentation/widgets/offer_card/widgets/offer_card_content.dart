import 'package:flutter/material.dart';
import '../../../../domain/entities/food_offer.dart';

/// Widget affichant le contenu textuel d'une carte d'offre
/// Inclut le nom du commerçant, la description, les horaires de récupération et le prix
/// Respecte les standards EcoPlates avec une mise en page optimisée
class OfferCardContent extends StatelessWidget {
  /// L'offre alimentaire à afficher
  final FoodOffer offer;

  /// Indique si la distance doit être affichée (non utilisé dans ce widget)
  final bool showDistance;

  /// Distance calculée depuis la position utilisateur (non utilisé dans ce widget)
  final double? distance;

  const OfferCardContent({
    super.key,
    required this.offer,
    required this.showDistance,
    this.distance,
  });

  /// Construit le widget avec la mise en page du contenu
  /// Utilise une colonne avec espacement optimisé pour l'UX
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section nom du commerçant avec style distinctif
          _buildMerchantName(theme),
          const SizedBox(height: 8),

          // Section description du produit (tronquée si trop longue)
          _buildDescription(),
          const SizedBox(height: 8),

          // Section horaires de récupération
          _buildPickupDate(),
          const SizedBox(height: 12),

          // Section prix avec réduction si applicable
          _buildPriceOnly(theme),
        ],
      ),
    );
  }

  /// Construit le widget pour afficher le nom du commerçant
  /// Utilise la couleur primaire du thème pour la visibilité
  /// Limite à une ligne avec ellipse si trop long
  Widget _buildMerchantName(ThemeData theme) {
    return Text(
      offer.merchantName,
      style: TextStyle(
        fontSize: 16,
        color: theme.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit le widget pour afficher la description du produit
  /// Tronque automatiquement si la description dépasse 20 caractères
  /// Utilise une hauteur de ligne optimisée pour la lisibilité
  Widget _buildDescription() {
    final truncatedDescription = offer.description.length > 20
        ? '${offer.description.substring(0, 20)}...'
        : offer.description;

    return Text(
      truncatedDescription,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        height: 1.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit le widget pour afficher les horaires de récupération
  /// Utilise un format standardisé pour les créneaux horaires
  /// Style discret pour ne pas distraire de l'information principale
  Widget _buildPickupDate() {
    return Text(
      'Récupération: ${_formatPickupTime()}',
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Construit le widget pour afficher les informations de prix
  /// Affiche le prix barré original + prix réduit, ou "Gratuit" si applicable
  /// Utilise la couleur verte pour les offres gratuites, couleur primaire sinon
  Widget _buildPriceOnly(ThemeData theme) {
    return Row(
      children: [
        if (!offer.isFree) ...[
          // Prix original barré pour montrer la réduction
          Text(
            '€${offer.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(width: 8),
        ],
        // Prix final (réduit ou gratuit)
        Text(
          offer.priceText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: offer.isFree ? const Color.fromARGB(255, 4, 8, 5) : theme.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Formate les horaires de récupération au format HH:MM - HH:MM
  /// Gère les erreurs en retournant un message par défaut si nécessaire
  /// Utilise le padding pour garantir un format uniforme (ex: 09:30 - 17:45)
  String _formatPickupTime() {
    try {
      final start = '${offer.pickupStartTime.hour.toString().padLeft(2, '0')}:${offer.pickupStartTime.minute.toString().padLeft(2, '0')}';
      final end = '${offer.pickupEndTime.hour.toString().padLeft(2, '0')}:${offer.pickupEndTime.minute.toString().padLeft(2, '0')}';
      return '$start - $end';
    } catch (e) {
      return 'Horaire à définir';
    }
  }

}
