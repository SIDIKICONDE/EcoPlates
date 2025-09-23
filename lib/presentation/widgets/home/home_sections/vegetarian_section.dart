import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Végétarien & Vegan" - options végétales
class VegetarianSection extends StatelessWidget {
  const VegetarianSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '💚 Végétarien & Vegan',
      subtitle: 'Options végétales et bio',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/vegetarian'),
      filterType: 'vegetarian',
    );
  }
}
