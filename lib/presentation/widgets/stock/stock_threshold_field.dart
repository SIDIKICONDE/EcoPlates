import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/responsive/design_tokens.dart';

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
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: EcoPlatesDesignTokens.size.icon(context),
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: context.scaleXXS_XS_SM_MD),
                Expanded(
                  child: Text(
                    'Alerte de stock faible',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
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
              SizedBox(height: context.scaleMD_LG_XL_XXL),

              Text(
                "Seuil d'alerte",
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: context.scaleXXS_XS_SM_MD),

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
                          horizontal: context.scaleXS_SM_MD_LG,
                          vertical: context.scaleXS_SM_MD_LG,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.sm,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.sm,
                          ),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.sm,
                          ),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: EcoPlatesDesignTokens.layout.cardBorderWidth,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final intValue = int.tryParse(value);
                        widget.onChanged?.call(intValue);
                      },
                    ),
                  ),
                  SizedBox(width: context.scaleXS_SM_MD_LG),
                  Container(
                    padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                      ),
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens.radius.sm,
                      ),
                      border: Border.all(
                        color: Colors.orange.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        ),
                        width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_outlined,
                      size: EcoPlatesDesignTokens.size.icon(context),
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.scaleXXS_XS_SM_MD),

              Text(
                'Une notification sera envoyée lorsque le stock atteint ou passe sous ce seuil',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant,
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
