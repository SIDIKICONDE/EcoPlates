import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/offer_form_provider.dart';

/// Section des champs de prix et quantité du formulaire d'offre
class OfferFormPriceQuantityFields extends ConsumerWidget {
  const OfferFormPriceQuantityFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    // Valeurs en dur
    const fieldSpacing = 16.0;
    const sectionSpacing = 20.0;
    const fieldRadius = 12.0;
    const textSize = 16.0;

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
                  contentPadding: EdgeInsets.all(16.0),
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
                  contentPadding: EdgeInsets.all(16.0),
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
            contentPadding: EdgeInsets.all(16.0),
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
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calculate,
                      color: theme.colorScheme.primary,
                      size: 20.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Résumé des prix',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
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
            fontSize: 12.0,
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.0,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
