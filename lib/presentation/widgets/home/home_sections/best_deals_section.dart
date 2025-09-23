import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Meilleures offres" - plus grandes réductions
class BestDealsSection extends StatelessWidget {
  const BestDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '💎 Meilleures offres',
      subtitle: 'Les plus grandes réductions',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/best-deals'),
      filterType: 'best-deals',
    );
  }
}
