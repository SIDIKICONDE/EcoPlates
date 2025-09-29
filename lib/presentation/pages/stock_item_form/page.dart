import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';
import '../../widgets/stock/stock_threshold_field.dart';
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
  late final TextEditingController _thresholdController;

  late String? _selectedCategory;
  late StockItemStatus _selectedStatus;
  late StockItemStatus _originalStatus;
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
    _thresholdController = TextEditingController(
      text: widget.item?.lowStockThreshold?.toString() ?? '',
    );
    _selectedCategory = widget.item?.category;
    _selectedStatus = widget.item?.status ?? StockItemStatus.active;
    _originalStatus = widget.item?.status ?? StockItemStatus.active;

    // Écouter les changements seulement en mode édition
    if (isEditMode) {
      _nameController.addListener(_onFieldChanged);
      _priceController.addListener(_onFieldChanged);
      _quantityController.addListener(_onFieldChanged);
      _unitController.addListener(_onFieldChanged);
      _descriptionController.addListener(_onFieldChanged);
      _thresholdController.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _onStatusChanged(StockItemStatus status) {
    if (_selectedStatus != status) {
      setState(() {
        _selectedStatus = status;
        if (isEditMode) {
          _hasChanges = true;
        }
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
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez sélectionner une catégorie'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // En mode édition, si pas de changement, juste fermer
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
          lowStockThreshold: _thresholdController.text.isEmpty
              ? null
              : int.tryParse(_thresholdController.text),
          updatedAt: DateTime.now(),
        );

        await ref.read(stockItemsProvider.notifier).updateItem(updatedItem);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Article "${_nameController.text}" mis à jour'),
              backgroundColor: Colors.green.shade700,
            ),
          );
          context.pop();
        }
      } else {
        // Mode création : créer un nouvel article
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
              lowStockThreshold: _thresholdController.text.isEmpty
                  ? null
                  : int.tryParse(_thresholdController.text),
              status: _selectedStatus,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Article "${_nameController.text}" ajouté avec succès',
              ),
              backgroundColor: Colors.green.shade700,
            ),
          );
          context.pop();
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
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
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      try {
        await ref.read(stockItemsProvider.notifier).deleteItem(widget.item!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Article "${widget.item!.name}" supprimé'),
              backgroundColor: Colors.orange.shade700,
            ),
          );
          context.pop();
        }
      } on Exception catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la suppression : $e'),
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
                ? SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                : Text(
                    isEditMode
                        ? (_hasChanges ? 'Enregistrer' : 'OK')
                        : 'Enregistrer',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
          SizedBox(width: 16.0),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Infos système en mode édition
              if (isEditMode) ...[
                Wrap(
                  spacing: 12.0,
                  runSpacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      'SKU: ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        widget.item!.sku,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Dernière maj: ${formatDateTime(widget.item!.updatedAt)}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
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

              SizedBox(height: 16.0),

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
                SizedBox(height: 16.0),
              ],

              // Catégorie
              InkWell(
                onTap: () => showCategoryModal(
                  context,
                  _selectedCategory,
                  (category) => setState(() => _selectedCategory = category),
                  () => setState(() => _hasChanges = true),
                  isEditMode: isEditMode,
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

              SizedBox(height: 16.0),

              // Statut
              InkWell(
                onTap: () => showStatusModal(
                  context,
                  _selectedStatus,
                  _onStatusChanged,
                  () => setState(() => _hasChanges = true),
                  isEditMode: isEditMode,
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
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                          color: _selectedStatus == StockItemStatus.active
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.tertiary,
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

              SizedBox(height: 16.0),

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
                  if (price == null || price <= 0.0) {
                    return 'Prix invalide';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.0),

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
                        if (isEditMode &&
                            !_hasChanges &&
                            value != widget.item?.quantity.toString()) {
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
                  SizedBox(width: 12.0),
                  Expanded(
                    child: InkWell(
                      onTap: () => showUnitModal(
                        context,
                        _unitController,
                        () => setState(() => _hasChanges = true),
                        isEditMode: isEditMode,
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

              SizedBox(height: 16.0),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: "Détails optionnels sur l'article...",
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              SizedBox(height: 16.0),

              // Seuil d'alerte de stock faible
              StockThresholdField(
                controller: _thresholdController,
                unit: _unitController.text.isEmpty
                    ? 'pièce'
                    : _unitController.text,
                onChanged: (_) {
                  if (isEditMode && !_hasChanges) {
                    setState(() => _hasChanges = true);
                  }
                },
              ),

              SizedBox(height: 16.0),

              // Note informative sur le statut en mode création
              if (!isEditMode)
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          'L\'article sera créé avec le statut "${_selectedStatus.label}"',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Espace pour éviter le clavier
              SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}
