import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/analytics_stats.dart';

/// Dialogue pour afficher les détails d'une étape du tunnel de conversion
class StepDetailsDialog extends StatelessWidget {
  const StepDetailsDialog({
    required this.step,
    required this.dropRate,
    super.key,
  });

  final FunnelStep step;
  final double dropRate;

  static Future<void> show(
    BuildContext context,
    FunnelStep step,
    double dropRate,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => StepDetailsDialog(
        step: step,
        dropRate: dropRate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getStepIcon(step.label),
            color: Color(step.color),
          ),
          const SizedBox(width: 8.0),
          Text(step.label),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Nombre',
            NumberFormat.decimalPattern(
              'fr',
            ).format(step.count),
          ),
          _buildDetailRow(
            'Pourcentage',
            '${step.percentage.toStringAsFixed(1)}%',
          ),
          if (dropRate > 0)
            _buildDetailRow(
              "Taux d'abandon",
              '${dropRate.toStringAsFixed(1)}%',
              isError: true,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isError ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStepIcon(String label) {
    switch (label.toLowerCase()) {
      case 'visiteurs':
      case 'visites':
        return Icons.visibility;
      case 'paniers':
      case 'ajout panier':
        return Icons.shopping_basket;
      case 'commandes':
      case 'checkout':
        return Icons.shopping_cart;
      case 'paiements':
      case 'paiement':
        return Icons.payment;
      case 'livraisons':
      case 'livraison':
        return Icons.local_shipping;
      default:
        return Icons.circle;
    }
  }
}
