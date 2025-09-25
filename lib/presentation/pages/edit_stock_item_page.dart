import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/stock_item.dart';
import '../providers/stock_items_provider.dart';

/// Page complète pour éditer un article de stock existant
///
/// Permet de modifier toutes les informations d'un article sauf le SKU
class EditStockItemPage extends ConsumerStatefulWidget {
  const EditStockItemPage({required this.item, super.key});

  final StockItem item;

  @override
  ConsumerState<EditStockItemPage> createState() => _EditStockItemPageState();
}

class _EditStockItemPageState extends ConsumerState<EditStockItemPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _descriptionController;

  late String _selectedCategory;
  late StockItemStatus _selectedStatus;
  bool _isSubmitting = false;
  bool _hasChanges = false;

  // Liste des catégories disponibles
  final List<String> _categories = [
    'Fruits',
    'Légumes',
    'Plats',
    'Boulangerie',
    'Boissons',
    'Épicerie',
    'Viande',
    'Poisson',
    'Produits laitiers',
    'Surgelés',
    'Autre',
  ];

  // Liste des unités courantes
  final List<String> _units = [
    'pièce',
    'kg',
    'g',
    'litre',
    'ml',
    'portion',
    'barquette',
    'sachet',
    'bouteille',
    'pot',
  ];

  @override
  void initState() {
    super.initState();
    // Initialiser avec les valeurs actuelles
    _nameController = TextEditingController(text: widget.item.name);
    _priceController = TextEditingController(
      text: widget.item.price.toStringAsFixed(2),
    );
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _unitController = TextEditingController(text: widget.item.unit);
    _descriptionController = TextEditingController(
      text: widget.item.description ?? '',
    );
    _selectedCategory = widget.item.category;
    _selectedStatus = widget.item.status;

    // Écouter les changements
    _nameController.addListener(_onFieldChanged);
    _priceController.addListener(_onFieldChanged);
    _quantityController.addListener(_onFieldChanged);
    _unitController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) {
      // Pas de changements, on retourne simplement
      context.pop();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Créer l'objet article mis à jour
      final updatedItem = widget.item.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        unit: _unitController.text,
        status: _selectedStatus,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        updatedAt: DateTime.now(),
      );

      // Mettre à jour via le provider
      await ref.read(stockItemsProvider.notifier).updateItem(updatedItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Article "${_nameController.text}" mis à jour'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Retour à la page stock
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'article ?'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${widget.item.name}" ?\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        // Suppression via le provider
        await ref.read(stockItemsProvider.notifier).deleteItem(widget.item.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Article "${widget.item.name}" supprimé'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la suppression : ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'article'),
        centerTitle: true,
        actions: [
          // Bouton de suppression
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteItem,
            tooltip: 'Supprimer',
          ),
          // Bouton de validation
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _hasChanges ? 'Enregistrer' : 'OK',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Informations non modifiables
              Card(
                margin: EdgeInsets.zero,
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informations système',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // SKU non modifiable
                      Row(
                        children: [
                          Text(
                            'SKU : ',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.item.sku,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Dernière mise à jour
                      Text(
                        'Dernière modification : ${_formatDateTime(widget.item.updatedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section informations principales
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations principales',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nom de l'article
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Nom de l\'article *',
                          hintText: 'Ex: Pommes Gala',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.label_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom est requis';
                          }
                          if (value.trim().length < 3) {
                            return 'Le nom doit contenir au moins 3 caractères';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Catégorie et Statut sur la même ligne
                      Row(
                        children: [
                          // Catégorie
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                labelText: 'Catégorie *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.category_outlined),
                              ),
                              items: _categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                  _hasChanges = true;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Statut
                          Expanded(
                            child: DropdownButtonFormField<StockItemStatus>(
                              value: _selectedStatus,
                              decoration: InputDecoration(
                                labelText: 'Statut',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(
                                  _selectedStatus == StockItemStatus.active
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color:
                                      _selectedStatus == StockItemStatus.active
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              items: StockItemStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.label),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                  _hasChanges = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section prix et stock
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Prix et stock',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          // Indicateur de rupture de stock
                          if (widget.item.isOutOfStock)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    size: 14,
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Rupture de stock',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Prix
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Prix unitaire (€) *',
                          hintText: '0.00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.euro),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le prix est requis';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price <= 0) {
                            return 'Prix invalide';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Quantité et unité
                      Row(
                        children: [
                          // Quantité
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Quantité en stock *',
                                hintText: '0',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.inventory_2_outlined,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'La quantité est requise';
                                }
                                final qty = int.tryParse(value);
                                if (qty == null || qty < 0) {
                                  return 'Quantité invalide';
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Unité
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _unitController.text,
                              decoration: InputDecoration(
                                labelText: 'Unité *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                              ),
                              items: _units.map((unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _unitController.text = value ?? 'pièce';
                                  _hasChanges = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Section description
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations complémentaires',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText:
                              'Informations complémentaires sur l\'article',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80), // Espace pour éviter le clavier
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
