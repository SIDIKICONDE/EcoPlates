import 'package:flutter/material.dart';
import '../../../../core/responsive/design_tokens.dart' hide Size;
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
          context.scaleXXS_XS_SM_MD, // Très réduit pour éviter overflow
          context.scaleXXS_XS_SM_MD / 2, // Très réduit pour éviter overflow
          context.scaleXXS_XS_SM_MD, // Très réduit pour éviter overflow
          context.scaleXXS_XS_SM_MD, // Très réduit pour éviter overflow
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ligne 1 : Nom de l'enseigne
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCompactMerchantName(theme, context)),
                  ],
                ),
                SizedBox(height: context.scaleXXS_XS_SM_MD / 8), // Très réduit
                // Ligne 2 : Description
                _buildCompactDescription(context),
                SizedBox(height: context.scaleXXS_XS_SM_MD / 4), // Très réduit
                // Ligne 3 : À récupérer + distance
                _buildCompactPickupWithDistance(context),
                SizedBox(height: context.scaleXXS_XS_SM_MD / 4), // Très réduit
                // Ligne de séparation en pointillés
                SizedBox(
                  height: EcoPlatesDesignTokens.layout.cardBorderWidth,
                  child: CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: _DottedLinePainter(color: _getLineColor()),
                  ),
                ),
                SizedBox(
                  height: context.scaleXXS_XS_SM_MD / 4,
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
        context.scaleMD_LG_XL_XXL,
        context.scaleXS_SM_MD_LG,
        context.scaleMD_LG_XL_XXL,
        context.scaleMD_LG_XL_XXL,
      ),
      child: Stack(
        children: [
          // Contenu principal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section nom du commerçant avec style distinctif
              _buildMerchantName(theme, context),
              SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

              // Section description du produit (tronquée si trop longue)
              _buildDescription(context),
              SizedBox(height: context.scaleXXS_XS_SM_MD),

              // Section date de récupération
              _buildPickupDate(context),
              SizedBox(height: context.scaleXXS_XS_SM_MD),

              // Ligne de séparation en pointillés (couleur selon fraîcheur)
              SizedBox(
                height: EcoPlatesDesignTokens.layout.cardBorderWidth,
                child: CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: _DottedLinePainter(color: _getLineColor()),
                ),
              ),
              SizedBox(height: context.scaleXS_SM_MD_LG),

              // Section prix
              _buildPriceOnly(theme, context),
            ],
          ),

          // Coeur flottant en haut à droite du contenu
          Positioned(
            top: 0,
            right: 0,
            child: _FloatingFavoriteButton(),
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
        fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
        color: theme.colorScheme.primary,
        fontWeight: EcoPlatesDesignTokens.typography.bold,
        height: EcoPlatesDesignTokens.layout.textLineHeight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit le widget pour afficher la description du produit
  /// Tronque automatiquement si la description dépasse 20 caractères
  /// Utilise une hauteur de ligne optimisée pour la lisibilité
  Widget _buildDescription(BuildContext context) {
    final truncatedDescription = offer.description.length > 20
        ? '${offer.description.substring(0, 20)}...'
        : offer.description;

    return Text(
      truncatedDescription,
      style: TextStyle(
        fontSize: EcoPlatesDesignTokens.typography.hint(context),
        color: Theme.of(context).colorScheme.onSurface.withValues(
          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
        ),
        height: EcoPlatesDesignTokens.layout.textLineHeight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Construit le widget pour afficher la date de récupération
  Widget _buildPickupDate(BuildContext context) {
    return Text(
      'Récupération: ${_formatPickupTime()}',
      style: TextStyle(
        fontSize: EcoPlatesDesignTokens.typography.hint(context),
        color: Theme.of(context).colorScheme.onSurface.withValues(
          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
        ),
        fontWeight: EcoPlatesDesignTokens.typography.medium,
        height: EcoPlatesDesignTokens.layout.textLineHeight,
      ),
    );
  }

  /// Construit le widget pour afficher le prix
  Widget _buildPriceOnly(ThemeData theme, BuildContext context) {
    return SizedBox(
      height: EcoPlatesDesignTokens
          .size
          .minTouchTarget, // Hauteur fixe pour éviter l'espace blanc
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!offer.isFree) ...[
            Text(
              '€${offer.originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
                decoration: TextDecoration.lineThrough,
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
                height: EcoPlatesDesignTokens.layout.textLineHeight,
              ),
            ),
            SizedBox(width: context.scaleXS_SM_MD_LG),
          ],
          Text(
            offer.priceText,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
              color: offer.isFree
                  ? EcoPlatesDesignTokens.colors.snackbarSuccess
                  : theme.colorScheme.primary,
              height: EcoPlatesDesignTokens.layout.textLineHeight,
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
      return EcoPlatesDesignTokens.colors.snackbarError.withValues(
        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
      );
    }
    // Moins de 6 heures = orange (bientôt)
    else if (timeUntilEnd.inHours < 6) {
      return EcoPlatesDesignTokens.colors.snackbarWarning.withValues(
        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
      );
    }
    // Plus de 6 heures = vert (frais)
    else {
      return EcoPlatesDesignTokens.colors.snackbarSuccess.withValues(
        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
      );
    }
  }

  /// Version compacte du nom du commerçant
  Widget _buildCompactMerchantName(ThemeData theme, BuildContext context) {
    return Text(
      offer.merchantName,
      style: TextStyle(
        fontSize: EcoPlatesDesignTokens.typography.text(
          context,
        ), // Réduit pour éviter overflow
        color: theme.colorScheme.primary,
        fontWeight: EcoPlatesDesignTokens.typography.semiBold,
        height: EcoPlatesDesignTokens.layout.textLineHeight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Version compacte du prix (avec prix barré)
  Widget _buildCompactPrice(ThemeData theme, BuildContext context) {
    return Row(
      children: [
        if (!offer.isFree) ...[
          Text(
            '€${offer.originalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              decoration: TextDecoration.lineThrough,
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
              height: EcoPlatesDesignTokens.layout.textLineHeight,
            ),
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
        ],
        Text(
          offer.priceText,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(
              context,
            ), // Réduit pour mode compact
            fontWeight: EcoPlatesDesignTokens.typography.bold,
            color: offer.isFree
                ? EcoPlatesDesignTokens.colors.snackbarSuccess
                : theme.colorScheme.primary,
            height: EcoPlatesDesignTokens.layout.textLineHeight,
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
        fontSize: EcoPlatesDesignTokens.typography.hint(context),
        color: Theme.of(context).colorScheme.onSurface.withValues(
          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
        ),
        height: EcoPlatesDesignTokens.layout.textLineHeight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Version compacte "À récupérer" avec distance et horaires
  Widget _buildCompactPickupWithDistance(BuildContext context) {
    final pickupText = _getSmartPickupText();
    final timeText = _formatPickupTime();
    final distanceText = distance != null
        ? ' • ${distance!.toStringAsFixed(1)}km'
        : '';

    return Text(
      '$pickupText • $timeText$distanceText',
      style: TextStyle(
        fontSize: EcoPlatesDesignTokens.typography.hint(context),
        color: Theme.of(context).colorScheme.onSurface.withValues(
          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
        ),
        height: EcoPlatesDesignTokens.layout.textLineHeight,
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
      duration: EcoPlatesDesignTokens.animation.normal,
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
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
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: EcoPlatesDesignTokens.animation.fast,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(_isFavorite),
              size:
                  EcoPlatesDesignTokens.size.modalIcon(context) *
                  EcoPlatesDesignTokens.size.largeIconMultiplier,
              color: _isFavorite
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter pour dessiner une ligne en pointillés
class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = EcoPlatesDesignTokens.layout.cardBorderWidth;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double startX = 0;

    // Dessiner les pointillés
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
