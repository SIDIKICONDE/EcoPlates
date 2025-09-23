import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Près de vous" - marchands à proximité
class NearbySection extends StatelessWidget {
  const NearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '🔥 Près de vous',
      subtitle: 'Restaurants à moins de 1km',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/nearby'),
      filterType: 'nearby',
    );
  }
}
