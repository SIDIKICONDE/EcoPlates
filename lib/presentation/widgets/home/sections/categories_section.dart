import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider pour la catégorie sélectionnée
final selectedCategoryProvider = StateProvider<String>((ref) => 'Tous');

/// Section des catégories avec slider horizontal
class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    
    // Liste des catégories
    final categories = [
      'Tous',
      'Repas',
      'Boulangerie',
      'Café',
      'Épicerie',
      'Fruits & Légumes',
      'Surgelés',
      'Boissons',
      'Snacks',
      'Desserts',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slider horizontal de catégories
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state = category;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected 
                                ? Colors.white
                                : Colors.grey.shade800,
                              fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ),
        ),
        
        const SizedBox(height: 5),
      ],
    );
  }
}
