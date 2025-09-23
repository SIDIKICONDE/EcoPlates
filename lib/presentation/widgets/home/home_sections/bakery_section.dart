import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Boulangeries & Pâtisseries" - pains et desserts
class BakerySection extends StatelessWidget {
  const BakerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '🍞 Boulangeries & Pâtisseries',
      subtitle: 'Pains frais, viennoiseries et desserts',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/bakery'),
      filterType: 'bakery',
    );
  }
}
