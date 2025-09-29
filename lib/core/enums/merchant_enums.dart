/// Énumérations pour les profils merchants EcoPlates
///
/// Définit les catégories de commerçants et les jours de la semaine
/// pour la gestion des horaires d'ouverture
library;

/// Catégories de commerçants disponibles dans EcoPlates
enum MerchantCategory {
  bakery('Boulangerie', 'bakery'),
  restaurant('Restaurant', 'restaurant'),
  grocery('Épicerie', 'grocery'),
  cafe('Café', 'cafe'),
  supermarket('Supermarché local', 'supermarket'),
  butcher('Boucherie', 'butcher'),
  fishmonger('Poissonnerie', 'fishmonger'),
  delicatessen('Traiteur', 'delicatessen'),
  farmShop('Magasin de ferme', 'farm_shop'),
  other('Autre', 'other');

  const MerchantCategory(this.displayName, this.key);
  
  /// Nom affiché à l'utilisateur
  final String displayName;
  
  /// Clé unique pour la base de données
  final String key;
  
  /// Obtenir une catégorie depuis sa clé
  static MerchantCategory fromKey(String key) {
    return MerchantCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => MerchantCategory.other,
    );
  }
}

/// Jours de la semaine pour les horaires d'ouverture
enum WeekDay {
  monday('Lundi', 1),
  tuesday('Mardi', 2),
  wednesday('Mercredi', 3),
  thursday('Jeudi', 4),
  friday('Vendredi', 5),
  saturday('Samedi', 6),
  sunday('Dimanche', 7);

  const WeekDay(this.displayName, this.order);
  
  /// Nom affiché à l'utilisateur
  final String displayName;
  
  /// Ordre d'affichage (1 = lundi, 7 = dimanche)
  final int order;
  
  /// Liste triée des jours
  static List<WeekDay> get sortedDays {
    return WeekDay.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
}

/// État d'ouverture d'un commerce
enum OpenStatus {
  open('Ouvert', 'open'),
  closed('Fermé', 'closed'),
  closingSoon('Ferme bientôt', 'closing_soon');

  const OpenStatus(this.displayName, this.key);
  
  final String displayName;
  final String key;
}
