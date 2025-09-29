import 'package:flutter/material.dart';

/// Widget pour afficher un tag avec icône
class RestaurantTag extends StatelessWidget {
  const RestaurantTag({required this.tag, super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getTagStyle(tag);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        border: Border.all(
          color: color.withValues(alpha: 0.16),
        ),  
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.0,
            color: color,
          ),
          SizedBox(width: 4.0),
          Text(
            tag,
            style: TextStyle(
              color: color,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
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
