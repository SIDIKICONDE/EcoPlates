import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/widgets/adaptive_widgets.dart';
import '../../../../core/error/merchant_error_handler.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../../domain/usecases/merchant/manage_offers_usecase.dart';
import '../../../providers/merchant/offers_management_provider.dart';

/// Écran de création d'offre pour les commerçants
class CreateOfferScreen extends ConsumerStatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  ConsumerState<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends ConsumerState<CreateOfferScreen> {
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
  final List<String> _selectedAllergens = [];
  bool _isVegetarian = false;
  bool _isVegan = false;
  bool _isHalal = false;
  bool _isFree = false;
  bool _isSubmitting = false;

  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Créer une offre'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            child: Text(
              'Publier',
              style: TextStyle(
                color: _isSubmitting ? Colors.grey : theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
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
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos du produit',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'Ajoutez jusqu\'à 4 photos pour attirer plus de clients',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _images.remove(image);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 32.sp, color: Colors.grey),
            SizedBox(height: 4.h),
            Text(
              'Ajouter',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de base',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),

        // Titre
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Titre de l\'offre',
            hintText: 'Ex: Panier du soir - Viennoiseries',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le titre est obligatoire';
            }
            if (value.length < 3) {
              return 'Le titre doit contenir au moins 3 caractères';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        // Description
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Décrivez ce que contient votre offre...',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La description est obligatoire';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),

        // Type d'offre
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type d\'offre',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<OfferType>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: OfferType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getOfferTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catégorie',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<FoodCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: FoodCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(_getCategoryLabel(category)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Prix et quantité',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            // Switch offre gratuite
            Row(
              children: [
                Text(
                  'Offre gratuite',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(width: 8.w),
                Switch.adaptive(
                  value: _isFree,
                  onChanged: (value) {
                    setState(() {
                      _isFree = value;
                      if (value) {
                        _discountedPriceController.text = '0';
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            // Prix original
            Expanded(
              child: TextFormField(
                controller: _originalPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Prix original',
                  prefixText: '€ ',
                  border: const OutlineInputBorder(),
                  enabled: !_isFree,
                ),
                validator: (value) {
                  if (!_isFree) {
                    if (value == null || value.isEmpty) {
                      return 'Requis';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Prix invalide';
                    }
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16.w),
            // Prix réduit
            Expanded(
              child: TextFormField(
                controller: _discountedPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Prix réduit',
                  prefixText: '€ ',
                  border: const OutlineInputBorder(),
                  enabled: !_isFree,
                ),
                validator: (value) {
                  if (!_isFree) {
                    if (value == null || value.isEmpty) {
                      return 'Requis';
                    }
                    final discounted = double.tryParse(value);
                    final original = double.tryParse(
                      _originalPriceController.text,
                    );
                    if (discounted == null || discounted < 0) {
                      return 'Prix invalide';
                    }
                    if (original != null && discounted >= original) {
                      return 'Doit être < original';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Quantité
        TextFormField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantité disponible',
            hintText: 'Nombre de paniers disponibles',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La quantité est obligatoire';
            }
            final qty = int.tryParse(value);
            if (qty == null || qty <= 0) {
              return 'Quantité invalide';
            }
            return null;
          },
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
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'Définissez la fenêtre de temps pour récupérer l\'offre',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: _buildTimePickerField(
                label: 'Début',
                time: _pickupStartTime,
                onTap: () => _selectTime(true),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTimePickerField(
                label: 'Fin',
                time: _pickupEndTime,
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required DateTime? time,
    required VoidCallback onTap,
  }) {
    final displayTime = time != null
        ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        : 'Sélectionner';

    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time),
        ),
        child: Text(displayTime, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }

  Widget _buildDietarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options diététiques',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),

        // Options diététiques
        CheckboxListTile(
          title: const Text('Végétarien'),
          value: _isVegetarian,
          onChanged: (value) {
            setState(() {
              _isVegetarian = value ?? false;
              if (!_isVegetarian) {
                _isVegan = false;
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Vegan'),
          value: _isVegan,
          onChanged: (value) {
            setState(() {
              _isVegan = value ?? false;
              if (_isVegan) {
                _isVegetarian = true;
              }
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Halal'),
          value: _isHalal,
          onChanged: (value) {
            setState(() {
              _isHalal = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
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
      'Sésame',
      'Sulfites',
      'Lupin',
      'Mollusques',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergènes',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'Sélectionnez les allergènes présents',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAllergens.add(allergen);
                  } else {
                    _selectedAllergens.remove(allergen);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: _isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Publier l\'offre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  // Méthodes utilitaires

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final now = DateTime.now();
    final initialTime = TimeOfDay.fromDateTime(
      isStartTime
          ? (_pickupStartTime ?? now.add(const Duration(hours: 1)))
          : (_pickupEndTime ?? now.add(const Duration(hours: 2))),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      setState(() {
        if (isStartTime) {
          _pickupStartTime = selectedDateTime;
          // Ajuster automatiquement l'heure de fin si nécessaire
          if (_pickupEndTime == null ||
              _pickupEndTime!.isBefore(selectedDateTime)) {
            _pickupEndTime = selectedDateTime.add(const Duration(hours: 1));
          }
        } else {
          _pickupEndTime = selectedDateTime;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    // Validation du formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validation des horaires
    if (_pickupStartTime == null || _pickupEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner les horaires de collecte'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validation au moins une image
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins une photo'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Upload des images et création de l'offre
      final request = CreateOfferRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        category: _selectedCategory,
        originalPrice: _isFree
            ? 0.0
            : double.parse(_originalPriceController.text),
        discountedPrice: _isFree
            ? 0.0
            : double.parse(_discountedPriceController.text),
        quantity: int.parse(_quantityController.text),
        pickupStartTime: _pickupStartTime!,
        pickupEndTime: _pickupEndTime!,
        images: [], // TODO: URLs après upload
        allergens: _selectedAllergens,
        isVegetarian: _isVegetarian,
        isVegan: _isVegan,
        isHalal: _isHalal,
      );

      final result = await ref.read(createOfferProvider(request).future);

      result.fold((failure) => context.showError(failure), (offer) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offre créée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true);
      });
    } catch (e) {
      if (mounted) {
        context.showError(MerchantErrorHandler.handleError(e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _getOfferTypeLabel(OfferType type) {
    switch (type) {
      case OfferType.panier:
        return 'Panier surprise';
      case OfferType.plat:
        return 'Plat spécifique';
      case OfferType.boulangerie:
        return 'Boulangerie';
      case OfferType.fruits:
        return 'Fruits & légumes';
      case OfferType.epicerie:
        return 'Épicerie';
      case OfferType.autre:
        return 'Autre';
    }
  }

  String _getCategoryLabel(FoodCategory category) {
    switch (category) {
      case FoodCategory.petitDejeuner:
        return 'Petit-déjeuner';
      case FoodCategory.dejeuner:
        return 'Déjeuner';
      case FoodCategory.diner:
        return 'Dîner';
      case FoodCategory.snack:
        return 'Snack';
      case FoodCategory.dessert:
        return 'Dessert';
      case FoodCategory.boisson:
        return 'Boisson';
      case FoodCategory.boulangerie:
        return 'Boulangerie';
      case FoodCategory.fruitLegume:
        return 'Fruits/Légumes';
      case FoodCategory.epicerie:
        return 'Épicerie';
      case FoodCategory.autre:
        return 'Autre';
    }
  }
}
