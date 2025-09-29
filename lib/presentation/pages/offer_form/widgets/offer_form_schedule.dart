import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/offer_form_provider.dart';

/// Widget adaptatif pour la sélection d'heure selon la plateforme
class PlatformTimePicker extends StatefulWidget {
  const PlatformTimePicker({
    required this.initialTime,
    required this.onTimeSelected,
    super.key,
  });

  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  // Méthode statique pour déclencher le time picker
  static Future<void> showTimePicker(
    BuildContext context, {
    required TimeOfDay initialTime,
    required ValueChanged<TimeOfDay> onTimeSelected,
  }) async {
    final picker = _PlatformTimePickerState();
    await picker._showTimePicker(context, initialTime, onTimeSelected);
  }

  @override
  State<PlatformTimePicker> createState() => _PlatformTimePickerState();
}

class _PlatformTimePickerState extends State<PlatformTimePicker> {
  Future<void> _showTimePicker(
    BuildContext context, [
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay>? onTimeSelected,
  ]) async {
    final time = initialTime ?? widget.initialTime;
    final callback = onTimeSelected ?? widget.onTimeSelected;

    if (Platform.isIOS) {
      await _showCupertinoTimePicker(context, time, callback);
    } else {
      await _showMaterialTimePicker(context, time, callback);
    }
  }

