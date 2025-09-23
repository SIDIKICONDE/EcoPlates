import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Dernières Minutes" - offres urgentes à sauver
class LastMinuteSection extends StatelessWidget {
  const LastMinuteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '🔥 Dernières Minutes',
      subtitle: 'À sauver dans moins de 2h !',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/last-minute'),
      filterType: 'last-minute',
      isUrgent: true,
    );
  }
}
