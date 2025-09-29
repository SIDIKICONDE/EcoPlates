import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/adaptive_widgets.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';

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
            backgroundColor: Theme.of(context).colorScheme.error,
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
    final theme = Theme.of(context);
    final isActive = widget.item.status == StockItemStatus.active;

    if (widget.compactMode) {
      return _buildCompactToggle(context, theme, isActive);
    } else {
      return _buildStandardToggle(context, theme, isActive);
    }
  }

  Widget _buildStandardToggle(
    BuildContext context,
    ThemeData theme,
    bool isActive,
  ) {
    if (!widget.showLabel) {
      return _buildSwitchOnly(context, theme, isActive);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusLabel(context, theme, isActive),
        SizedBox(width: 8.0),
        _buildSwitchOnly(context, theme, isActive),
      ],
    );
  }

  Widget _buildCompactToggle(
    BuildContext context,
    ThemeData theme,
    bool isActive,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSwitchOnly(context, theme, isActive, compact: true),
        if (widget.showLabel) ...[
          SizedBox(height: 4.0),
          _buildStatusLabel(context, theme, isActive, compact: true),
        ],
      ],
    );
  }

  Widget _buildSwitchOnly(
    BuildContext context,
    ThemeData theme,
    bool isActive, {
    bool compact = false,
  }) {
    if (_isToggling) {
      if (widget.showLoading) {
        return SizedBox(
          width: compact ? 16.0 : 16.0 * 1.25,
          height: compact ? 16.0 : 16.0 * 1.25,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: theme.colorScheme.primary,
          ),
        );
      } else {
        // Afficher le switch désactivé sans animation
        return Transform.scale(
          scale: compact ? 0.8 : 1.0,
          child: AdaptiveSwitch(
            value: isActive,
            onChanged: null,
            activeColor: theme.colorScheme.primary,
          ),
        );
      }
    }

    final switchWidget = Transform.scale(
      scale: compact ? 0.8 : 1.0,
      child: AdaptiveSwitch(
        value: isActive,
        onChanged: _isToggling ? null : (_) => _toggleStatus(),
        activeColor: theme.colorScheme.primary,
      ),
    );

    if (widget.animate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150), // Animation plus rapide
        curve: Curves.easeInOut,
        child: switchWidget,
      );
    } else {
      return switchWidget;
    }
  }

  Widget _buildStatusLabel(
    BuildContext context,
    ThemeData theme,
    bool isActive, {
    bool compact = false,
  }) {
    final labelPadding = EdgeInsets.symmetric(
      horizontal: compact ? 8.0 : 12.0,
      vertical: compact ? 2.0 : 4.0,
    );

    final labelContainer = Container(
      padding: labelPadding,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primaryContainer.withValues(
                alpha: 16.0,
              )
            : theme.colorScheme.outline.withValues(
                alpha: 16.0,
              ),
        borderRadius: BorderRadius.circular(
          compact ? 16.0 : 20.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: compact ? 4.0 : 8.0,
          ),
          Text(
            widget.item.status.label,
            style: TextStyle(
              fontSize: compact ? 16.0 : 16.0,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
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
