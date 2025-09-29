// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'EcoPlates';

  @override
  String get home => 'Accueil';

  @override
  String get search => 'Rechercher';

  @override
  String get favorites => 'Favoris';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get welcomeMessage => 'Bienvenue sur EcoPlates';

  @override
  String get searchPlaceholder => 'Rechercher un restaurant ou un plat';

  @override
  String get nearYou => 'Près de vous';

  @override
  String get popularDishes => 'Plats populaires';

  @override
  String get categories => 'Catégories';

  @override
  String get offers => 'Offres';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get cuisine => 'Cuisine';

  @override
  String get rating => 'Note';

  @override
  String get reviews => 'Avis';

  @override
  String get distance => 'Distance';

  @override
  String get deliveryTime => 'Temps de livraison';

  @override
  String get minimumOrder => 'Commande minimum';

  @override
  String get openNow => 'Ouvert maintenant';

  @override
  String get closedNow => 'Fermé';

  @override
  String opensAt(String time) {
    return 'Ouvre à $time';
  }

  @override
  String discount(int percentage) {
    return '$percentage% de réduction';
  }

  @override
  String get freeDelivery => 'Livraison gratuite';

  @override
  String get newRestaurant => 'Nouveau';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur s\'est produite';

  @override
  String get filterBy => 'Filtrer par';

  @override
  String get sortBy => 'Trier par';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get cancel => 'Annuler';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get signupTitle => 'Inscription';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get login => 'Se connecter';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get profileName => 'Nom';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Téléphone';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get orderHistory => 'Historique des commandes';

  @override
  String get addresses => 'Mes adresses';

  @override
  String get paymentMethods => 'Moyens de paiement';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Aide';

  @override
  String get about => 'À propos';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String get viewCart => 'Voir le panier';

  @override
  String get checkout => 'Commander';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get deliveryFee => 'Frais de livraison';

  @override
  String get tax => 'Taxes';

  @override
  String get emptyCart => 'Votre panier est vide';

  @override
  String get emptyFavorites => 'Vous n\'avez pas encore de favoris';

  @override
  String get confirmOrder => 'Confirmer la commande';

  @override
  String get orderConfirmed => 'Commande confirmée';

  @override
  String get trackOrder => 'Suivre la commande';

  @override
  String get rateExperience => 'Noter votre expérience';

  @override
  String get writeReview => 'Écrire un avis';

  @override
  String get submitReview => 'Envoyer l\'avis';

  @override
  String get merchantProfileTitle => 'Profil Marchand';

  @override
  String get merchantId => 'ID Marchand';

  @override
  String get businessName => 'Nom du commerce';

  @override
  String get description => 'Description';

  @override
  String get contactInfo => 'Informations de contact';

  @override
  String get address => 'Adresse';

  @override
  String get phone => 'Téléphone';

  @override
  String get openingHours => 'Horaires d\'ouverture';

  @override
  String get category => 'Catégorie';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get viewOnMap => 'Voir sur la carte';

  @override
  String get callBusiness => 'Appeler';

  @override
  String get emailBusiness => 'Email';

  @override
  String get closed => 'Fermé';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get bakery => 'Boulangerie';

  @override
  String get grocery => 'Épicerie';

  @override
  String get cafe => 'Café';

  @override
  String get supermarket => 'Supermarché';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get profileUpdateError => 'Échec de la mise à jour du profil';

  @override
  String get offerFormPreferencesVegetarian => 'Végétarien';

  @override
  String get offerFormPreferencesVegan => 'Végan';

  @override
  String get offerFormPreferencesHalal => 'Halal';

  @override
  String get offerFormPreferencesAllergens => 'Allergènes';

  @override
  String get offerFormPreferencesCustomAllergen => 'Allergène personnalisé';

  @override
  String get offerFormPreferencesCustomAllergenHint =>
      'Ex: Sulfites, colorants...';

  @override
  String get offerFormPreferencesDeclaredAllergens => 'Allergènes déclarés';

  @override
  String get offerFormPreferencesImportantInfo => 'Informations importantes';

  @override
  String get offerFormPreferencesAllergenInfoText =>
      'Déclaration optionnelle mais recommandée pour la sécurité des clients allergiques.';

  @override
  String get offerFormPreferencesFeatureToImplement =>
      'Fonctionnalité à implémenter';

  @override
  String get offerFormPageEditOffer => 'Modifier l\'offre';

  @override
  String get offerFormPageNewOffer => 'Nouvelle offre';

  @override
  String get offerFormPageSave => 'Enregistrer';

  @override
  String get offerFormPageSaving => 'Sauvegarde...';

  @override
  String offerFormPageSaveProgress(Object percentage) {
    return 'Sauvegarder ($percentage%)';
  }

  @override
  String get offerFormPageDelete => 'Supprimer';
}
