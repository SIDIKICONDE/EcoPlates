import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/merchant_profile.dart';

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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xl),
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            children: [
              Icon(
                Icons.contact_phone,
                color: colors.primary,
                size: EcoPlatesDesignTokens.size.icon(context),
              ),
              SizedBox(width: context.scaleMD_LG_XL_XXL),
              Text(
                'Coordonnées',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          // Adresse
          if (profile.address != null) ...[
            _buildAddressSection(context, colors),
            SizedBox(height: context.scaleMD_LG_XL_XXL),
          ],

          // Téléphone
          if (profile.phoneNumber != null) ...[
            _buildPhoneSection(context, colors),
            SizedBox(height: context.scaleMD_LG_XL_XXL),
          ],

          // Email
          if (profile.email != null) ...[
            _buildEmailSection(context, colors),
          ],

          // Message si aucune info
          if (profile.address == null &&
              profile.phoneNumber == null &&
              profile.email == null)
            _buildNoInfoMessage(context, theme, colors),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context, ColorScheme colors) {
    final address = profile.address!;

    return InkWell(
      onTap: () => _openInMaps(address),
      borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.scaleXXS_XS_SM_MD,
          horizontal: context.scaleXS_SM_MD_LG,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on,
              color: colors.secondary,
              size: EcoPlatesDesignTokens.size.indicator(context),
            ),
            SizedBox(width: context.scaleXS_SM_MD_LG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Adresse',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      fontWeight: EcoPlatesDesignTokens.typography.medium,
                    ),
                  ),
                  SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
                  Text(
                    address.formatted,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.directions,
              color: colors.primary,
              size: EcoPlatesDesignTokens.size.indicator(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneSection(BuildContext context, ColorScheme colors) {
    return InkWell(
      onTap: () => _callPhone(profile.phoneNumber!),
      onLongPress: () =>
          _copyToClipboard(context, profile.phoneNumber!, 'Numéro copié'),
      borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.scaleXXS_XS_SM_MD,
          horizontal: context.scaleXS_SM_MD_LG,
        ),
        child: Row(
          children: [
            Icon(
              Icons.phone,
              color: colors.secondary,
              size: EcoPlatesDesignTokens.size.indicator(context),
            ),
            SizedBox(width: context.scaleXS_SM_MD_LG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Téléphone',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      fontWeight: EcoPlatesDesignTokens.typography.medium,
                    ),
                  ),
                  SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
                  Text(
                    _formatPhoneNumber(profile.phoneNumber!),
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.call,
              color: colors.primary,
              size: EcoPlatesDesignTokens.size.indicator(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSection(BuildContext context, ColorScheme colors) {
    return InkWell(
      onTap: () => _sendEmail(profile.email!),
      onLongPress: () =>
          _copyToClipboard(context, profile.email!, 'Email copié'),
      borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.scaleXXS_XS_SM_MD,
          horizontal: context.scaleXS_SM_MD_LG,
        ),
        child: Row(
          children: [
            Icon(
              Icons.email,
              color: colors.secondary,
              size: EcoPlatesDesignTokens.size.indicator(context),
            ),
            SizedBox(width: context.scaleXS_SM_MD_LG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      fontWeight: EcoPlatesDesignTokens.typography.medium,
                    ),
                  ),
                  SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
                  Text(
                    profile.email!,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.send,
              color: colors.primary,
              size: EcoPlatesDesignTokens.size.indicator(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoInfoMessage(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: colors.onSurfaceVariant.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
              size: EcoPlatesDesignTokens.size.modalIcon(context),
            ),
            SizedBox(height: context.scaleXS_SM_MD_LG),
            Text(
              'Aucune information de contact disponible',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Formater le numéro de téléphone pour l'affichage
  String _formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      return '${cleaned.substring(0, 2)} ${cleaned.substring(2, 4)} ${cleaned.substring(4, 6)} ${cleaned.substring(6, 8)} ${cleaned.substring(8)}';
    } else if (cleaned.startsWith('33') && cleaned.length == 11) {
      return '+33 ${cleaned.substring(2, 3)} ${cleaned.substring(3, 5)} ${cleaned.substring(5, 7)} ${cleaned.substring(7, 9)} ${cleaned.substring(9)}';
    }
    return phone;
  }

  /// Ouvrir l'adresse dans Maps
  Future<void> _openInMaps(MerchantAddress address) async {
    final url = Uri.parse(address.googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Appeler le numéro de téléphone
  Future<void> _callPhone(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  /// Envoyer un email
  Future<void> _sendEmail(String email) async {
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  /// Copier dans le presse-papier
  Future<void> _copyToClipboard(
    BuildContext context,
    String text,
    String message,
  ) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
