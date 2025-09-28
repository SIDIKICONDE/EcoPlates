import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/merchant_enums.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/merchant_profile.dart';

/// Widget pour afficher les horaires d'ouverture du merchant
///
/// Affiche un tableau clair par jour de la semaine
/// selon les directives EcoPlates
class MerchantOpeningHours extends ConsumerWidget {
  const MerchantOpeningHours({
    required this.profile,
    super.key,
    this.isCompact = false,
  });

  final MerchantProfile profile;
  final bool isCompact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xl),
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: colors.primary,
                size: EcoPlatesDesignTokens.size.icon(context),
              ),
              SizedBox(width: context.scaleMD_LG_XL_XXL),
              Text(
                "Horaires d'ouverture",
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Tableau des horaires
          if (profile.openingHours.isNotEmpty)
            _buildHoursTable(context, theme, colors)
          else
            _buildNoHoursMessage(context, theme, colors),
        ],
      ),
    );
  }

  Widget _buildHoursTable(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    final today = WeekDay.values[DateTime.now().weekday - 1];

    return Column(
      children: WeekDay.sortedDays.map((day) {
        final hours = profile.openingHours[day];
        final isToday = day == today;

        return _buildDayRow(
          context,
          day: day,
          hours: hours,
          isToday: isToday,
          theme: theme,
          colors: colors,
        );
      }).toList(),
    );
  }

  Widget _buildDayRow(
    BuildContext context, {
    required WeekDay day,
    required bool isToday,
    required ThemeData theme,
    required ColorScheme colors,
    OpeningHours? hours,
  }) {
    final isClosed = hours == null || hours.isClosed;

    return Container(
      margin: EdgeInsets.only(bottom: context.scaleXXS_XS_SM_MD),
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXS_SM_MD_LG,
        vertical: context.scaleXS_SM_MD_LG,
      ),
      decoration: BoxDecoration(
        color: isToday
            ? colors.primary.withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              )
            : Colors.transparent,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: isToday
            ? Border.all(
                color: colors.primary.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Jour de la semaine
          SizedBox(
            width: isCompact ? 60 : 100,
            child: Text(
              isCompact ? day.displayName.substring(0, 3) : day.displayName,
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
                fontWeight: isToday
                    ? EcoPlatesDesignTokens.typography.bold
                    : FontWeight.normal,
                color: isToday ? colors.primary : colors.onSurface,
              ),
            ),
          ),

          // Statut ouvert/fermé (pour aujourd'hui)
          if (isToday && !isCompact) ...[
            SizedBox(width: context.scaleXXS_XS_SM_MD),
            _buildTodayStatus(colors, isClosed),
            SizedBox(width: context.scaleXXS_XS_SM_MD),
          ],

          // Horaires
          Expanded(
            child: Text(
              isClosed ? 'Fermé' : hours.displayFormat,
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
                color: isClosed ? colors.onSurfaceVariant : colors.onSurface,
                fontStyle: isClosed ? FontStyle.italic : null,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStatus(ColorScheme colors, bool isClosed) {
    final isOpen = !isClosed && profile.isOpenNow();

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOpen ? Colors.green : colors.error,
      ),
    );
  }

  Widget _buildNoHoursMessage(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Container(
      padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.schedule,
              color: colors.onSurfaceVariant.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
              size: EcoPlatesDesignTokens.size.modalIcon(context),
            ),
            SizedBox(height: context.scaleXS_SM_MD_LG),
            Text(
              'Horaires non renseignés',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget compact pour afficher uniquement les horaires d'aujourd'hui
class TodayOpeningHours extends ConsumerWidget {
  const TodayOpeningHours({
    required this.profile,
    super.key,
  });

  final MerchantProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final today = WeekDay.values[DateTime.now().weekday - 1];
    final todayHours = profile.openingHours[today];
    final status = profile.getCurrentStatus();

    return Container(
      padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        border: Border.all(
          color: _getStatusColor(status, colors).withValues(
            alpha: EcoPlatesDesignTokens.opacity.subtle,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: EcoPlatesDesignTokens.size.indicator(context),
            color: _getStatusColor(status, colors),
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    color: colors.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
                Text(
                  todayHours == null || todayHours.isClosed
                      ? 'Fermé'
                      : todayHours.displayFormat,
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    fontWeight: EcoPlatesDesignTokens.typography.medium,
                  ),
                ),
              ],
            ),
          ),

          // Statut
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.scaleXXS_XS_SM_MD,
              vertical: context.scaleXXS_XS_SM_MD / 2,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(status, colors).withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.lg,
              ),
            ),
            child: Text(
              status.displayName,
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
                color: _getStatusColor(status, colors),
                fontWeight: EcoPlatesDesignTokens.typography.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OpenStatus status, ColorScheme colors) {
    switch (status) {
      case OpenStatus.open:
        return Colors.green;
      case OpenStatus.closingSoon:
        return Colors.orange;
      case OpenStatus.closed:
        return colors.error;
    }
  }
}
