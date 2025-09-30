import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/services/supabase_auth_service.dart';
import '../../../core/themes/deep_theme.dart';
import '../../widgets/auth/auth_form_widgets.dart';

class ConsumerSignupPage extends ConsumerStatefulWidget {
  const ConsumerSignupPage({super.key});

  @override
  ConsumerState<ConsumerSignupPage> createState() => _ConsumerSignupPageState();
}

class _ConsumerSignupPageState extends ConsumerState<ConsumerSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptMarketing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      _showError('Veuillez accepter les conditions d\'utilisation');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = SupabaseAuthService.instance;
      
      final response = await authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        userType: 'consumer',
        phone: _phoneController.text.trim(),
      );

      if (response.user != null && mounted) {
        _showSuccess('Inscription réussie ! Vérifiez votre email.');
        context.go('/home');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    setState(() => _isLoading = true);
    
    try {
      final authService = SupabaseAuthService.instance;
      await authService.signInWithGoogle();
      
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: DeepColorTokens.error,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: DeepColorTokens.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeepColorTokens.surface,
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: (_) => _buildMobileLayout(),
          tablet: (_) => _buildTabletLayout(),
          desktop: (_) => _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      child: _buildForm(),
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(context.horizontalSpacing * 2),
        child: SingleChildScrollView(
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Panneau gauche avec image
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DeepColorTokens.success,
                  DeepColorTokens.success.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: context.verticalSpacing * 2),
                  Text(
                    'Rejoignez la communauté',
                    style: TextStyle(
                      fontSize: FontSizes.headlineLarge.getSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.verticalSpacing),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.horizontalSpacing * 3),
                    child: Text(
                      'Des milliers d\'offres vous attendent pour réduire le gaspillage alimentaire',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: FontSizes.bodyLarge.getSize(context),
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Panneau droit avec formulaire
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(context.horizontalSpacing * 2),
              child: SingleChildScrollView(
                child: _buildForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          AuthPageHeader(
            title: 'Créer un compte',
            subtitle: 'Inscrivez-vous pour commencer à sauver de la nourriture',
            showBackButton: true,
          ),
          
          SizedBox(height: context.verticalSpacing * 3),
          
          // Nom complet
          AuthTextField(
            controller: _nameController,
            label: 'Nom complet',
            prefixIcon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le nom est requis';
              }
              if (value.length < 2) {
                return 'Le nom doit contenir au moins 2 caractères';
              }
              return null;
            },
          ),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Email
          AuthTextField(
            controller: _emailController,
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'L\'email est requis';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Téléphone
          AuthTextField(
            controller: _phoneController,
            label: 'Téléphone (optionnel)',
            hint: '+33 6 12 34 56 78',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d\s\+\-\(\)]')),
            ],
          ),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Mot de passe
          AuthTextField(
            controller: _passwordController,
            label: 'Mot de passe',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Le mot de passe est requis';
              }
              if (value.length < 8) {
                return 'Le mot de passe doit contenir au moins 8 caractères';
              }
              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                return 'Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre';
              }
              return null;
            },
          ),
          
          SizedBox(height: context.verticalSpacing * 1.5),
          
          // Confirmation mot de passe
          AuthTextField(
            controller: _confirmPasswordController,
            label: 'Confirmer le mot de passe',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer votre mot de passe';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          
          SizedBox(height: context.verticalSpacing * 2),
          
          // Conditions d'utilisation
          AuthCheckbox(
            value: _acceptTerms,
            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
            label: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: FontSizes.bodySmall.getSize(context),
                  color: DeepColorTokens.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'J\'accepte les '),
                  TextSpan(
                    text: 'conditions d\'utilisation',
                    style: TextStyle(
                      color: DeepColorTokens.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' et la '),
                  TextSpan(
                    text: 'politique de confidentialité',
                    style: TextStyle(
                      color: DeepColorTokens.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Newsletter
          AuthCheckbox(
            value: _acceptMarketing,
            onChanged: (value) => setState(() => _acceptMarketing = value ?? false),
            label: Text(
              'Je souhaite recevoir des offres et promotions par email',
              style: TextStyle(
                fontSize: FontSizes.bodySmall.getSize(context),
                color: DeepColorTokens.textSecondary,
              ),
            ),
          ),
          
          SizedBox(height: context.verticalSpacing * 2),
          
          // Bouton inscription
          AuthPrimaryButton(
            text: 'S\'inscrire',
            onPressed: _handleSignup,
            isLoading: _isLoading,
          ),
          
          // Divider
          const AuthDivider(text: 'ou continuer avec'),
          
          // Social auth
          Row(
            children: [
              Expanded(
                child: SocialAuthButton(
                  text: 'Google',
                  icon: Icons.g_mobiledata_rounded,
                  onPressed: _isLoading ? null : _handleGoogleSignup,
                ),
              ),
              if (Theme.of(context).platform == TargetPlatform.iOS) ...[
                SizedBox(width: context.horizontalSpacing),
                Expanded(
                  child: SocialAuthButton(
                    text: 'Apple',
                    icon: Icons.apple_rounded,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: _isLoading ? null : () {
                      // Implémenter Apple Sign In
                    },
                  ),
                ),
              ],
            ],
          ),
          
          SizedBox(height: context.verticalSpacing * 2),
          
          // Lien connexion
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Déjà inscrit ?',
                style: TextStyle(
                  fontSize: FontSizes.bodyMedium.getSize(context),
                  color: DeepColorTokens.textSecondary,
                ),
              ),
              AuthSecondaryButton(
                text: 'Se connecter',
                onPressed: () => context.push('/auth/login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}