import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';
import '../offer_card/offer_card_configs.dart';

/// Widget pour basculer le statut d'un article (actif/inactif)
///
/// Utilise des widgets adaptatifs selon la plateforme (Material/Cupertino).
/// Met à jour le statut via le provider avec gestion d'erreur.
class StockStatusToggle extends ConsumerStatefulWidget {
  const StockStatusToggle({
    required this.item,
    super.key,
    this.showLabel = true,
    this.compactMode = false,
    this.showLoading = false,
    this.animate = false,
  });

  /// Article dont on modifie le statut
  final StockItem item;

  /// Affiche le label du statut
  final bool showLabel;

  /// Mode compact (plus petit)
  final bool compactMode;

  /// Afficher un indicateur de chargement pendant le toggle
  final bool showLoading;

  /// Activer les animations visuelles (label, conteneur) du toggle
  final bool animate;

  @override
  ConsumerState<StockStatusToggle> createState() => _StockStatusToggleState();
}

class _StockStatusToggleState extends ConsumerState<StockStatusToggle> {
  bool _isToggling = false;

  /// Bascule le statut avec gestion d'erreur et timeout de sécurité
  Future<void> _toggleStatus() async {
    if (_isToggling) return;

    setState(() {
      _isToggling = true;
    });

    try {
      // Timeout de sécurité de 1 seconde maximum
      await ref
          .read(stockItemsProvider.notifier)
          .toggleStatus(widget.item.id)
          .timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              throw Exception(
                "Délai d'attente dépassé pour le changement de statut",
              );
            },
          );
    } on Exception catch (error) {
      if (mounted) {
        // Affiche un snackbar en cas d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StockErrorMessages.getErrorMessage(error)),
            backgroundColor: DeepColorTokens.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      // Garantit que le flag se remet toujours à false
      if (mounted) {
        setState(() {
          _isToggling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.item.status == StockItemStatus.active;

    if (widget.compactMode) {
      return _buildCompactToggle(context, isActive);
    } else {
      return _buildStandardToggle(context, isActive);
    }
  }

  Widget _buildStandardToggle(
    BuildContext context,
    bool isActive,
  ) {
    if (!widget.showLabel) {
      return _buildSwitchOnly(context, isActive);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusLabel(context, isActive),
        SizedBox(width: ResponsiveUtils.getHorizontalSpacing(context) / 2),
        _buildSwitchOnly(context, isActive),
      ],
    );
  }

  Widget _buildCompactToggle(
    BuildContext context,
    bool isActive,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSwitchOnly(context, isActive, compact: true),
        if (widget.showLabel) ...[
          SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) / 4),
          _buildStatusLabel(context, isActive, compact: true),
        ],
      ],
    );
  }

  Widget _buildSwitchOnly(
    BuildContext context,
    bool isActive, {
    bool compact = false,
  }) {
    if (_isToggling) {
      if (widget.showLoading) {
        final iconSize = ResponsiveUtils.getIconSize(context, baseSize: 16.0);
        return SizedBox(
          width: compact ? iconSize : iconSize * 1.25,
          height: compact ? iconSize : iconSize * 1.25,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: DeepColorTokens.primary,
          ),
        );
      } else {
        // Afficher le switch désactivé sans animation
        return Transform.scale(
          scale: compact ? 0.8 : 1.0,
          child: AdaptiveSwitch(
            value: isActive,
            onChanged: null,
            activeColor: DeepColorTokens.primary,
          ),
        );
      }
    }

    final switchWidget = Transform.scale(
      scale: compact ? 0.8 : 1.0,
      child: AdaptiveSwitch(
        value: isActive,
        onChanged: _isToggling ? null : (_) => _toggleStatus(),
        activeColor: DeepColorTokens.primary,
      ),
    );

    if (widget.animate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: switchWidget,
      );
    } else {
      return switchWidget;
    }
  }

  Widget _buildStatusLabel(
    BuildContext context,
    bool isActive, {
    bool compact = false,
  }) {
    const config = OfferCardConfigs.defaultConfig;
    final labelPadding = EdgeInsets.symmetric(
      horizontal: compact
          ? ResponsiveUtils.getHorizontalSpacing(context) / 2
          : ResponsiveUtils.getHorizontalSpacing(context) * 0.75,
      vertical: compact
          ? ResponsiveUtils.getVerticalSpacing(context) / 8
          : ResponsiveUtils.getVerticalSpacing(context) / 4,
    );

    final labelContainer = Container(
      padding: labelPadding,
      decoration: BoxDecoration(
        color: isActive
            ? DeepColorTokens.primaryContainer.withValues(
                alpha: 0.1,
              )
            : DeepColorTokens.neutral300.withValues(
                alpha: 0.2,
              ),
        borderRadius:
            config.imageBorderRadius ??
            BorderRadius.circular(
              compact
                  ? ResponsiveUtils.getVerticalSpacing(context)
                  : ResponsiveUtils.getVerticalSpacing(context) * 1.25,
            ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: compact
                ? ResponsiveUtils.getHorizontalSpacing(context) / 4
                : ResponsiveUtils.getHorizontalSpacing(context) / 2,
          ),
          Text(
            widget.item.status.label,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
              fontWeight: FontWeight.w500,
              color: isActive
                  ? DeepColorTokens.neutral0
                  : DeepColorTokens.neutral600,
            ),
          ),
        ],
      ),
    );

    if (widget.animate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: labelContainer,
      );
    } else {
      return labelContainer;
    }
  }
}
