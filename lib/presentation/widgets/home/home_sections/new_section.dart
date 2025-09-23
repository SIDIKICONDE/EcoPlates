import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../merchant_slider_section.dart';

/// Section "Nouveautés" - nouveaux marchands
class NewSection extends StatelessWidget {
  const NewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MerchantSliderSection(
      title: '✨ Nouveautés',
      subtitle: 'Découvrez les derniers arrivés',
      actionText: 'Voir tout',
      onActionTap: () => context.go('/new'),
      filterType: 'new',
    );
  }
}
