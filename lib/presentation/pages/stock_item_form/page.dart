import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';
import 'modals.dart';
import 'utils.dart';

/// Page unifiée pour créer ou modifier un article de stock
///
/// Si [item] est null, on est en mode création
/// Si [item] est fourni, on est en mode édition
class StockItemFormPage extends ConsumerStatefulWidget {
  const StockItemFormPage({this.item, super.key});

  final StockItem? item;

  @override
  ConsumerState<StockItemFormPage> createState() => _StockItemFormPageState();
}

class _StockItemFormPageState extends ConsumerState<StockItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _descriptionController;

  late String? _selectedCategory;
  late StockItemStatus _selectedStatus;
  bool _isSubmitting = false;
  bool _hasChanges = false;

  // Mode création ou édition
  bool get isEditMode => widget.item != null;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs de l'article ou des valeurs par défaut
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _skuController = TextEditingController(text: widget.item?.sku ?? '');
    _priceController = TextEditingController(
      text: widget.item?.price.toStringAsFixed(2) ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.item?.quantity.toString() ?? '',
    );
    _unitController = TextEditingController(text: widget.item?.unit ?? 'pièce');
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _selectedCategory = widget.item?.category;
    _selectedStatus = widget.item?.status ?? StockItemStatus.active;

    // Écouter les changements seulement en mode édition
    if (isEditMode) {
      _nameController.addListener(_onFieldChanged);
      _priceController.addListener(_onFieldChanged);
      _quantityController.addListener(_onFieldChanged);
      _unitController.addListener(_onFieldChanged);
      _descriptionController.addListener(_onFieldChanged);
    }
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
    _skuController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une catégorie'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // En mode édition, si aucun changement, on retourne simplement
    if (isEditMode && !_hasChanges) {
      context.pop();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (isEditMode) {
        // Mode édition : mettre à jour l'article existant
        final updatedItem = widget.item!.copyWith(
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

        await ref.read(stockItemsProvider.notifier).updateItem(updatedItem);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Article "${_nameController.text}" mis à jour'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Mode création : ajouter un nouvel article
        await ref
            .read(stockItemsProvider.notifier)
            .createItem(
              name: _nameController.text.trim(),
              sku: _skuController.text.trim(),
              category: _selectedCategory!,
              price: double.parse(_priceController.text),
              quantity: int.parse(_quantityController.text),
              unit: _unitController.text,
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              status: _selectedStatus,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Article "${_nameController.text}" ajouté avec succès',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      if (mounted) {
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
    if (!isEditMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer l'article ?"),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${widget.item!.name}" ?\n'
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
        await ref.read(stockItemsProvider.notifier).deleteItem(widget.item!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Article "${widget.item!.name}" supprimé'),
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
        title: Text(isEditMode ? "Modifier l'article" : 'Nouvel article'),
        centerTitle: true,
        actions: [
          // Bouton de suppression seulement en mode édition
          if (isEditMode)
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
                    isEditMode
                        ? (_hasChanges ? 'Enregistrer' : 'OK')
                        : 'Enregistrer',
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
              // Infos système en mode édition
              if (isEditMode) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    Text(
                      'SKU: ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        widget.item!.sku,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dernière maj: ${formatDateTime(widget.item!.updatedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

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
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est requis';
                  }
                  if (value.trim().length < 3) {
                    return 'Au moins 3 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // SKU seulement en mode création
              if (!isEditMode) ...[
                TextFormField(
                  controller: _skuController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'SKU/Référence *',
                    hintText: 'Ex: FRT-001',
                    prefixIcon: Icon(Icons.qr_code),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La référence est requise';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
              ],

              // Catégorie
              InkWell(
                onTap: () => showCategoryModal(
                  context,
                  _selectedCategory,
                  (category) => setState(() => _selectedCategory = category),
                  isEditMode,
                  () => setState(() => _hasChanges = true),
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Catégorie *',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Text(
                    _selectedCategory ?? 'Sélectionner une catégorie',
                    style: TextStyle(
                      color: _selectedCategory != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Statut
              InkWell(
                onTap: () => showStatusModal(
                  context,
                  _selectedStatus,
                  (status) => setState(() => _selectedStatus = status),
                  isEditMode,
                  () => setState(() => _hasChanges = true),
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Statut',
                    prefixIcon: Icon(Icons.toggle_on_outlined),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _selectedStatus == StockItemStatus.active
                              ? Colors.green
                              : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        _selectedStatus.label,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Prix
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Prix (€) *',
                  prefixIcon: Icon(Icons.euro),
                  border: OutlineInputBorder(),
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

              const SizedBox(height: 12),

              // Quantité et unité
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (isEditMode && !_hasChanges && value != widget.item?.quantity.toString()) {
                          setState(() => _hasChanges = true);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quantité *',
                        hintText: 'Ex: 10',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Quantité requise';
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
                  Expanded(
                    child: InkWell(
                      onTap: () => showUnitModal(
                        context,
                        _unitController,
                        isEditMode,
                        () => setState(() => _hasChanges = true),
                      ),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Unité *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        child: Text(
                          _unitController.text.isEmpty
                              ? 'pièce'
                              : _unitController.text,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: "Informations complémentaires sur l'article",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 16),

              // Note informative sur le statut en mode création
              if (!isEditMode)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'L\'article sera créé avec le statut "${_selectedStatus.label}"',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 80), // Espace pour éviter le clavier
            ],
          ),
        ),
      ),
    );
  }
}
