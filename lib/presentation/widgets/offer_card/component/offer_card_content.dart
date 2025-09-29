import 'package:flutter/material.dart';
import '../../../../domain/entities/food_offer.dart';

/// Widget affichant le contenu textuel d'une carte d'offre
/// Inclut le nom du commerçant, la description, les horaires de récupération et le prix
/// Respecte les standards EcoPlates avec une mise en page optimisée
class OfferCardContent extends StatelessWidget {
  const OfferCardContent({
    required this.offer,
    required this.showDistance,
    super.key,
    this.distance,
    this.compact = false,
  });

  /// L'offre alimentaire à afficher
  final FoodOffer offer;

  /// Indique si la distance doit être affichée (non utilisé dans ce widget)
  final bool showDistance;

  /// Distance calculée depuis la position utilisateur (non utilisé dans ce widget)
  final double? distance;

  /// Mode compact pour réduire l'espacement
  final bool compact;

  /// Construit le widget avec la mise en page du contenu
  /// Utilise une colonne avec espacement optimisé pour l'UX
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      // Version compacte avec tous les éléments demandés
      return Padding(
        padding: EdgeInsets.fromLTRB(
          8.0, // Très réduit pour éviter overflow
          4.0, // Très réduit pour éviter overflow
          8.0, // Très réduit pour éviter overflow
          8.0, // Très réduit pour éviter overflow
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ligne 1 : Nom de l'enseigne
                Row(
                  children: [
                    Expanded(child: _buildCompactMerchantName(theme, context)),
                  ],
                ),
                SizedBox(height: 1.0), // Très réduit
                // Ligne 2 : Description
                _buildCompactDescription(context),
                SizedBox(height: 2.0), // Très réduit
                // Ligne 3 : À récupérer + distance
                _buildCompactPickupWithDistance(context),
                SizedBox(height: 2.0), // Très réduit
                // Ligne de séparation en pointillés
                SizedBox(
                  height: 16.0,
                  child: CustomPaint(
                    painter: _DottedLinePainter(color: _getLineColor()),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ), // Très réduit pour mode compact
                // Ligne 4 : Prix aligné à droite
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildCompactPrice(theme, context)],
                ),
              ],
            ),

            // Coeur flottant en haut à droite (mode compact)
            Positioned(
              top: 0,
              right: 0,
              child: _FloatingFavoriteButton(
                initialIsFavorite: offer.isFavorite,
              ),
            ),
          ],
        ),
      );
    }

    // Version normale (inchangée)
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0,
        12.0,
        16.0,
        16.0,
      ),
      child: Stack(
        children: [
          // Contenu principal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section nom du commerçant avec style distinctif
              _buildMerchantName(theme, context),
              SizedBox(height: 4.0),

              // Section description du produit (tronquée si trop longue)
              _buildDescription(context),
              SizedBox(height: 8.0),

              // Section date de récupération
              _buildPickupDate(context),
              SizedBox(height: 8.0),

              // Ligne de séparation en pointillés (couleur selon fraîcheur)
              SizedBox(
                height: 16.0,
                child: CustomPaint(
                  painter: _DottedLinePainter(color: _getLineColor()),
                ),
              ),
              SizedBox(height: 12.0),

              // Section prix
              _buildPriceOnly(theme, context),
            ],
          ),

          // Coeur flottant en haut à droite du contenu
          Positioned(
            top: 0,
            right: 0,
            child: _FloatingFavoriteButton(
              initialIsFavorite: offer.isFavorite,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le widget pour afficher le nom du commerçant
  /// Utilise la couleur primaire du thème pour la visibilité
  /// Limite à une ligne avec ellipse si trop long
  Widget _buildMerchantName(ThemeData theme, BuildContext context) {
    return Text(
      offer.merchantName,
      style: TextStyle(
        fontSize: 16.0,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit le widget pour la description du produit
  /// Tronque le texte si trop long pour éviter l'overflow
  Widget _buildDescription(BuildContext context) {
    final truncatedDescription = offer.description.length > 20
        ? '${offer.description.substring(0, 20)}...'
        : offer.description;

    return Text(
      truncatedDescription,
      style: TextStyle(
        fontSize: 14.0,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit le widget pour la date de récupération
  Widget _buildPickupDate(BuildContext context) {
    return Text(
      'Récupération: ${_formatPickupTime()}',
      style: TextStyle(
        fontSize: 12.0,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }

  /// Construit le widget pour afficher uniquement le prix
  Widget _buildPriceOnly(ThemeData theme, BuildContext context) {
    return SizedBox(
      height: 44.0, // Hauteur fixe pour éviter l'espace blanc
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!offer.isFree) ...[
            Text(
              '€${offer.originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.0,
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(width: 8.0),
          ],
          Text(
            offer.priceText,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Formate l'heure de récupération
  String _formatPickupTime() {
    try {
      final start =
          '${offer.pickupStartTime.hour.toString().padLeft(2, '0')}:${offer.pickupStartTime.minute.toString().padLeft(2, '0')}';
      final end =
          '${offer.pickupEndTime.hour.toString().padLeft(2, '0')}:${offer.pickupEndTime.minute.toString().padLeft(2, '0')}';
      return '$start - $end';
    } on Exception catch (_) {
      return 'Horaire à définir';
    }
  }

  /// Détermine la couleur de la ligne selon l'urgence de l'offre
  Color _getLineColor() {
    final now = DateTime.now();
    final timeUntilEnd = offer.pickupEndTime.difference(now);

    // Moins de 2 heures = rouge (urgent)
    if (timeUntilEnd.inHours < 2) {
      return Colors.red;
    }
    // Moins de 6 heures = orange (bientôt)
    else if (timeUntilEnd.inHours < 6) {
      return Colors.orange;
    }
    // Plus de 6 heures = vert (frais)
    else {
      return Colors.green;
    }
  }

  /// Version compacte du nom du commerçant
  Widget _buildCompactMerchantName(ThemeData theme, BuildContext context) {
    return Text(
      offer.merchantName,
      style: TextStyle(
        fontSize: 14.0, // Réduit pour éviter overflow
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Version compacte du prix
  Widget _buildCompactPrice(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        if (!offer.isFree) ...[
          Text(
            '€${offer.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12.0,
              decoration: TextDecoration.lineThrough,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(width: 4.0),
        ],
        Text(
          offer.priceText,
          style: TextStyle(
            fontSize: 14.0, // Réduit pour mode compact
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// Version compacte de la description
  Widget _buildCompactDescription(BuildContext context) {
    final truncatedDescription = offer.description.length > 35
        ? '${offer.description.substring(0, 35)}...'
        : offer.description;

    return Text(
      truncatedDescription,
      style: TextStyle(
        fontSize: 12.0,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Version compacte pour pickup avec distance
  Widget _buildCompactPickupWithDistance(BuildContext context) {
    final pickupText = _getSmartPickupText();
    final timeText = _formatPickupTime();
    final distanceText = distance != null
        ? ' • ${distance!.toStringAsFixed(1)}km'
        : '';

    return Text(
      '$pickupText • $timeText$distanceText',
      style: TextStyle(
        fontSize: 10.0,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Génère un texte intelligent pour la récupération
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
      final weekdays = [
        'lundi',
        'mardi',
        'mercredi',
        'jeudi',
        'vendredi',
        'samedi',
        'dimanche',
      ];
      final weekday = weekdays[startTime.weekday - 1];
      return 'À récupérer $weekday';
    }
    // Plus loin dans le futur
    else {
      return 'À récupérer le ${startTime.day}/${startTime.month}';
    }
  }

  /// Coeur intégré retiré (remplacé par bouton flottant sur l'image)
}

/// Bouton favori flottant réutilisable
class _FloatingFavoriteButton extends StatefulWidget {
  const _FloatingFavoriteButton({this.initialIsFavorite = false});
  final bool initialIsFavorite;

  @override
  State<_FloatingFavoriteButton> createState() =>
      _FloatingFavoriteButtonState();
}

class _FloatingFavoriteButtonState extends State<_FloatingFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    try {
      await _controller.forward();
      await _controller.reverse();
    } on Exception {
      // Ignore animation errors
    }
    if (!mounted) return;
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(_isFavorite),
              size: 24.0,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter pour dessiner les lignes en pointillés
class _DottedLinePainter extends CustomPainter {
  const _DottedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
