import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/consumer/filters_provider.dart';

/// Bottom sheet pour configurer les filtres d'offres
class FiltersBottomSheet extends ConsumerStatefulWidget {
  const FiltersBottomSheet({super.key});

  @override
  ConsumerState<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends ConsumerState<FiltersBottomSheet> {
  late TextEditingController _maxPriceController;
  
  @override
  void initState() {
    super.initState();
    final filters = ref.read(filtersProvider);
    _maxPriceController = TextEditingController(
      text: filters.maxPrice?.toStringAsFixed(2) ?? '',
    );
  }
  
  @override
  void dispose() {
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filtersProvider);
    final filtersNotifier = ref.read(filtersProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header avec titre et actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filtres',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (filters.hasActiveFilters)
                          Text(
                            '${filters.activeFiltersCount} filtre(s) actif(s)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: filters.hasActiveFilters
                      ? () => filtersNotifier.resetFilters()
                      : null,
                  child: const Text('Réinitialiser'),
                ),
              ],
            ),
          ),

          // Corps avec les filtres
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Présets rapides
                  _buildSectionTitle('Filtres rapides'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PresetChip(
                        label: 'Gratuit',
                        icon: Icons.money_off,
                        isActive: filters.isFreeOnly,
                        onTap: () => filtersNotifier.applyPreset(FilterPreset.freeOnly),
                      ),
                      _PresetChip(
                        label: 'Végétarien',
                        icon: Icons.eco,
                        isActive: filters.dietaryPreferences.contains('vegetarian'),
                        onTap: () => filtersNotifier.applyPreset(FilterPreset.vegetarian),
                      ),
                      _PresetChip(
                        label: 'Boulangerie',
                        icon: Icons.bakery_dining,
                        isActive: filters.selectedCategories.contains(FoodCategory.boulangerie),
                        onTap: () => filtersNotifier.applyPreset(FilterPreset.bakery),
                      ),
                      _PresetChip(
                        label: 'Dîner',
                        icon: Icons.dinner_dining,
                        isActive: filters.selectedCategories.contains(FoodCategory.diner),
                        onTap: () => filtersNotifier.applyPreset(FilterPreset.dinner),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Filtres de prix
                  _buildSectionTitle('Prix'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Offres gratuites uniquement'),
                    subtitle: const Text('Afficher seulement les offres à 0€'),
                    value: filters.isFreeOnly,
                    activeThumbColor: Theme.of(context).primaryColor,
                    onChanged: (_) => filtersNotifier.toggleFreeOnly(),
                  ),
                  if (!filters.isFreeOnly) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _maxPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Prix maximum (€)',
                                prefixIcon: const Icon(Icons.euro),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: _maxPriceController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _maxPriceController.clear();
                                          filtersNotifier.setMaxPrice(null);
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                filtersNotifier.setMaxPrice(price);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Distance
                  _buildSectionTitle('Distance'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('À proximité uniquement'),
                    subtitle: Text('Dans un rayon de ${filters.maxDistance.toStringAsFixed(1)} km'),
                    value: filters.isNearbyOnly,
                    activeThumbColor: Theme.of(context).primaryColor,
                    onChanged: (_) => filtersNotifier.toggleNearbyOnly(),
                  ),
                  if (filters.isNearbyOnly) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distance maximum: ${filters.maxDistance.toStringAsFixed(1)} km',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Slider(
                            value: filters.maxDistance,
                            min: 0.5,
                            max: 20.0,
                            divisions: 39,
                            activeColor: Theme.of(context).primaryColor,
                            label: '${filters.maxDistance.toStringAsFixed(1)} km',
                            onChanged: (value) {
                              filtersNotifier.setMaxDistance(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Catégories
                  _buildSectionTitle('Catégories'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: FoodCategory.values.map((category) {
                      final isSelected = filters.selectedCategories.contains(category);
                      return FilterChip(
                        label: Text(_getCategoryLabel(category)),
                        selected: isSelected,
                        onSelected: (_) => filtersNotifier.toggleCategory(category),
                        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Régimes alimentaires
                  _buildSectionTitle('Régimes alimentaires'),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('Végétarien'),
                        value: filters.dietaryPreferences.contains('vegetarian'),
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (_) => filtersNotifier.toggleDietaryPreference('vegetarian'),
                      ),
                      CheckboxListTile(
                        title: const Text('Vegan'),
                        value: filters.dietaryPreferences.contains('vegan'),
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (_) => filtersNotifier.toggleDietaryPreference('vegan'),
                      ),
                      CheckboxListTile(
                        title: const Text('Halal'),
                        value: filters.dietaryPreferences.contains('halal'),
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (_) => filtersNotifier.toggleDietaryPreference('halal'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Horaires de collecte
                  _buildSectionTitle('Horaires de collecte'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          label: 'De',
                          time: filters.pickupTimeStart,
                          onTimeSelected: (time) {
                            filtersNotifier.setPickupTimeStart(time);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TimePickerField(
                          label: 'À',
                          time: filters.pickupTimeEnd,
                          onTimeSelected: (time) {
                            filtersNotifier.setPickupTimeEnd(time);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tri
                  _buildSectionTitle('Trier par'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SortOption>(
                        value: filters.sortBy,
                        isExpanded: true,
                        onChanged: (option) {
                          if (option != null) {
                            filtersNotifier.setSortOption(option);
                          }
                        },
                        items: SortOption.values.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option.label),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Espace pour le bouton flottant
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
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
        return 'Fruits & Légumes';
      case FoodCategory.epicerie:
        return 'Épicerie';
      case FoodCategory.autre:
        return 'Autre';
    }
  }
}

/// Chip pour les présets de filtres
class _PresetChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade700,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Champ de sélection d'heure
class _TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final Function(TimeOfDay?) onTimeSelected;

  const _TimePickerField({
    required this.label,
    required this.time,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (selectedTime != null) {
          onTimeSelected(selectedTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    time != null
                        ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
                        : '--:--',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (time != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => onTimeSelected(null),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}