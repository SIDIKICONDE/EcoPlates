import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Petit Budget" - offres à moins de 5€
class BudgetSection extends StatelessWidget {
  const BudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '💰 Petit Budget',
      subtitle: 'Moins de 5€ seulement !',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/budget'),
      filterType: 'budget',
    );
  }
}
