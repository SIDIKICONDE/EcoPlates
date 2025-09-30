import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service d'authentification utilisant Supabase Auth
class SupabaseAuthService {
  SupabaseAuthService._();
  static final SupabaseAuthService instance = SupabaseAuthService._();

  /// Instance de Supabase
  SupabaseClient get _supabase => Supabase.instance.client;

  /// Auth instance
  GoTrueClient get _auth => _supabase.auth;

  /// Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  /// Est connecté
  bool get isAuthenticated => currentUser != null;

  /// Stream d'état d'authentification
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  /// Stream de l'utilisateur actuel
  Stream<User?> get userChanges => authStateChanges.map((state) => state.session?.user);

  /// Inscription avec email et mot de passe
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String userType, // 'consumer' ou 'merchant'
    String? phone,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'user_type': userType,
          'phone_number': phone,
        },
      );

      if (response.user != null) {
        // Créer le profil utilisateur dans la table publique
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          fullName: fullName,
          userType: userType,
          phone: phone,
        );
      }

      return response;
    } catch (e) {
      debugPrint('Erreur inscription: $e');
      rethrow;
    }
  }

  /// Connexion avec email et mot de passe
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Erreur connexion: $e');
      rethrow;
    }
  }

  /// Connexion avec Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      return await _auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.ecoplates://login-callback',
        scopes: 'email profile',
      );
    } catch (e) {
      debugPrint('Erreur connexion Google: $e');
      rethrow;
    }
  }

  /// Connexion avec Apple
  Future<AuthResponse> signInWithApple() async {
    try {
      return await _auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.ecoplates://login-callback',
        scopes: 'email name',
      );
    } catch (e) {
      debugPrint('Erreur connexion Apple: $e');
      rethrow;
    }
  }

  /// Connexion avec numéro de téléphone
  Future<void> signInWithPhone({
    required String phone,
  }) async {
    try {
      await _auth.signInWithOtp(
        phone: phone,
      );
    } catch (e) {
      debugPrint('Erreur envoi OTP: $e');
      rethrow;
    }
  }

  /// Vérification du code OTP
  Future<AuthResponse> verifyOTP({
    required String phone,
    required String token,
  }) async {
    try {
      return await _auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: token,
      );
    } catch (e) {
      debugPrint('Erreur vérification OTP: $e');
      rethrow;
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Erreur déconnexion: $e');
      rethrow;
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.ecoplates://reset-password',
      );
    } catch (e) {
      debugPrint('Erreur réinitialisation mot de passe: $e');
      rethrow;
    }
  }

  /// Mise à jour du mot de passe
  Future<UserResponse> updatePassword({
    required String newPassword,
  }) async {
    try {
      return await _auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
    } catch (e) {
      debugPrint('Erreur mise à jour mot de passe: $e');
      rethrow;
    }
  }

  /// Mise à jour du profil utilisateur
  Future<UserResponse> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone_number'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      // Mettre à jour dans auth.users
      final response = await _auth.updateUser(
        UserAttributes(
          data: updates,
        ),
      );

      // Mettre à jour dans public.users
      if (currentUser != null) {
        await _supabase.from('users').update(updates).eq('id', currentUser!.id);
      }

      return response;
    } catch (e) {
      debugPrint('Erreur mise à jour profil: $e');
      rethrow;
    }
  }

  /// Supprimer le compte
  Future<void> deleteAccount() async {
    try {
      if (currentUser == null) return;

      // Supprimer d'abord les données liées
      await _supabase.from('users').delete().eq('id', currentUser!.id);

      // Puis supprimer le compte auth
      await _supabase.rpc('delete_user');
    } catch (e) {
      debugPrint('Erreur suppression compte: $e');
      rethrow;
    }
  }

  /// Rafraîchir la session
  Future<AuthResponse> refreshSession() async {
    try {
      return await _auth.refreshSession();
    } catch (e) {
      debugPrint('Erreur rafraîchissement session: $e');
      rethrow;
    }
  }

  /// Obtenir le token d'accès
  String? get accessToken => _auth.currentSession?.accessToken;

  /// Obtenir le token de rafraîchissement
  String? get refreshToken => _auth.currentSession?.refreshToken;

  /// Vérifier si le token est expiré
  bool get isTokenExpired {
    final session = _auth.currentSession;
    if (session == null) return true;
    
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return false;
    
    return DateTime.now().millisecondsSinceEpoch >= expiresAt * 1000;
  }

  /// Créer le profil utilisateur dans la table publique
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String fullName,
    required String userType,
    String? phone,
  }) async {
    try {
      await _supabase.from('users').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'user_type': userType,
        'phone_number': phone,
      });

      // Si c'est un marchand, créer aussi le profil marchand
      if (userType == 'merchant') {
        await _createMerchantProfile(userId: userId);
      }
    } catch (e) {
      debugPrint('Erreur création profil: $e');
      // Ne pas faire échouer l'inscription si le profil existe déjà
    }
  }

  /// Créer le profil marchand
  Future<void> _createMerchantProfile({
    required String userId,
  }) async {
    try {
      final merchantId = await _supabase
          .from('merchants')
          .insert({
            'user_id': userId,
            'business_name': 'Mon Commerce',
          })
          .select('id')
          .single();

      await _supabase.from('merchant_profiles').insert({
        'merchant_id': merchantId['id'],
      });
    } catch (e) {
      debugPrint('Erreur création profil marchand: $e');
    }
  }

  /// Obtenir le type d'utilisateur
  Future<String?> getUserType() async {
    try {
      if (currentUser == null) return null;

      final response = await _supabase
          .from('users')
          .select('user_type')
          .eq('id', currentUser!.id)
          .single();

      return response['user_type'] as String?;
    } catch (e) {
      debugPrint('Erreur récupération type utilisateur: $e');
      return null;
    }
  }

  /// Vérifier si l'utilisateur est un marchand
  Future<bool> isMerchant() async {
    final userType = await getUserType();
    return userType == 'merchant';
  }

  /// Vérifier si l'utilisateur est un consommateur
  Future<bool> isConsumer() async {
    final userType = await getUserType();
    return userType == 'consumer';
  }
}