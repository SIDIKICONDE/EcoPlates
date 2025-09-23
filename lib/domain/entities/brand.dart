/// Entité Brand pour représenter les grandes enseignes partenaires
class Brand {
  final String id;
  final String name;
  final String logoUrl;
  final String category;
  final int totalStores;
  final int activeOffers;
  final double averageDiscount;
  final String description;
  final bool isPremium;
  final bool isNew;
  final String? tagline;
  final String primaryColor;
  final String? backgroundColor;
  final List<String>? tags;
  final DateTime? partnerSince;

  const Brand({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.category,
    required this.totalStores,
    required this.activeOffers,
    required this.averageDiscount,
    required this.description,
    this.isPremium = false,
    this.isNew = false,
    this.tagline,
    required this.primaryColor,
    this.backgroundColor,
    this.tags,
    this.partnerSince,
  });

  /// Créé une copie de la marque avec des champs modifiés
  Brand copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? category,
    int? totalStores,
    int? activeOffers,
    double? averageDiscount,
    String? description,
    bool? isPremium,
    bool? isNew,
    String? tagline,
    String? primaryColor,
    String? backgroundColor,
    List<String>? tags,
    DateTime? partnerSince,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      category: category ?? this.category,
      totalStores: totalStores ?? this.totalStores,
      activeOffers: activeOffers ?? this.activeOffers,
      averageDiscount: averageDiscount ?? this.averageDiscount,
      description: description ?? this.description,
      isPremium: isPremium ?? this.isPremium,
      isNew: isNew ?? this.isNew,
      tagline: tagline ?? this.tagline,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      tags: tags ?? this.tags,
      partnerSince: partnerSince ?? this.partnerSince,
    );
  }

  /// Calcule la popularité de l'enseigne basée sur plusieurs critères
  double get popularityScore {
    double score = 0;

    // Plus de boutiques = plus populaire
    score += (totalStores / 100) * 30; // Max 30 points

    // Plus d'offres actives = plus populaire
    score += (activeOffers / 50) * 30; // Max 30 points

    // Meilleure réduction moyenne = plus populaire
    score += averageDiscount * 0.4; // Max 40 points (pour 100% de réduction)

    // Bonus pour les marques premium
    if (isPremium) score += 10;

    // Bonus pour les nouvelles marques
    if (isNew) score += 5;

    return score.clamp(0, 100);
  }

  /// Vérifie si l'enseigne a des offres disponibles
  bool get hasActiveOffers => activeOffers > 0;

  /// Formatte le nombre de boutiques pour l'affichage
  String get formattedStoresCount {
    if (totalStores >= 1000) {
      return '${(totalStores / 1000).toStringAsFixed(1)}k boutiques';
    }
    return '$totalStores boutiques';
  }

  /// Formatte le nombre d'offres pour l'affichage
  String get formattedOffersCount {
    if (activeOffers == 0) return 'Pas d\'offres';
    if (activeOffers == 1) return '1 offre';
    return '$activeOffers offres';
  }
}
