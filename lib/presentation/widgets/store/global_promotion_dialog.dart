import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/promotion_service.dart';
import '../../providers/store_offers_provider.dart';

/// Dialog pour appliquer une promotion globale à toutes les offres
class GlobalPromotionDialog extends ConsumerStatefulWidget {
  const GlobalPromotionDialog({super.key});

  @override
  ConsumerState<GlobalPromotionDialog> createState() =>
      _GlobalPromotionDialogState();
}

class _GlobalPromotionDialogState extends ConsumerState<GlobalPromotionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _discountController = TextEditingController();
  final _minPriceController = TextEditingController();

  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  final _promotionService = PromotionService();

  @override
  void dispose() {
    _discountController.dispose();
    _minPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.local_offer, color: Colors.blue),
          SizedBox(width: 8.0),
          Text('Promotion globale'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appliquer une réduction sur toutes vos offres actives',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16.0),

              // Pourcentage de réduction
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(
                  labelText: 'Pourcentage de réduction (%)',
                  hintText: 'Ex: 20',
                  prefixIcon: Icon(Icons.percent),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un pourcentage';
                  }
                  final discount = double.tryParse(value);
                  if (discount == null || discount <= 0 || discount > 90) {
                    return 'Le pourcentage doit être entre 1 et 90';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),

              // Prix minimum (optionnel)
              TextFormField(
                controller: _minPriceController,
                decoration: const InputDecoration(
                  labelText: 'Prix minimum (€) - Optionnel',
                  hintText: 'Ex: 5.00',
                  prefixIcon: Icon(Icons.euro),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final minPrice = double.tryParse(value);
                    if (minPrice == null || minPrice < 0) {
                      return 'Le prix minimum doit être positif';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),

              // Dates de début et fin
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Début',
                      date: _startDate,
                      onDateSelected: (date) {
                        setState(() => _startDate = date);
                      },
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: _buildDateField(
                      context: context,
                      label: 'Fin',
                      date: _endDate,
                      onDateSelected: (date) {
                        setState(() => _endDate = date);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // Résumé
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résumé de la promotion',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    _buildSummaryItem(
                      'Réduction',
                      '${_discountController.text.isEmpty ? "0" : _discountController.text}%',
                    ),
                    _buildSummaryItem(
                      'Durée',
                      '${_startDate.day}/${_startDate.month} - ${_endDate.day}/${_endDate.month}',
                    ),
                    if (_minPriceController.text.isNotEmpty)
                      _buildSummaryItem(
                        'Prix min.',
                        '${_minPriceController.text}€',
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _applyPromotion,
          child: _isLoading
              ? SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : const Text('Appliquer'),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime date,
    required void Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          '${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _applyPromotion() async {
    if (!_formKey.currentState!.validate()) return;

    final discountText = _discountController.text;
    final minPriceText = _minPriceController.text;

    final discount = double.parse(discountText);
    final minPrice = minPriceText.isNotEmpty
        ? double.parse(minPriceText)
        : null;

    // Validation avec le service
    final validation = _promotionService.validatePromotion(
      discountPercentage: discount,
      startDate: _startDate,
      endDate: _endDate,
      minPrice: minPrice,
    );

    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation.errors.first),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(storeOffersProvider.notifier)
          .applyGlobalPromotion(
            discountPercentage: discount,
            startDate: _startDate,
            endDate: _endDate,
            minPrice: minPrice,
            // categoryFilters: [], // TODO: Implémenter le filtrage par catégories
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Promotion globale appliquée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de l'application de la promotion: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
