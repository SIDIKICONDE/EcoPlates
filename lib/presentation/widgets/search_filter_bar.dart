import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Barre de recherche et filtres comme Too Good To Go
class SearchFilterBar extends ConsumerStatefulWidget {
  const SearchFilterBar({super.key});

  @override
  ConsumerState<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends ConsumerState<SearchFilterBar> {
  double _maxDistance = 5.0;
  double _maxPrice = 10.0;
  TimeOfDay? _pickupTimeStart;
  TimeOfDay? _pickupTimeEnd;

  final List<FilterCategory> _categories = [
    FilterCategory('Tout', Icons.apps, isSelected: true),
    FilterCategory('Boulangerie', Icons.bakery_dining),
    FilterCategory('Restaurant', Icons.restaurant),
    FilterCategory('Épicerie', Icons.shopping_basket),
    FilterCategory('Café', Icons.coffee),
    FilterCategory('Pizza', Icons.local_pizza),
    FilterCategory('Sushi', Icons.rice_bowl),
    FilterCategory('Végétarien', Icons.eco),
  ];

  final List<FilterTag> _tags = [
    FilterTag('Nouveau', Icons.new_releases),
    FilterTag('Top vendeur', Icons.star),
    FilterTag('Gratuit', Icons.volunteer_activism),
    FilterTag('< 3€', Icons.euro),
    FilterTag('Bio', Icons.spa),
    FilterTag('Local', Icons.location_on),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtres',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Réinitialiser'),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance
                  _buildSectionTitle('Distance'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _maxDistance,
                          min: 0.5,
                          max: 20,
                          divisions: 39,
                          activeColor: theme.primaryColor,
                          label: '${_maxDistance.toStringAsFixed(1)} km',
                          onChanged: (value) {
                            setState(() {
                              _maxDistance = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_maxDistance.toStringAsFixed(1)} km',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Prix maximum
                  _buildSectionTitle('Prix maximum'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _maxPrice,
                          min: 1,
                          max: 30,
                          divisions: 29,
                          activeColor: theme.primaryColor,
                          label: '${_maxPrice.toStringAsFixed(0)}€',
                          onChanged: (value) {
                            setState(() {
                              _maxPrice = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_maxPrice.toStringAsFixed(0)}€',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Catégories
                  _buildSectionTitle('Catégories'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      return FilterChip(
                        avatar: Icon(
                          category.icon,
                          size: 18,
                          color: category.isSelected
                              ? Colors.white
                              : theme.primaryColor,
                        ),
                        label: Text(category.name),
                        selected: category.isSelected,
                        selectedColor: theme.primaryColor,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: category.isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            // Si "Tout" est sélectionné, désélectionner les autres
                            if (category.name == 'Tout' && selected) {
                              for (var cat in _categories) {
                                cat.isSelected = cat.name == 'Tout';
                              }
                            } else {
                              // Désélectionner "Tout" si une autre catégorie est sélectionnée
                              if (selected) {
                                _categories
                                        .firstWhere((c) => c.name == 'Tout')
                                        .isSelected =
                                    false;
                              }
                              category.isSelected = selected;

                              // Si aucune catégorie n'est sélectionnée, sélectionner "Tout"
                              if (!_categories.any((c) => c.isSelected)) {
                                _categories
                                        .firstWhere((c) => c.name == 'Tout')
                                        .isSelected =
                                    true;
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  _buildSectionTitle('Filtres rapides'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tags.map((tag) {
                      return FilterChip(
                        avatar: Icon(
                          tag.icon,
                          size: 18,
                          color: tag.isSelected
                              ? Colors.white
                              : theme.primaryColor,
                        ),
                        label: Text(tag.name),
                        selected: tag.isSelected,
                        selectedColor: theme.primaryColor,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: tag.isSelected ? Colors.white : Colors.black87,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            tag.isSelected = selected;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Horaires de collecte
                  _buildSectionTitle('Horaires de collecte'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerButton(
                          context,
                          'De',
                          _pickupTimeStart,
                          (time) {
                            setState(() {
                              _pickupTimeStart = time;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimePickerButton(
                          context,
                          'À',
                          _pickupTimeEnd,
                          (time) {
                            setState(() {
                              _pickupTimeEnd = time;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Options supplémentaires
                  _buildSectionTitle('Options'),
                  const SizedBox(height: 12),
                  _buildSwitchOption(
                    'Uniquement les favoris',
                    Icons.favorite,
                    false,
                    (value) {},
                  ),
                  _buildSwitchOption(
                    'Nouveaux restaurants',
                    Icons.new_releases,
                    false,
                    (value) {},
                  ),
                  _buildSwitchOption(
                    'Avec parking',
                    Icons.local_parking,
                    false,
                    (value) {},
                  ),
                  _buildSwitchOption(
                    'Accessible PMR',
                    Icons.accessible,
                    false,
                    (value) {},
                  ),
                  const SizedBox(height: 80),
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
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTimePickerButton(
    BuildContext context,
    String label,
    TimeOfDay? time,
    Function(TimeOfDay?) onTimeSelected,
  ) {
    return InkWell(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        onTimeSelected(selectedTime);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            Text(
              time != null
                  ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                  : '--:--',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _maxDistance = 5.0;
      _maxPrice = 10.0;
      _pickupTimeStart = null;
      _pickupTimeEnd = null;

      // Réinitialiser les catégories
      for (var category in _categories) {
        category.isSelected = category.name == 'Tout';
      }

      // Réinitialiser les tags
      for (var tag in _tags) {
        tag.isSelected = false;
      }
    });
  }
}

class FilterCategory {
  final String name;
  final IconData icon;
  bool isSelected;

  FilterCategory(this.name, this.icon, {this.isSelected = false});
}

class FilterTag {
  final String name;
  final IconData icon;
  bool isSelected;

  FilterTag(this.name, this.icon, {this.isSelected = false});
}