  Future<void> _showCupertinoTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
    ValueChanged<TimeOfDay> onTimeSelected,
  ) async {
    var selectedDateTime = DateTime(
      2024,
      1,
      1,
      initialTime.hour,
      initialTime.minute,
    );

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 260.0,
              color: CupertinoColors.systemBackground,
              child: Column(
                children: [
                  // Header avec boutons
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemBackground,
                      border: Border(
                        bottom: BorderSide(
                          color: CupertinoColors.separator,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Annuler',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Valider',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () {
                            final picked = TimeOfDay(
                              hour: selectedDateTime.hour,
                              minute: selectedDateTime.minute,
                            );
                            onTimeSelected(picked);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  // Time Picker
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: selectedDateTime,
                      onDateTimeChanged: (DateTime newDateTime) {
                        setState(() {
                          selectedDateTime = newDateTime;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showMaterialTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
    ValueChanged<TimeOfDay> onTimeSelected,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Theme.of(context).colorScheme.surface,
                hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                dayPeriodShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hourMinuteColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                dayPeriodColor: Theme.of(context).colorScheme.primaryContainer,
                dialHandColor: Theme.of(context).colorScheme.primary,
                dialBackgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
                dayPeriodTextColor: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer,
                helpTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16.0,
                ),
                hourMinuteTextStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                dayPeriodTextStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimePicker(context),
      child: Icon(Platform.isIOS ? Icons.access_time : Icons.schedule),
    );
  }
}

/// Section des horaires de collecte du formulaire d'offre
class OfferFormScheduleFields extends ConsumerWidget {
  const OfferFormScheduleFields({super.key});

  // Méthode pour obtenir l'heure actuelle arrondie à l'heure suivante
  TimeOfDay _getCurrentRoundedHour() {
    final now = DateTime.now();
    final nextHour = now.hour + 1;
    return TimeOfDay(hour: nextHour >= 24 ? 0 : nextHour, minute: 0);
  }

  // Méthode pour obtenir l'heure de fin (2 heures après le début)
  TimeOfDay _getEndTimeFromStart(TimeOfDay startTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = startMinutes + 120; // +2 heures
    final endHour = endMinutes ~/ 60;
    final endMinute = endMinutes % 60;
    return TimeOfDay(
      hour: endHour >= 24 ? endHour - 24 : endHour,
      minute: endMinute,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    // Valeurs en dur
    const fieldSpacing = 16.0;
    const smallSpacing = 8.0;
    const fieldRadius = 12.0;
    const textSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heure de début
        InkWell(
          onTap: () => PlatformTimePicker.showTimePicker(
            context,
            initialTime: formState.pickupStartTime ?? _getCurrentRoundedHour(),
            onTimeSelected: (time) => ref
                .read(offerFormProvider.notifier)
                .updatePickupStartTime(time),
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Heure de début *',
              prefixIcon: PlatformTimePicker(
                initialTime:
                    formState.pickupStartTime ?? _getCurrentRoundedHour(),
                onTimeSelected: (time) => ref
                    .read(offerFormProvider.notifier)
                    .updatePickupStartTime(time),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fieldRadius),
              ),
              contentPadding: EdgeInsets.all(16.0),
            ),
            child: Text(
              formState.pickupStartTime != null
                  ? _formatTime(formState.pickupStartTime!)
                  : _formatTime(_getCurrentRoundedHour()),
              style: TextStyle(
                color: formState.pickupStartTime != null
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: textSize,
              ),
            ),
          ),
        ),

        SizedBox(height: fieldSpacing),

        // Heure de fin
        InkWell(
          onTap: () => PlatformTimePicker.showTimePicker(
            context,
            initialTime:
                formState.pickupEndTime ??
                _getEndTimeFromStart(_getCurrentRoundedHour()),
            onTimeSelected: (time) =>
                ref.read(offerFormProvider.notifier).updatePickupEndTime(time),
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Heure de fin *',
              prefixIcon: PlatformTimePicker(
                initialTime:
                    formState.pickupEndTime ??
                    _getEndTimeFromStart(_getCurrentRoundedHour()),
                onTimeSelected: (time) => ref
                    .read(offerFormProvider.notifier)
                    .updatePickupEndTime(time),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(fieldRadius),
              ),
              contentPadding: EdgeInsets.all(16.0),
            ),
            child: Text(
              formState.pickupEndTime != null
                  ? _formatTime(formState.pickupEndTime!)
                  : _formatTime(_getEndTimeFromStart(_getCurrentRoundedHour())),
              style: TextStyle(
                color: formState.pickupEndTime != null
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: textSize,
              ),
            ),
          ),
        ),

        // Validation des horaires
        if (formState.pickupStartTime != null &&
            formState.pickupEndTime != null) ...[
          SizedBox(height: smallSpacing),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  _isValidTimeRange(
                    formState.pickupStartTime!,
                    formState.pickupEndTime!,
                  )
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color:
                    _isValidTimeRange(
                      formState.pickupStartTime!,
                      formState.pickupEndTime!,
                    )
                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                    : theme.colorScheme.error.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isValidTimeRange(
                        formState.pickupStartTime!,
                        formState.pickupEndTime!,
                      )
                      ? Icons.check_circle
                      : Icons.warning,
                  color:
                      _isValidTimeRange(
                        formState.pickupStartTime!,
                        formState.pickupEndTime!,
                      )
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  size: 20.0,
                ),
                SizedBox(width: smallSpacing),
                Expanded(
                  child: Text(
                    _getTimeValidationMessage(
                      formState.pickupStartTime!,
                      formState.pickupEndTime!,
                    ),
                    style: TextStyle(
                      fontSize: 14.0,
                      color:
                          _isValidTimeRange(
                            formState.pickupStartTime!,
                            formState.pickupEndTime!,
                          )
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Informations sur les horaires
        SizedBox(height: smallSpacing),
        Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20.0,
                  ),
                  SizedBox(width: smallSpacing),
                  Text(
                    'Conseils horaires',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: smallSpacing),
              Text(
                '• Les horaires doivent être dans la journée (entre 6h et 22h)\n'
                "• L'heure de fin doit être après l'heure de début\n"
                "• Prévoyez au moins 1 heure d'écart minimum\n"
                '• Pensez aux heures de pointe pour maximiser les collectes',
                style: TextStyle(
                  fontSize: 12.0,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isValidTimeRange(TimeOfDay start, TimeOfDay end) {
    // Vérifier que l'heure de fin est après l'heure de début
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final difference = endMinutes - startMinutes;

    // Au moins 1 heure d'écart et heures dans la journée
    return difference >= 60 &&
        start.hour >= 6 &&
        start.hour <= 22 &&
        end.hour >= 6 &&
        end.hour <= 22;
  }

  String _getTimeValidationMessage(TimeOfDay start, TimeOfDay end) {
    if (!_isValidTimeRange(start, end)) {
      if (start.hour < 6 || start.hour > 22 || end.hour < 6 || end.hour > 22) {
        return 'Les horaires doivent être entre 6h et 22h';
      }
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;
      if (endMinutes - startMinutes < 60) {
        return "Au moins 1 heure d'écart entre début et fin";
      }
    }

    final hours =
        ((end.hour * 60 + end.minute) - (start.hour * 60 + start.minute)) ~/ 60;
    return 'Créneau de $hours heure${hours > 1 ? 's' : ''} défini (${_formatTime(start)} - ${_formatTime(end)})';
  }
}
