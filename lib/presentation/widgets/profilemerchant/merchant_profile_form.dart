import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/merchant_enums.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../data/services/merchant_profile_service.dart';
import '../../../domain/entities/merchant_profile.dart';

/// Formulaire d'édition du profil merchant
///
/// Permet de modifier toutes les informations du profil
/// avec validation selon les directives EcoPlates
class MerchantProfileForm extends ConsumerStatefulWidget {
  const MerchantProfileForm({
    required this.profile,
    super.key,
    this.onSaved,
  });

  final MerchantProfile profile;
  final VoidCallback? onSaved;

  @override
  ConsumerState<MerchantProfileForm> createState() =>
      _MerchantProfileFormState();
}

class _MerchantProfileFormState extends ConsumerState<MerchantProfileForm> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _streetController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _cityController;
  late final TextEditingController _complementController;

  late MerchantCategory _selectedCategory;
  late Map<WeekDay, OpeningHours> _openingHours;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    // Initialiser les contrôleurs avec les valeurs actuelles
    _nameController = TextEditingController(text: widget.profile.name);
    _descriptionController = TextEditingController(
      text: widget.profile.description ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
    _emailController = TextEditingController(text: widget.profile.email ?? '');

    final address = widget.profile.address;
    _streetController = TextEditingController(text: address?.street ?? '');
    _postalCodeController = TextEditingController(
      text: address?.postalCode ?? '',
    );
    _cityController = TextEditingController(text: address?.city ?? '');
    _complementController = TextEditingController(
      text: address?.complement ?? '',
    );

    _selectedCategory = widget.profile.category;
    _openingHours = Map.from(widget.profile.openingHours);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
        children: [
          // Informations générales
          _buildSectionTitle(context, 'Informations générales', colors),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildNameField(),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildCategoryDropdown(colors),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildDescriptionField(),
          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Coordonnées
          _buildSectionTitle(context, 'Coordonnées', colors),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildPhoneField(),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildEmailField(),
          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Adresse
          _buildSectionTitle(context, 'Adresse', colors),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildStreetField(),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildPostalCodeField()),
              SizedBox(width: context.scaleMD_LG_XL_XXL),
              Expanded(flex: 2, child: _buildCityField()),
            ],
          ),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildComplementField(),
          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Horaires
          _buildSectionTitle(context, "Horaires d'ouverture", colors),
          SizedBox(height: context.scaleMD_LG_XL_XXL),

          _buildOpeningHoursSection(context, colors),
          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Boutons d'action
          _buildActionButtons(context, colors),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    ColorScheme colors,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
        fontWeight: EcoPlatesDesignTokens.typography.bold,
        color: colors.primary,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nom du commerce *',
        hintText: 'Ex: Boulangerie du Centre',
        prefixIcon: Icon(Icons.store),
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
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildCategoryDropdown(ColorScheme colors) {
    return DropdownButtonFormField<MerchantCategory>(
      initialValue: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Catégorie *',
        prefixIcon: Icon(Icons.category),
      ),
      items: MerchantCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Icon(
                _getIconForCategory(category),
                size: EcoPlatesDesignTokens.size.indicator(context),
              ),
              SizedBox(width: context.scaleXXS_XS_SM_MD),
              Text(category.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Décrivez votre commerce en quelques mots',
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
      maxLength: 200,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Téléphone',
        hintText: '06 12 34 56 78',
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _PhoneNumberFormatter(),
      ],
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final cleaned = value.replaceAll(RegExp(r'\D'), '');
          if (cleaned.length != 10) {
            return 'Numéro invalide';
          }
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'contact@moncommerce.fr',
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Email invalide';
          }
        }
        return null;
      },
    );
  }

  Widget _buildStreetField() {
    return TextFormField(
      controller: _streetController,
      decoration: const InputDecoration(
        labelText: 'Adresse',
        hintText: '123 rue de la Paix',
        prefixIcon: Icon(Icons.location_on),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildPostalCodeField() {
    return TextFormField(
      controller: _postalCodeController,
      decoration: const InputDecoration(
        labelText: 'Code postal',
        hintText: '75001',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length != 5) {
          return 'Code postal invalide';
        }
        return null;
      },
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      decoration: const InputDecoration(
        labelText: 'Ville',
        hintText: 'Paris',
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildComplementField() {
    return TextFormField(
      controller: _complementController,
      decoration: const InputDecoration(
        labelText: "Complément d'adresse",
        hintText: 'Bâtiment A, 2ème étage',
        prefixIcon: Icon(Icons.more_horiz),
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildOpeningHoursSection(BuildContext context, ColorScheme colors) {
    return Column(
      children: WeekDay.sortedDays.map((day) {
        final hours = _openingHours[day];
        final isClosed = hours?.isClosed ?? true;

        return Card(
          margin: EdgeInsets.only(bottom: context.scaleXXS_XS_SM_MD),
          child: ExpansionTile(
            title: Text(day.displayName),
            subtitle: Text(
              isClosed ? 'Fermé' : hours?.displayFormat ?? 'Non défini',
              style: TextStyle(
                color: isClosed ? colors.error : Colors.green,
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
              ),
            ),
            trailing: Switch(
              value: !isClosed,
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _openingHours[day] = const OpeningHours(
                      openTime: '09:00',
                      closeTime: '19:00',
                    );
                  } else {
                    _openingHours[day] = const OpeningHours.closed();
                  }
                });
              },
            ),
            children: [
              if (!isClosed)
                Padding(
                  padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
                  child: _buildDayHoursEditor(context, day, hours!),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayHoursEditor(
    BuildContext context,
    WeekDay day,
    OpeningHours hours,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _TimePickerField(
                widgetContext: context,
                label: 'Ouverture',
                initialTime: hours.openTime,
                onChanged: (time) {
                  setState(() {
                    _openingHours[day] = hours.copyWith(openTime: time);
                  });
                },
              ),
            ),
            SizedBox(width: context.scaleMD_LG_XL_XXL),
            Expanded(
              child: _TimePickerField(
                widgetContext: context,
                label: 'Fermeture',
                initialTime: hours.closeTime,
                onChanged: (time) {
                  setState(() {
                    _openingHours[day] = hours.copyWith(closeTime: time);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isSaving ? null : () => context.pop(),
          child: const Text('Annuler'),
        ),
        SizedBox(width: context.scaleMD_LG_XL_XXL),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
          child: _isSaving
              ? SizedBox(
                  width: EcoPlatesDesignTokens.size.indicator(context),
                  height: EcoPlatesDesignTokens.size.indicator(context),
                  child: CircularProgressIndicator(
                    strokeWidth: EcoPlatesDesignTokens
                        .layout
                        .loadingIndicatorStrokeWidth,
                  ),
                )
              : const Text('Enregistrer'),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Créer l'adresse si au moins une info est présente
      MerchantAddress? address;
      if (_streetController.text.isNotEmpty ||
          _postalCodeController.text.isNotEmpty ||
          _cityController.text.isNotEmpty) {
        address = MerchantAddress(
          street: _streetController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          city: _cityController.text.trim(),
          complement: _complementController.text.trim().isEmpty
              ? null
              : _complementController.text.trim(),
        );
      }

      // Créer le profil mis à jour
      final updatedProfile = widget.profile.copyWith(
        name: _nameController.text.trim(),
        category: _selectedCategory,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.replaceAll(' ', ''),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        address: address,
        openingHours: _openingHours,
      );

      // Sauvegarder via le service
      await ref
          .read(merchantProfileProvider.notifier)
          .updateProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSaved?.call();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  IconData _getIconForCategory(MerchantCategory category) {
    switch (category) {
      case MerchantCategory.bakery:
        return Icons.bakery_dining;
      case MerchantCategory.restaurant:
        return Icons.restaurant;
      case MerchantCategory.grocery:
        return Icons.shopping_basket;
      case MerchantCategory.cafe:
        return Icons.coffee;
      case MerchantCategory.supermarket:
        return Icons.store;
      case MerchantCategory.butcher:
        return Icons.restaurant_menu;
      case MerchantCategory.fishmonger:
        return Icons.set_meal;
      case MerchantCategory.delicatessen:
        return Icons.lunch_dining;
      case MerchantCategory.farmShop:
        return Icons.agriculture;
      case MerchantCategory.other:
        return Icons.storefront;
    }
  }
}

/// Widget pour sélectionner une heure
class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.widgetContext,
    required this.label,
    required this.initialTime,
    required this.onChanged,
  });

  final BuildContext widgetContext;
  final String label;
  final String initialTime;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final parts = initialTime.split(':');
        final initialTimeOfDay = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );

        final time = await showTimePicker(
          context: context,
          initialTime: initialTimeOfDay,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );

        if (time != null) {
          final formatted =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          onChanged(formatted);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.access_time),
        ),
        child: Text(initialTime),
      ),
    );
  }
}

/// Formateur pour les numéros de téléphone
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (var i = 0; i < newText.length && i < 10; i++) {
      if (i % 2 == 0 && i > 0) {
        buffer.write(' ');
      }
      buffer.write(newText[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
