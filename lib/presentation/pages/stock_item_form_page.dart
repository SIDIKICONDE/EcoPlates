import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/stock_item.dart';
import '../providers/stock_items_provider.dart';

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
        await ref.read(stockItemsProvider.notifier).createItem(
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

    if (confirmed ?? false && mounted) {
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
                    Text('SKU: ',
                        style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color:
                                theme.colorScheme.outline.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        widget.item!.sku,
                        style:
                            const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dernière maj: ${_formatDateTime(widget.item!.updatedAt)}',
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant),
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
                onTap: () => _showCategoryModal(context),
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
                onTap: () => _showStatusModal(context),
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
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Prix
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      decoration: const InputDecoration(
                        labelText: 'Quantité *',
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
                      onTap: () => _showUnitModal(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Unité *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        child: Text(
                          _unitController.text.isEmpty ? 'pièce' : _unitController.text,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                          ),
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
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
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

  void _showCategoryModal(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Choisir une catégorie',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Categories grid
              Flexible(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    final color = _getCategoryColor(category);
                    final icon = _getCategoryIcon(category);
                    
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                            if (isEditMode) _hasChanges = true;
                          });
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.2)
                                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.outline.withValues(alpha: 0.1),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.3)
                                      : color.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected
                                      ? color
                                      : color.withValues(alpha: 0.7),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected
                                      ? color
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isSelected) ...[
                                const SizedBox(height: 4),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Color _getCategoryColor(String category) {
    final colors = {
      'Fruits': Colors.orange,
      'Légumes': Colors.green,
      'Plats': Colors.deepOrange,
      'Boulangerie': Colors.brown,
      'Boissons': Colors.blue,
      'Épicerie': Colors.purple,
      'Viande': Colors.red,
      'Poisson': Colors.cyan,
      'Produits laitiers': Colors.amber,
      'Surgelés': Colors.lightBlue,
      'Autre': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }
  
  IconData _getCategoryIcon(String category) {
    final icons = {
      'Fruits': Icons.apple,
      'Légumes': Icons.eco,
      'Plats': Icons.restaurant,
      'Boulangerie': Icons.bakery_dining,
      'Boissons': Icons.local_drink,
      'Épicerie': Icons.shopping_basket,
      'Viande': Icons.kebab_dining,
      'Poisson': Icons.set_meal,
      'Produits laitiers': Icons.icecream,
      'Surgelés': Icons.ac_unit,
      'Autre': Icons.more_horiz,
    };
    return icons[category] ?? Icons.category;
  }
  
  void _showUnitModal(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.straighten,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Choisir une unité',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Units list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _units.length,
                  itemBuilder: (context, index) {
                    final unit = _units[index];
                    final isSelected = _unitController.text == unit;
                    
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _unitController.text = unit;
                          if (isEditMode) _hasChanges = true;
                        });
                        Navigator.of(context).pop();
                      },
                      leading: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          _getUnitIcon(unit),
                          size: 28,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      title: Text(
                        unit,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  IconData _getUnitIcon(String unit) {
    final icons = {
      'pièce': Icons.looks_one,
      'kg': Icons.fitness_center,
      'g': Icons.grain,
      'litre': Icons.water_drop,
      'ml': Icons.water_drop_outlined,
      'portion': Icons.restaurant_menu,
      'barquette': Icons.inventory_2,
      'sachet': Icons.shopping_bag,
      'bouteille': Icons.local_drink,
      'pot': Icons.soup_kitchen,
    };
    return icons[unit] ?? Icons.straighten;
  }
  
  void _showStatusModal(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.toggle_on,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Statut de l\'article',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Status options
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: StockItemStatus.values.map((status) {
                    final isSelected = _selectedStatus == status;
                    final color = status == StockItemStatus.active
                        ? Colors.green
                        : Colors.orange;
                    final icon = status == StockItemStatus.active
                        ? Icons.check_circle
                        : Icons.pause_circle;
                    
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _selectedStatus = status;
                          if (isEditMode) _hasChanges = true;
                        });
                        Navigator.of(context).pop();
                      },
                      leading: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.2)
                              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? color.withValues(alpha: 0.5)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: color,
                        ),
                      ),
                      title: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? color
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        status == StockItemStatus.active
                            ? 'Article disponible à la vente'
                            : 'Article temporairement indisponible',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: color,
                              size: 28,
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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