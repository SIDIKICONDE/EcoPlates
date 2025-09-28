import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../providers/offer_form_provider.dart';

/// Section des champs de prix et quantité du formulaire d'offre
class OfferFormPriceQuantityFields extends ConsumerWidget {
  const OfferFormPriceQuantityFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    // Design tokens responsives
    final fieldSpacing = EcoPlatesDesignTokens.spacing.dialogGap(context);
    final sectionSpacing = EcoPlatesDesignTokens.spacing.dialogGap(context);
    final fieldRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final contentPadding = EcoPlatesDesignTokens.spacing.contentPadding(
      context,
    );
    final textSize = EcoPlatesDesignTokens.typography.text(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prix original et prix réduit
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: formState.originalPrice > 0
                    ? formState.originalPrice.toStringAsFixed(2)
                    : '',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Prix original (€) *',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.euro),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fieldRadius),
                  ),
                  contentPadding: contentPadding,
                ),
                style: TextStyle(fontSize: textSize),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Requis';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Prix invalide';
                  }
                  return null;
                },
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0.0;
                  ref
                      .read(offerFormProvider.notifier)
                      .updateOriginalPrice(price);
                },
              ),
            ),
            SizedBox(width: fieldSpacing),
            Expanded(
              child: TextFormField(
                initialValue: formState.discountedPrice >= 0
                    ? formState.discountedPrice.toStringAsFixed(2)
                    : '',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'Prix réduit (€) *',
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.local_offer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(fieldRadius),
                  ),
                  contentPadding: contentPadding,
                  helperText:
                      formState.originalPrice > 0 &&
                          formState.discountedPrice >= 0
                      ? _getDiscountText(formState)
                      : null,
                ),
                style: TextStyle(fontSize: textSize),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Requis';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price < 0) {
                    return 'Prix invalide';
                  }
                  return null;
                },
                onChanged: (value) {
                  final price = double.tryParse(value) ?? 0.0;
                  ref
                      .read(offerFormProvider.notifier)
                      .updateDiscountedPrice(price);
                },
              ),
            ),
          ],
        ),

        SizedBox(height: sectionSpacing),

        // Quantité
        TextFormField(
          initialValue: formState.quantity > 0
              ? formState.quantity.toString()
              : '',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Quantité disponible *',
            hintText: 'Ex: 10',
            prefixIcon: const Icon(Icons.inventory_2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
            contentPadding: contentPadding,
            helperText: 'Nombre de paniers/plats disponibles',
          ),
          style: TextStyle(fontSize: textSize),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La quantité est requise';
            }
            final qty = int.tryParse(value);
            if (qty == null || qty <= 0) {
              return 'Quantité invalide';
            }
            if (qty > 1000) {
              return 'Maximum 1000 unités';
            }
            return null;
          },
          onChanged: (value) {
            final qty = int.tryParse(value) ?? 0;
            ref.read(offerFormProvider.notifier).updateQuantity(qty);
          },
        ),

        // Affichage du résumé des prix
        if (formState.originalPrice > 0 && formState.discountedPrice >= 0)
          Container(
            margin: EdgeInsets.only(top: sectionSpacing),
            padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.fieldRadius(context),
              ),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                    SizedBox(
                      width: EcoPlatesDesignTokens.spacing.interfaceGap(
                        context,
                      ),
                    ),
                    Text(
                      'Résumé des prix',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: EcoPlatesDesignTokens.typography.bold,
                        color: theme.colorScheme.primary,
                        fontSize: EcoPlatesDesignTokens.typography.text(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                Wrap(
                  spacing: EcoPlatesDesignTokens.spacing.sectionSpacing(
                    context,
                  ),
                  runSpacing: EcoPlatesDesignTokens.spacing.microGap(context),
                  children: [
                    _buildPriceInfo(
                      'Prix original',
                      '${formState.originalPrice.toStringAsFixed(2)}€',
                      context,
                      theme,
                    ),
                    _buildPriceInfo(
                      'Prix réduit',
                      formState.isFree
                          ? 'GRATUIT'
                          : '${formState.discountedPrice.toStringAsFixed(2)}€',
                      context,
                      theme,
                    ),
                    if (!formState.isFree)
                      _buildPriceInfo(
                        'Économie',
                        '${(formState.originalPrice - formState.discountedPrice).toStringAsFixed(2)}€ (${formState.discountPercentage.toStringAsFixed(0)}%)',
                        context,
                        theme,
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getDiscountText(OfferFormState state) {
    if (state.isFree) {
      return 'Offre gratuite !';
    }
    if (state.discountPercentage > 0) {
      return '-${state.discountPercentage.toStringAsFixed(0)}% de réduction';
    }
    return 'Prix normal';
  }

  Widget _buildPriceInfo(
    String label,
    String value,
    BuildContext context,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.hint(context),
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: EcoPlatesDesignTokens.typography.medium,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            color: theme.colorScheme.onSurface,
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
      ],
    );
  }
}
