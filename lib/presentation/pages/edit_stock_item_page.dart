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
            content: Text('Erreur : ${e}'),
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
        title: const Text("Supprimer l'article ?"),
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

    if (confirmed ?? false && mounted) {
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
              content: Text('Erreur lors de la suppression : ${e}'),
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
        title: const Text("Modifier l'article"),
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
              // Ligne infos système (simple)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 16),
                  Text('SKU: ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      widget.item.sku,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dernière maj: ${_formatDateTime(widget.item.updatedAt)}',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Nom
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: "Nom de l'article *",
                  prefixIcon: Icon(Icons.label_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Le nom est requis';
                  if (value.trim().length < 3) return 'Au moins 3 caractères';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Catégorie
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Catégorie *',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _hasChanges = true;
                  });
                },
              ),

              const SizedBox(height: 12),

              // Statut
              DropdownButtonFormField<StockItemStatus>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Statut',
                  border: OutlineInputBorder(),
                ),
                items: StockItemStatus.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                    _hasChanges = true;
                  });
                },
              ),

              const SizedBox(height: 12),

              // Prix
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                decoration: const InputDecoration(
                  labelText: 'Prix (€) *',
                  prefixIcon: Icon(Icons.euro),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Le prix est requis';
                  final p = double.tryParse(value);
                  if (p == null || p <= 0) return 'Prix invalide';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Quantité + Unité
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Quantité *',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Quantité requise';
                        final q = int.tryParse(value);
                        if (q == null || q < 0) return 'Quantité invalide';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _unitController.text,
                      decoration: const InputDecoration(
                        labelText: 'Unité *',
                        border: OutlineInputBorder(),
                      ),
                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (v) {
                        setState(() {
                          _unitController.text = v ?? 'pièce';
                          _hasChanges = true;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 80),
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
      return "À l'instant";
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
