import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Dernière chance" - offres avant fermeture
class ClosingSoonSection extends StatelessWidget {
  const ClosingSoonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '⏰ Dernière chance',
      subtitle: 'À récupérer avant fermeture',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/closing-soon'),
      isUrgent: true,
      filterType: 'closing-soon',
    );
  }
}
