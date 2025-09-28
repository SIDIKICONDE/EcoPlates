import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../providers/sales_provider.dart';

/// Barre d'app bar pour la page de gestion des ventes
class SalesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SalesAppBar({super.key});

  @override
  ui.Size get preferredSize => ui.Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveAppBar(
      leading: const _MerchantLogo(),
      title: const Text('Ventes'),
      actions: [
        // Menu d'actions
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          iconSize: context.scaleIconStandard,
          tooltip: 'Actions',
          onSelected: (value) => _handleMenuAction(context, ref, value),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(
                    Icons.download,
                    size: context.scaleIconStandard,
                  ),
                  title: Text(
                    'Exporter',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.modalContent(
                        context,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.scaleSM_MD_LG_XL,
                  ),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: ListTile(
                  leading: Icon(
                    Icons.refresh,
                    size: context.scaleIconStandard,
                  ),
                  title: Text(
                    'Actualiser',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.modalContent(
                        context,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.scaleSM_MD_LG_XL,
                  ),
                  dense: true,
                ),
              ),
            ];
          },
        ),

        SizedBox(width: context.scaleXXS_XS_SM_MD),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'export':
        // TODO(merchant): Implémenter l'export des ventes
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export des ventes en cours...')),
        );
      case 'refresh':
        unawaited(ref.read(salesProvider.notifier).refresh());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actualisation en cours...')),
        );
    }
  }
}

/// Logo du marchand dans la barre d'app bar
class _MerchantLogo extends StatelessWidget {
  const _MerchantLogo();

  @override
  Widget build(BuildContext context) {
    const merchantLogoUrl =
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop&crop=center';

    return Container(
      margin: EdgeInsets.all(context.scaleSM_MD_LG_XL),
      child: CircleAvatar(
        radius: context.scaleXS_SM_MD_LG,
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: const NetworkImage(merchantLogoUrl),
        onBackgroundImageError: (_, _) {
          // Fallback vers une icône si l'image ne charge pas
        },
        child: Icon(
          Icons.store,
          size: context.scaleIconStandard,
          color: Colors.grey,
        ),
      ),
    );
  }
}
