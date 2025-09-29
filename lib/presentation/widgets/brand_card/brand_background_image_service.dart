/// Extension pour obtenir l'URL d'image de fond selon la catégorie de marque
extension BrandBackgroundImage on String {
  /// Retourne l'URL d'une image de fond selon la catégorie
  String get brandBackgroundImageUrl {
    switch (toLowerCase()) {
      case 'supermarché':
      case 'hypermarché':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=200&fit=crop&crop=center';
      case 'boulangerie':
        return 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=200&fit=crop&crop=center';
      case 'café':
        return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400&h=200&fit=crop&crop=center';
      case 'restaurant':
        return 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=200&fit=crop&crop=center';
      case 'surgelés':
        return 'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?w=400&h=200&fit=crop&crop=center';
      default:
        return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=200&fit=crop&crop=center';
    }
  }
}
