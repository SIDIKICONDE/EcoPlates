import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Recommandé pour vous" - suggestions personnalisées
class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '🎯 Recommandé pour vous',
      subtitle: 'Sélection personnalisée selon vos goûts',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/recommended'),
      filterType: 'recommended',
    );
  }
}
