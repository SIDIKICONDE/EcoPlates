import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Le titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'EcoPlates'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @favorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favorites;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur EcoPlates'**
  String get welcomeMessage;

  /// No description provided for @searchPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un restaurant ou un plat'**
  String get searchPlaceholder;

  /// No description provided for @nearYou.
  ///
  /// In fr, this message translates to:
  /// **'Près de vous'**
  String get nearYou;

  /// No description provided for @popularDishes.
  ///
  /// In fr, this message translates to:
  /// **'Plats populaires'**
  String get popularDishes;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @offers.
  ///
  /// In fr, this message translates to:
  /// **'Offres'**
  String get offers;

  /// No description provided for @addToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get removeFromFavorites;

  /// No description provided for @restaurant.
  ///
  /// In fr, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @cuisine.
  ///
  /// In fr, this message translates to:
  /// **'Cuisine'**
  String get cuisine;

  /// No description provided for @rating.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get rating;

  /// No description provided for @reviews.
  ///
  /// In fr, this message translates to:
  /// **'Avis'**
  String get reviews;

  /// No description provided for @distance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @deliveryTime.
  ///
  /// In fr, this message translates to:
  /// **'Temps de livraison'**
  String get deliveryTime;

  /// No description provided for @minimumOrder.
  ///
  /// In fr, this message translates to:
  /// **'Commande minimum'**
  String get minimumOrder;

  /// No description provided for @openNow.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert maintenant'**
  String get openNow;

  /// No description provided for @closedNow.
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get closedNow;

  /// No description provided for @opensAt.
  ///
  /// In fr, this message translates to:
  /// **'Ouvre à {time}'**
  String opensAt(String time);

  /// No description provided for @discount.
  ///
  /// In fr, this message translates to:
  /// **'{percentage}% de réduction'**
  String discount(int percentage);

  /// No description provided for @freeDelivery.
  ///
  /// In fr, this message translates to:
  /// **'Livraison gratuite'**
  String get freeDelivery;

  /// No description provided for @newRestaurant.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get newRestaurant;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé'**
  String get noResults;

  /// No description provided for @tryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get tryAgain;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite'**
  String get error;

  /// No description provided for @filterBy.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par'**
  String get filterBy;

  /// No description provided for @sortBy.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get sortBy;

  /// No description provided for @apply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get reset;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @signupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get signupTitle;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get signup;

  /// No description provided for @orContinueWith.
  ///
  /// In fr, this message translates to:
  /// **'Ou continuer avec'**
  String get orContinueWith;

  /// No description provided for @profileName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get profilePhone;

  /// No description provided for @editProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get editProfile;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @orderHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des commandes'**
  String get orderHistory;

  /// No description provided for @addresses.
  ///
  /// In fr, this message translates to:
  /// **'Mes adresses'**
  String get addresses;

  /// No description provided for @paymentMethods.
  ///
  /// In fr, this message translates to:
  /// **'Moyens de paiement'**
  String get paymentMethods;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In fr, this message translates to:
  /// **'Aide'**
  String get help;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @addToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au panier'**
  String get addToCart;

  /// No description provided for @viewCart.
  ///
  /// In fr, this message translates to:
  /// **'Voir le panier'**
  String get viewCart;

  /// No description provided for @checkout.
  ///
  /// In fr, this message translates to:
  /// **'Commander'**
  String get checkout;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In fr, this message translates to:
  /// **'Frais de livraison'**
  String get deliveryFee;

  /// No description provided for @tax.
  ///
  /// In fr, this message translates to:
  /// **'Taxes'**
  String get tax;

  /// No description provided for @emptyCart.
  ///
  /// In fr, this message translates to:
  /// **'Votre panier est vide'**
  String get emptyCart;

  /// No description provided for @emptyFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore de favoris'**
  String get emptyFavorites;

  /// No description provided for @confirmOrder.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la commande'**
  String get confirmOrder;

  /// No description provided for @orderConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Commande confirmée'**
  String get orderConfirmed;

  /// No description provided for @trackOrder.
  ///
  /// In fr, this message translates to:
  /// **'Suivre la commande'**
  String get trackOrder;

  /// No description provided for @rateExperience.
  ///
  /// In fr, this message translates to:
  /// **'Noter votre expérience'**
  String get rateExperience;

  /// No description provided for @writeReview.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un avis'**
  String get writeReview;

  /// No description provided for @submitReview.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer l\'avis'**
  String get submitReview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
