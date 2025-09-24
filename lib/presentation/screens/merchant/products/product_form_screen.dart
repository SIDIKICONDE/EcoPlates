import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';

import '../../../../core/widgets/adaptive_widgets.dart';
import '../../../../domain/entities/product.dart';
import '../../../providers/product_providers.dart';
import '../../../providers/product_state.dart';

/// Écran de création/édition de produit
class ProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;

  const ProductFormScreen({
    super.key,
    this.productId,
  });

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _unitController = TextEditingController(text: 'unité');
  final _weightController = TextEditingController();

  ProductCategory _selectedCategory = ProductCategory.autre;
  DateTime? _expirationDate;
  bool _isVegetarian = false;
  bool _isVegan = false;
  bool _isHalal = false;
  bool _isBio = false;
  final List<File> _images = [];
  final List<String> _selectedAllergens = [];
  final _imagePicker = ImagePicker();

  String get _merchantId {
    // TODO: Récupérer l'ID du marchand depuis le contexte/auth
    return 'merchant_123';
  }

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  void _loadProduct() async {
    final product = await ref.read(productDetailProvider(widget.productId!).future);
    if (product != null && mounted) {
      setState(() {
        _nameController.text = product.name;
        _descriptionController.text = product.description;
        _barcodeController.text = product.barcode;
        _priceController.text = product.price.amount.toString();
        _costPriceController.text = product.costPrice?.amount.toString() ?? '';
        _quantityController.text = product.stock.quantity.toString();
        _minQuantityController.text = product.stock.minQuantity.toString();
        _unitController.text = product.unit;
        _weightController.text = product.weight.toString();
        _selectedCategory = product.category;
        _expirationDate = product.expirationDate;
        _isVegetarian = product.isVegetarian;
        _isVegan = product.isVegan;
        _isHalal = product.isHalal;
        _isBio = product.isBio;
        _selectedAllergens.addAll(product.allergens);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    _unitController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(productFormProvider);
    
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(widget.productId == null ? 'Nouveau produit' : 'Modifier le produit'),
        actions: [
          if (formState.hasChanges)
            AdaptiveIconButton(
              icon: const Icon(Icons.save),
              cupertinoIcon: CupertinoIcons.checkmark_circle,
              onPressed: formState.isSaving ? null : () => _saveProduct(),
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images
                _buildImageSection(),
                SizedBox(height: 24.h),

                // Informations de base
                _buildBasicInfoSection(),
                SizedBox(height: 24.h),

                // Catégorie
                _buildCategorySection(),
                SizedBox(height: 24.h),

                // Prix et stock
                _buildPricingSection(),
                SizedBox(height: 24.h),

                // Informations supplémentaires
                _buildAdditionalInfoSection(),
                SizedBox(height: 24.h),

                // Options diététiques
                _buildDietarySection(),
                SizedBox(height: 24.h),

                // Allergènes
                _buildAllergensSection(),
                SizedBox(height: 32.h),

                // Boutons d'action
                _buildActionButtons(formState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos du produit',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._images.map((image) => _buildImageTile(image)),
              if (_images.length < 4) _buildAddImageTile(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile(File image) {
    return Container(
      width: 100.w,
      height: 100.w,
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _images.remove(image)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100.w,
        height: 100.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.grey,
            style: BorderStyle.solid,
          ),
        ),
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && mounted) {
      setState(() => _images.add(File(pickedFile.path)));
      _updateFormState();
    }
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de base',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Nom du produit *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le nom est requis';
            }
            return null;
          },
          onChanged: (_) => _updateFormState(),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          maxLines: 3,
          onChanged: (_) => _updateFormState(),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _barcodeController,
          decoration: InputDecoration(
            labelText: 'Code-barres',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: _scanBarcode,
            ),
          ),
          onChanged: (_) => _updateFormState(),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        DropdownButtonFormField<ProductCategory>(
          initialValue: _selectedCategory,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          items: ProductCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category.displayName),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedCategory = value);
              _updateFormState();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prix et stock',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Prix de vente (€) *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le prix est requis';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price < 0) {
                    return 'Prix invalide';
                  }
                  return null;
                },
                onChanged: (_) => _updateFormState(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFormField(
                controller: _costPriceController,
                decoration: InputDecoration(
                  labelText: 'Prix d\'achat (€)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onChanged: (_) => _updateFormState(),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantité actuelle *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requis';
                  }
                  final qty = double.tryParse(value);
                  if (qty == null || qty < 0) {
                    return 'Invalide';
                  }
                  return null;
                },
                onChanged: (_) => _updateFormState(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFormField(
                controller: _minQuantityController,
                decoration: InputDecoration(
                  labelText: 'Stock minimum',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => _updateFormState(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextFormField(
                controller: _unitController,
                decoration: InputDecoration(
                  labelText: 'Unité',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onChanged: (_) => _updateFormState(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations supplémentaires',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Poids (g)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _updateFormState(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: InkWell(
                onTap: _selectExpirationDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date de péremption',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _expirationDate != null
                        ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                        : 'Aucune',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDietarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options diététiques',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 8.h,
          children: [
            FilterChip(
              label: const Text('Végétarien'),
              selected: _isVegetarian,
              onSelected: (value) {
                setState(() => _isVegetarian = value);
                _updateFormState();
              },
            ),
            FilterChip(
              label: const Text('Végan'),
              selected: _isVegan,
              onSelected: (value) {
                setState(() => _isVegan = value);
                _updateFormState();
              },
            ),
            FilterChip(
              label: const Text('Halal'),
              selected: _isHalal,
              onSelected: (value) {
                setState(() => _isHalal = value);
                _updateFormState();
              },
            ),
            FilterChip(
              label: const Text('Bio'),
              selected: _isBio,
              onSelected: (value) {
                setState(() => _isBio = value);
                _updateFormState();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAllergensSection() {
    final commonAllergens = [
      'Gluten',
      'Crustacés',
      'Œufs',
      'Poisson',
      'Arachides',
      'Soja',
      'Lait',
      'Fruits à coque',
      'Céleri',
      'Moutarde',
      'Graines de sésame',
      'Sulfites',
      'Lupin',
      'Mollusques',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergènes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: commonAllergens.map((allergen) {
            final isSelected = _selectedAllergens.contains(allergen);
            return FilterChip(
              label: Text(allergen),
              selected: isSelected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectedAllergens.add(allergen);
                  } else {
                    _selectedAllergens.remove(allergen);
                  }
                });
                _updateFormState();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ProductFormState formState) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Annuler'),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: formState.isSaving ? null : () => _saveProduct(),
            child: formState.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.productId == null ? 'Créer' : 'Mettre à jour'),
          ),
        ),
      ],
    );
  }

  void _scanBarcode() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Scanner le code-barres')),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _barcodeController.text = barcode.rawValue!;
                  Navigator.pop(context);
                  _updateFormState();
                  break;
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectExpirationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (date != null) {
      setState(() => _expirationDate = date);
      _updateFormState();
    }
  }

  void _updateFormState() {
    final product = _buildProduct();
    ref.read(productFormProvider.notifier).updateField(product);
  }

  Product _buildProduct() {
    final now = DateTime.now();
    return Product(
      id: widget.productId ?? '',
      merchantId: _merchantId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      barcode: _barcodeController.text.trim(),
      images: _images.map((f) => f.path).toList(),
      category: _selectedCategory,
      price: Money(
        amount: double.tryParse(_priceController.text) ?? 0,
      ),
      costPrice: _costPriceController.text.isNotEmpty
          ? Money(amount: double.tryParse(_costPriceController.text) ?? 0)
          : null,
      stock: Stock(
        quantity: double.tryParse(_quantityController.text) ?? 0,
        minQuantity: double.tryParse(_minQuantityController.text) ?? 0,
        status: StockStatus.inStock,
      ),
      nutritionalInfo: const NutritionalInfo(),
      allergens: _selectedAllergens,
      isVegetarian: _isVegetarian,
      isVegan: _isVegan,
      isHalal: _isHalal,
      isBio: _isBio,
      expirationDate: _expirationDate,
      unit: _unitController.text.trim(),
      weight: double.tryParse(_weightController.text) ?? 0,
      isActive: true,
      createdAt: widget.productId != null ? now : now,
      updatedAt: now,
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(productFormProvider.notifier).saveProduct();

    if (mounted && ref.read(productFormProvider).errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.productId == null
                ? 'Produit créé avec succès'
                : 'Produit mis à jour avec succès',
          ),
        ),
      );
      context.pop();
    }
  }
}