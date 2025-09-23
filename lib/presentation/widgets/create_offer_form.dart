import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/adaptive_widgets.dart';
import '../../../domain/entities/food_offer.dart';

/// Widget réutilisable pour le formulaire de création/édition d'offre
class CreateOfferForm extends StatefulWidget {
  final FoodOffer? initialOffer;
  final bool isEditing;
  final Function(FoodOffer) onSaved;
  final VoidCallback? onChanged;

  const CreateOfferForm({
    super.key,
    this.initialOffer,
    this.isEditing = false,
    required this.onSaved,
    this.onChanged,
  });

  @override
  State<CreateOfferForm> createState() => _CreateOfferFormState();
}

class _CreateOfferFormState extends State<CreateOfferForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _quantityController = TextEditingController();

  // États du formulaire
  OfferType _selectedType = OfferType.panier;
  FoodCategory _selectedCategory = FoodCategory.autre;
  DateTime? _pickupStartTime;
  DateTime? _pickupEndTime;
  final List<File> _images = [];
  List<String> _selectedAllergens = [];
  bool _isVegetarian = false;
  bool _isVegan = false;
  bool _isHalal = false;
  bool _isSubmitting = false;

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialOffer != null) {
      _initializeFromOffer(widget.initialOffer!);
    }
  }

  void _initializeFromOffer(FoodOffer offer) {
    _titleController.text = offer.title;
    _descriptionController.text = offer.description;
    _originalPriceController.text = offer.originalPrice.toString();
    _discountedPriceController.text = offer.discountedPrice.toString();
    _quantityController.text = offer.quantity.toString();
    _selectedType = offer.type;
    _selectedCategory = offer.category;
    _pickupStartTime = offer.pickupStartTime;
    _pickupEndTime = offer.pickupEndTime;
    _isVegetarian = offer.isVegetarian;
    _isVegan = offer.isVegan;
    _isHalal = offer.isHalal;
    _selectedAllergens = List.from(offer.allergens);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validation basique
    if (_pickupStartTime == null || _pickupEndTime == null) {
      // TODO: Afficher une erreur
      return;
    }

    final originalPrice = double.tryParse(_originalPriceController.text);
    final discountedPrice = double.tryParse(_discountedPriceController.text);
    final quantity = int.tryParse(_quantityController.text);

    if (originalPrice == null || discountedPrice == null || quantity == null) {
      // TODO: Afficher une erreur
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final offer = FoodOffer(
        id: widget.initialOffer?.id ?? '',
        merchantId: '', // Sera défini par le provider
        merchantName: widget.initialOffer?.merchantName ?? '', // Sera défini par le provider
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        category: _selectedCategory,
        originalPrice: originalPrice,
        discountedPrice: discountedPrice,
        quantity: quantity,
        pickupStartTime: _pickupStartTime!,
        pickupEndTime: _pickupEndTime!,
        images: _images.map((file) => file.path).toList(),
        allergens: _selectedAllergens,
        isVegetarian: _isVegetarian,
        isVegan: _isVegan,
        isHalal: _isHalal,
        status: widget.initialOffer?.status ?? OfferStatus.draft,
        createdAt: widget.initialOffer?.createdAt ?? DateTime.now(),
        location: widget.initialOffer?.location ?? const Location(
          latitude: 0,
          longitude: 0,
          address: '',
          city: '',
          postalCode: '',
        ), // Sera défini par le provider
      );

      widget.onSaved(offer);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Images
            _buildImageSection(),
            SizedBox(height: 24.h),

            // Informations de base
            _buildBasicInfoSection(),
            SizedBox(height: 24.h),

            // Prix et quantité
            _buildPricingSection(),
            SizedBox(height: 24.h),

            // Horaires de collecte
            _buildPickupTimeSection(),
            SizedBox(height: 24.h),

            // Options diététiques
            _buildDietarySection(),
            SizedBox(height: 24.h),

            // Allergènes
            _buildAllergensSection(),
            SizedBox(height: 32.h),

            // Bouton de soumission
            _buildSubmitButton(),
            SizedBox(height: 32.h),
          ],
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
        SizedBox(height: 8.h),
        Text(
          'Ajoutez jusqu\'à 4 photos pour attirer plus de clients',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
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
      width: 80.w,
      height: 80.w,
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
        width: 80.w,
        height: 80.w,
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
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _images.add(File(pickedFile.path)));
      widget.onChanged?.call();
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
        AdaptiveTextField(
          controller: _titleController,
          placeholder: 'Titre de l\'offre *',
          decoration: const InputDecoration(
            labelText: 'Titre de l\'offre *',
          ),
          onChanged: (value) => widget.onChanged?.call(),
        ),
        SizedBox(height: 16.h),
        AdaptiveTextField(
          controller: _descriptionController,
          placeholder: 'Description détaillée',
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
          onChanged: (value) => widget.onChanged?.call(),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prix et quantité',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: AdaptiveTextField(
                controller: _originalPriceController,
                placeholder: 'Prix original',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Prix original (€)',
                  suffixText: '€',
                ),
                onChanged: (value) => widget.onChanged?.call(),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AdaptiveTextField(
                controller: _discountedPriceController,
                placeholder: 'Prix réduit',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Prix réduit (€)',
                  suffixText: '€',
                ),
                onChanged: (value) => widget.onChanged?.call(),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        AdaptiveTextField(
          controller: _quantityController,
          placeholder: 'Quantité disponible',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantité',
          ),
          onChanged: (value) => widget.onChanged?.call(),
        ),
      ],
    );
  }

  Widget _buildPickupTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horaires de collecte',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        // Implémentation simplifiée - à compléter selon les besoins
        const Text('Section horaires à implémenter'),
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
        Row(
          children: [
            AdaptiveSwitch(
              value: _isVegetarian,
              onChanged: (value) {
                setState(() => _isVegetarian = value);
                widget.onChanged?.call();
              },
            ),
            SizedBox(width: 8.w),
            const Text('Végétarien'),
            SizedBox(width: 24.w),
            AdaptiveSwitch(
              value: _isVegan,
              onChanged: (value) {
                setState(() => _isVegan = value);
                widget.onChanged?.call();
              },
            ),
            SizedBox(width: 8.w),
            const Text('Végan'),
          ],
        ),
      ],
    );
  }

  Widget _buildAllergensSection() {
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
        // Implémentation simplifiée - à compléter selon les besoins
        const Text('Section allergènes à implémenter'),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AdaptiveButton(
      onPressed: _isSubmitting ? null : _handleSubmit,
      child: Text(
        widget.isEditing ? 'Mettre à jour' : 'Publier l\'offre',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
