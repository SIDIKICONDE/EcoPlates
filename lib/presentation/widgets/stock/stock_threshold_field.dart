import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../offer_card/offer_card_configs.dart';

/// Champ de saisie pour configurer le seuil d'alerte de stock faible
class StockThresholdField extends StatefulWidget {
  const StockThresholdField({
    required this.controller,
    required this.unit,
    this.onChanged,
    this.enabled = true,
    super.key,
  });

  /// Contrôleur pour la valeur du seuil
  final TextEditingController controller;

  /// Unité de mesure (pour l'affichage)
  final String unit;

  /// Callback lors du changement
  final ValueChanged<int?>? onChanged;

  /// Champ activé ou non
  final bool enabled;

  @override
  State<StockThresholdField> createState() => _StockThresholdFieldState();
}

class _StockThresholdFieldState extends State<StockThresholdField> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.controller.text.isNotEmpty;
  }

  void _toggleEnabled(bool? value) {
    setState(() {
      _isEnabled = value ?? false;
      if (!_isEnabled) {
        widget.controller.clear();
        widget.onChanged?.call(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser la configuration responsive d'OfferCardConfigs
    const config = OfferCardConfigs.defaultConfig;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            config.imageBorderRadius ??
            BorderRadius.circular(
              ResponsiveUtils.getVerticalSpacing(context),
            ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveUtils.getVerticalSpacing(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
                  color: DeepColorTokens.primary,
                ),
                SizedBox(
                  width: ResponsiveUtils.getHorizontalSpacing(context) / 2,
                ),
                Expanded(
                  child: Text(
                    'Alerte de stock faible',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16.0,
                      ),
                      fontWeight: FontWeight.w500,
                      color: DeepColorTokens.neutral900,
                    ),
                  ),
                ),
                Switch(
                  value: _isEnabled,
                  onChanged: widget.enabled ? _toggleEnabled : null,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),

            if (_isEnabled) ...[
              SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),

              Text(
                "Seuil d'alerte",
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    16.0,
                  ),
                  color: DeepColorTokens.neutral700,
                ),
              ),

              SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) / 2),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      enabled: widget.enabled,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'Ex: 10',
                        suffixText: widget.unit,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal:
                              ResponsiveUtils.getHorizontalSpacing(context) / 2,
                          vertical:
                              ResponsiveUtils.getVerticalSpacing(context) / 2,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getVerticalSpacing(context),
                          ),
                          borderSide: BorderSide(
                            color: DeepColorTokens.neutral400,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.getVerticalSpacing(context),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final intValue = int.tryParse(value);
                        widget.onChanged?.call(intValue);
                      },
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.getHorizontalSpacing(context) / 2,
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.getVerticalSpacing(context) / 2,
                    ),
                    decoration: BoxDecoration(
                      color: DeepColorTokens.warning.withValues(alpha: 16.0),
                      border: Border.all(
                        color: DeepColorTokens.warning,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveUtils.getVerticalSpacing(context) / 2),

              Text(
                'Une notification sera envoyée lorsque le stock atteint ou passe sous ce seuil',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(
                    context,
                    16.0,
                  ),
                  color: DeepColorTokens.neutral700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
