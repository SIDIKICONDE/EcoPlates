import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/services/contact_actions_service.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/merchant_profile.dart';
import 'components/contact_section.dart';
import 'components/no_contact_info_message.dart';

/// Widget pour afficher les informations de contact du merchant
///
/// Affiche l'adresse, téléphone et email avec actions
/// selon les directives EcoPlates
class MerchantContactInfo extends ConsumerWidget {
  const MerchantContactInfo({
    required this.profile,
    super.key,
    this.isEditable = false,
  });

  final MerchantProfile profile;
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactService = ContactActionsService();

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: const BoxDecoration(
        color: DeepColorTokens.neutral50,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveText(
            'Coordonnées',
            fontSize: FontSizes.subtitleSmall,
          ),

          // Adresse
          if (profile.address != null) ...[
            ContactSection(
              icon: Icons.location_on,
              title: 'Adresse',
              value: profile.address!.formatted,
              actionIcon: Icons.directions,
              onTap: () => contactService.openInMaps(profile.address!),
            ),
          ],

          // Téléphone
          if (profile.phoneNumber != null) ...[
            ContactSection(
              icon: Icons.phone,
              title: 'Téléphone',
              value: contactService.formatPhoneNumber(profile.phoneNumber!),
              actionIcon: Icons.call,
              onTap: () => contactService.callPhone(profile.phoneNumber!),
              onLongPress: () => contactService.copyToClipboard(
                context,
                profile.phoneNumber!,
                'Numéro copié',
              ),
            ),
          ],

          // Email
          if (profile.email != null) ...[
            ContactSection(
              icon: Icons.email,
              title: 'Email',
              value: profile.email!,
              actionIcon: Icons.send,
              onTap: () => contactService.sendEmail(profile.email!),
              onLongPress: () => contactService.copyToClipboard(
                context,
                profile.email!,
                'Email copié',
              ),
            ),
          ],

          // Message si aucune info
          if (profile.address == null &&
              profile.phoneNumber == null &&
              profile.email == null)
            const NoContactInfoMessage(),
        ],
      ),
    );
  }
}
