import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/merchant_enums.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: const BoxDecoration(
        color: DeepColorTokens.neutral50,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            "Horaires d'ouverture",
            fontSize: FontSizes.subtitleSmall,
          ),

          // Tableau des horaires
          if (profile.openingHours.isNotEmpty)
            _buildHoursTable(context)
          else
            _buildNoHoursMessage(context),
        ],
      ),
    );
  }

  Widget _buildHoursTable(
    BuildContext context,
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
        );
      }).toList(),
    );
  }

  Widget _buildDayRow(
    BuildContext context, {
    required WeekDay day,
    required bool isToday,
    required OpeningHours? hours,
  }) {
    final isClosed = hours == null || hours.isClosed;

    return Container(
      margin: EdgeInsets.only(
        bottom: context.responsive(mobile: 6.0, tablet: 8.0, desktop: 10.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing,
        vertical: context.responsive(mobile: 8.0, tablet: 10.0, desktop: 12.0),
      ),
      decoration: BoxDecoration(
        color: isToday ? DeepColorTokens.primary.withValues(alpha: 0.1) : null,
        border: isToday
            ? Border.all(
                color: DeepColorTokens.primary.withValues(alpha: 0.2),
              )
            : null,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          ResponsiveText(
            day.displayName,
            style: TextStyle(
              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
              color: isToday
                  ? DeepColorTokens.primary
                  : DeepColorTokens.neutral1000,
            ),
            fontSize: FontSizes.bodyMedium,
          ),

          if (isToday && !isCompact) ...[
            const HorizontalGap(multiplier: 0.5),
            _buildTodayStatus(isClosed),
            const HorizontalGap(multiplier: 0.5),
          ],

          // Horaires
          if (!isClosed) ...[
            Expanded(
              child: ResponsiveText(
                hours.displayFormat,
                style: const TextStyle(
                  color: DeepColorTokens.neutral1000,
                ),
                fontSize: FontSizes.bodyMedium,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodayStatus(bool isClosed) {
    final isOpen = !isClosed && profile.isOpenNow();

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOpen ? Colors.green : DeepColorTokens.error,
      ),
    );
  }

  Widget _buildNoHoursMessage(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing * 2,
          vertical: context.verticalSpacing * 2,
        ),
        child: const Column(
          children: [
            ResponsiveIcon(
              Icons.schedule,
              color: DeepColorTokens.neutral500,
              size: 48.0,
            ),
            VerticalGap(),
            ResponsiveText(
              'Horaires non renseignés',
              style: TextStyle(
                color: DeepColorTokens.neutral500,
              ),
              fontSize: FontSizes.bodyMedium,
              textAlign: TextAlign.center,
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
    final today = WeekDay.values[DateTime.now().weekday - 1];
    final todayHours = profile.openingHours[today];
    final status = profile.getCurrentStatus();

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: const BoxDecoration(
        color: DeepColorTokens.neutral50,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing,
          vertical: context.responsive(
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    "Aujourd'hui",
                    style: const TextStyle(
                      color: DeepColorTokens.neutral500,
                      fontWeight: FontWeight.w500,
                    ),
                    fontSize: FontSizes.label,
                  ),
                  const VerticalGap(multiplier: 0.5),
                  if (todayHours != null && !todayHours.isClosed) ...[
                    ResponsiveText(
                      todayHours.displayFormat,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: DeepColorTokens.neutral1000,
                      ),
                      fontSize: FontSizes.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            const HorizontalGap(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(
                  status,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ResponsiveText(
                status.displayName,
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w600,
                ),
                fontSize: FontSizes.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OpenStatus status) {
    switch (status) {
      case OpenStatus.open:
        return DeepColorTokens.success;
      case OpenStatus.closingSoon:
        return DeepColorTokens.warning;
      case OpenStatus.closed:
        return DeepColorTokens.error;
    }
  }
}
