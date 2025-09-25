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
  });

  /// Article dont on modifie le statut
  final StockItem item;

  /// Affiche le label du statut
  final bool showLabel;

  /// Mode compact (plus petit)
  final bool compactMode;

  @override
  ConsumerState<StockStatusToggle> createState() => _StockStatusToggleState();
}

class _StockStatusToggleState extends ConsumerState<StockStatusToggle> {
  bool _isToggling = false;

  /// Bascule le statut avec gestion d'erreur
  Future<void> _toggleStatus() async {
    if (_isToggling) return;

    setState(() {
      _isToggling = true;
    });

    try {
      await ref.read(stockItemsProvider.notifier).toggleStatus(widget.item.id);
    } catch (error) {
      if (mounted) {
        // Affiche un snackbar en cas d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(StockErrorMessages.getErrorMessage(error)),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
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
      return _buildCompactToggle(theme, isActive);
    } else {
      return _buildStandardToggle(theme, isActive);
    }
  }

  Widget _buildStandardToggle(ThemeData theme, bool isActive) {
    if (!widget.showLabel) {
      return _buildSwitchOnly(theme, isActive);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusLabel(theme, isActive),
        const SizedBox(width: 8),
        _buildSwitchOnly(theme, isActive),
      ],
    );
  }

  Widget _buildCompactToggle(ThemeData theme, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSwitchOnly(theme, isActive, compact: true),
        if (widget.showLabel) ...[
          const SizedBox(height: 4),
          _buildStatusLabel(theme, isActive, compact: true),
        ],
      ],
    );
  }

  Widget _buildSwitchOnly(
    ThemeData theme,
    bool isActive, {
    bool compact = false,
  }) {
    if (_isToggling) {
      return SizedBox(
        width: compact ? 16 : 20,
        height: compact ? 16 : 20,
        child: CircularProgressIndicator(
          strokeWidth: compact ? 2 : 2.5,
          color: theme.colorScheme.primary,
        ),
      );
    }

    return Transform.scale(
      scale: compact ? 0.8 : 1.0,
      child: AdaptiveSwitch(
        value: isActive,
        onChanged: _isToggling ? null : (_) => _toggleStatus(),
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildStatusLabel(
    ThemeData theme,
    bool isActive, {
    bool compact = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(
          color: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            widget.item.status.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
