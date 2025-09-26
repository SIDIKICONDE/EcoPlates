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
}
