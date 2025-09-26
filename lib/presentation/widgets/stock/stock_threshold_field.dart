import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Alerte de stock faible',
                    style: TextStyle(
                      fontSize: 14,
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
              const SizedBox(height: 16),
              
              Text(
                "Seuil d'alerte",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              
              const SizedBox(height: 8),
              
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final intValue = int.tryParse(value);
                        widget.onChanged?.call(intValue);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.warning_outlined,
                      size: 20,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Une notification sera envoyée lorsque le stock atteint ou passe sous ce seuil',
                style: TextStyle(
                  fontSize: 11,
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
