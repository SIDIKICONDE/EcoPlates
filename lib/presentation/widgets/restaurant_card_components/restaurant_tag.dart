import 'package:flutter/material.dart';

/// Widget pour afficher un tag avec icône
class RestaurantTag extends StatelessWidget {
  final String tag;
  
  const RestaurantTag({
    super.key,
    required this.tag,
  });
  
  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getTagStyle(tag);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            tag,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  (IconData, Color) _getTagStyle(String tag) {
    switch (tag.toLowerCase()) {
      case 'végétarien':
      case 'vegan':
      case 'végé':
        return (Icons.eco, Colors.green);
      case 'bio':
        return (Icons.grass, Colors.lightGreen);
      case 'halal':
        return (Icons.verified, Colors.teal);
      case 'sans gluten':
        return (Icons.grain_outlined, Colors.orange);
      default:
        return (Icons.label, Colors.blue);
    }
  }
}