import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/merchant_enums.dart';
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
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Text(
            "Horaires d'ouverture",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16.0),

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
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: isToday ? colors.primary.withValues(alpha: 0.1) : null,
        border: isToday
            ? Border.all(
                color: colors.primary.withValues(alpha: 0.2),
              )
            : null,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Text(
            day.displayName,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
              color: isToday ? colors.primary : colors.onSurface,
            ),
          ),

          if (isToday && !isCompact) ...[
            SizedBox(width: 8.0),
            _buildTodayStatus(colors, isClosed),
            SizedBox(width: 8.0),
          ],

          // Horaires
          Expanded(
            child: Text(
              isClosed ? 'Fermé' : hours.displayFormat,
              style: TextStyle(
                fontSize: 14.0,
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
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.schedule,
              color: colors.onSurfaceVariant.withValues(alpha: 0.6),
              size: 48.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Horaires non renseignés',
              style: TextStyle(
                fontSize: 16.0,
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
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: _getStatusColor(status, colors).withValues(alpha: 0.3),
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  todayHours == null || todayHours.isClosed
                      ? 'Fermé'
                      : todayHours.displayFormat,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.0),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(status, colors).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              status.displayName,
              style: TextStyle(
                fontSize: 12.0,
                color: _getStatusColor(status, colors),
                fontWeight: FontWeight.w600,
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
