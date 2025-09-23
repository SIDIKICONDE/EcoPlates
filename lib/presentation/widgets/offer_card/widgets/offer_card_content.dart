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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section nom du commerçant avec style distinctif
          _buildMerchantName(theme),
          const SizedBox(height: 2),

          // Section description du produit (tronquée si trop longue)
          _buildDescription(),
          const SizedBox(height: 4),

          // Section date de récupération
          _buildPickupDate(),
          const SizedBox(height: 6),
          
          // Ligne de séparation en pointillés
          SizedBox(
            height: 0.5,
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DottedLinePainter(),
            ),
          ),
          const SizedBox(height: 6),
          
          // Section prix
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
        fontSize: 14,
        color: theme.primaryColor,
        fontWeight: FontWeight.w600,
        height: 1.0,
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
        height: 1.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }


  /// Construit le widget pour afficher la date de récupération
  Widget _buildPickupDate() {
    return Text(
      'Récupération: ${_formatPickupTime()}',
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
    );
  }

  /// Construit le widget pour afficher le prix
  Widget _buildPriceOnly(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!offer.isFree) ...[
          Text(
            '€${offer.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[500],
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          offer.priceText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: offer.isFree ? Colors.green : theme.primaryColor,
            height: 1.0,
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

/// Painter pour dessiner une ligne en pointillés
class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double startX = 0;
    
    // Dessiner les pointillés
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
