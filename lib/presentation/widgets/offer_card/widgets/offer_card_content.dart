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

  /// Mode compact pour réduire l'espacement
  final bool compact;

  const OfferCardContent({
    super.key,
    required this.offer,
    required this.showDistance,
    this.distance,
    this.compact = false,
  });

  /// Construit le widget avec la mise en page du contenu
  /// Utilise une colonne avec espacement optimisé pour l'UX
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      // Version compacte avec tous les éléments demandés
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ligne 1 : Nom de l'enseigne + coeur favoris
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildCompactMerchantName(theme),
                ),
                _buildFavoriteButton(),
              ],
            ),
            const SizedBox(height: 3),
            
            // Ligne 2 : Description
            _buildCompactDescription(),
            const SizedBox(height: 4),
            
            // Ligne 3 : À récupérer + distance
            _buildCompactPickupWithDistance(),
            const SizedBox(height: 6),
            
            // Ligne de séparation en pointillés
            SizedBox(
              height: 1,
              child: CustomPaint(
                size: const Size(double.infinity, 1),
                painter: _DottedLinePainter(color: _getLineColor()),
              ),
            ),
            const SizedBox(height: 6),
            
            // Ligne 4 : Prix aligné à droite
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCompactPrice(theme),
              ],
            ),
          ],
        ),
      );
    }
    
    // Version normale (inchangée)
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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

          // Ligne de séparation en pointillés (couleur selon fraîcheur)
          SizedBox(
            height: 1,
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DottedLinePainter(color: _getLineColor()),
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
        height: 1.1,
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
        fontSize: 12,
        color: Colors.grey[600],
        height: 1,
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
    return SizedBox(
      height: 24, // Hauteur fixe pour éviter l'espace blanc
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
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
  
  /// Détermine la couleur de la ligne selon l'urgence de l'offre
  Color _getLineColor() {
    final now = DateTime.now();
    final timeUntilEnd = offer.pickupEndTime.difference(now);
    
    // Moins de 2 heures = rouge (urgent)
    if (timeUntilEnd.inHours < 2) {
      return Colors.red.withValues(alpha: 0.5);
    }
    // Moins de 6 heures = orange (bientôt)
    else if (timeUntilEnd.inHours < 6) {
      return Colors.orange.withValues(alpha: 0.5);
    }
    // Plus de 6 heures = vert (frais)
    else {
      return Colors.green.withValues(alpha: 0.5);
    }
  }
  
  /// Version compacte du nom du commerçant
  Widget _buildCompactMerchantName(ThemeData theme) {
    return Text(
      offer.merchantName,
      style: TextStyle(
        fontSize: 13,
        color: theme.primaryColor,
        fontWeight: FontWeight.w600,
        height: 1.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// Version compacte du prix (avec prix barré)
  Widget _buildCompactPrice(ThemeData theme) {
    return Row(
      children: [
        if (!offer.isFree) ...[
          Text(
            '€${offer.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 11,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey[500],
              height: 1.0,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          offer.priceText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: offer.isFree ? Colors.green : theme.primaryColor,
            height: 1.0,
          ),
        ),
      ],
    );
  }
  
  /// Version compacte de la description
  Widget _buildCompactDescription() {
    final truncatedDescription = offer.description.length > 35
        ? '${offer.description.substring(0, 35)}...'
        : offer.description;
    
    return Text(
      truncatedDescription,
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey[600],
        height: 1.1,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// Version compacte "À récupérer" avec distance et horaires
  Widget _buildCompactPickupWithDistance() {
    final pickupText = _getSmartPickupText();
    final timeText = _formatPickupTime();
    final distanceText = distance != null 
        ? ' • ${distance!.toStringAsFixed(1)}km'
        : '';
        
    return Text(
      '$pickupText • $timeText$distanceText',
      style: TextStyle(
        fontSize: 10,
        color: Colors.grey[500],
        height: 1.0,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// Génère un texte intelligent selon l'horaire de récupération
  String _getSmartPickupText() {
    final now = DateTime.now();
    final startTime = offer.pickupStartTime;
    final endTime = offer.pickupEndTime;
    
    // Si la récupération est déjà passée
    if (endTime.isBefore(now)) {
      return 'Éxpirée';
    }
    
    // Si la récupération a déjà commencé
    if (startTime.isBefore(now) && endTime.isAfter(now)) {
      final remainingHours = endTime.difference(now).inHours;
      if (remainingHours < 1) {
        return 'Dernière chance';
      } else {
        return 'Disponible maintenant';
      }
    }
    
    // Déterminer si c'est aujourd'hui, demain, etc.
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(startTime.year, startTime.month, startTime.day);
    final daysDifference = startDay.difference(today).inDays;
    
    // Aujourd'hui
    if (daysDifference == 0) {
      if (startTime.hour < 12) {
        return 'À récupérer ce matin';
      } else if (startTime.hour < 18) {
        return 'À récupérer cet après-midi';
      } else {
        return 'À récupérer ce soir';
      }
    }
    // Demain
    else if (daysDifference == 1) {
      if (startTime.hour < 12) {
        return 'À récupérer demain matin';
      } else if (startTime.hour < 18) {
        return 'À récupérer demain après-midi';
      } else {
        return 'À récupérer demain soir';
      }
    }
    // Dans plusieurs jours
    else if (daysDifference <= 7) {
      final weekdays = ['lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'];
      final weekday = weekdays[startTime.weekday - 1];
      return 'À récupérer $weekday';
    }
    // Plus loin dans le futur
    else {
      return 'À récupérer le ${startTime.day}/${startTime.month}';
    }
  }
  
  /// Bouton coeur pour les favoris avec animation
  Widget _buildFavoriteButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return GestureDetector(
          onTapDown: (_) => {},
          onTapUp: (_) => {},
          onTap: () {
            // TODO: Implémenter la logique des favoris
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.favorite_border,
                size: 16,
                color: Colors.grey[400],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Painter pour dessiner une ligne en pointillés
class _DottedLinePainter extends CustomPainter {
  final Color color;
  
  _DottedLinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

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
