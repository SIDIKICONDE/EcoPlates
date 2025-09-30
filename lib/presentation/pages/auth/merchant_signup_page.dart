import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/services/supabase_auth_service.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../widgets/auth/auth_form_widgets.dart';

class MerchantSignupPage extends ConsumerStatefulWidget {
  const MerchantSignupPage({super.key});

  @override
  ConsumerState<MerchantSignupPage> createState() => _MerchantSignupPageState();
}

class _MerchantSignupPageState extends ConsumerState<MerchantSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Étape 1 - Informations personnelles
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Étape 2 - Informations commerciales
  final _businessNameController = TextEditingController();
  final _businessRegistrationController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  int _currentStep = 0;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String? _selectedBusinessType;

  final List<String> _businessTypes = [
    'Restaurant',
    'Boulangerie',
    'Pâtisserie',
    'Café',
    'Supermarché',
    'Épicerie',
    'Traiteur',
    'Food Truck',
    'Autre',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    _businessRegistrationController.dispose();
    _taxIdController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Valider l'étape 1
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // Soumettre le formulaire
      _handleSignup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep = 0);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
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

      // Créer le compte utilisateur
      final response = await authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        userType: 'merchant',
        phone: _phoneController.text.trim(),
      );

      if (response.user != null && mounted) {
        // Les informations du marchand seront complétées dans un second temps
        // via une page de configuration du profil après connexion
        _showSuccess(
          'Inscription réussie ! Vérifiez votre email pour confirmer votre compte.',
        );
        context.go('/merchant/setup');
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
    return Column(
      children: [
        _buildStepIndicator(),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
            child: _buildFormContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildStepIndicator(),
        Expanded(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(context.horizontalSpacing * 2),
              child: SingleChildScrollView(
                child: _buildFormContent(),
              ),
            ),
          ),
        ),
      ],
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
                  DeepColorTokens.primary,
                  DeepColorTokens.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.storefront_rounded,
                    size: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: context.verticalSpacing * 2),
                  Text(
                    'Développez votre commerce',
                    style: TextStyle(
                      fontSize: FontSizes.titleLarge.getSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.verticalSpacing),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.horizontalSpacing * 3,
                    ),
                    child: Text(
                      'Réduisez vos pertes et atteignez de nouveaux clients éco-responsables',
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
          child: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: EdgeInsets.all(context.horizontalSpacing * 2),
                    child: SingleChildScrollView(
                      child: _buildFormContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalSpacing * 2,
        vertical: context.verticalSpacing,
      ),
      child: Row(
        children: [
          _StepIndicatorItem(
            number: '1',
            title: 'Compte',
            isActive: _currentStep >= 0,
            isCompleted: _currentStep > 0,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep > 0
                  ? DeepColorTokens.primary
                  : DeepColorTokens.divider,
            ),
          ),
          _StepIndicatorItem(
            number: '2',
            title: 'Commerce',
            isActive: _currentStep >= 1,
            isCompleted: _currentStep > 1,
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep1(),
            _buildStep2(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        AuthPageHeader(
          title: 'Créer votre compte marchand',
          subtitle: 'Étape 1 : Informations personnelles',
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
          label: 'Email professionnel',
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
          label: 'Téléphone',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s\+\-\(\)]')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le téléphone est requis pour les marchands';
            }
            return null;
          },
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

        const Spacer(),

        // Bouton suivant
        AuthPrimaryButton(
          text: 'Suivant',
          icon: Icons.arrow_forward_rounded,
          onPressed: _nextStep,
          isLoading: _isLoading,
        ),

        SizedBox(height: context.verticalSpacing),

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
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        AuthPageHeader(
          title: 'Informations commerciales',
          subtitle: 'Étape 2 : Détails de votre commerce',
          showBackButton: false,
        ),

        SizedBox(height: context.verticalSpacing * 3),

        // Nom du commerce
        AuthTextField(
          controller: _businessNameController,
          label: 'Nom du commerce',
          prefixIcon: Icons.store_outlined,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le nom du commerce est requis';
            }
            return null;
          },
        ),

        SizedBox(height: context.verticalSpacing * 1.5),

        // Type de commerce
        DropdownButtonFormField<String>(
          initialValue: _selectedBusinessType,
          decoration: InputDecoration(
            labelText: 'Type de commerce',
            prefixIcon: Icon(
              Icons.category_outlined,
              color: DeepColorTokens.neutral600,
            ),
            filled: true,
            fillColor: DeepColorTokens.surfaceBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.borderRadius),
              borderSide: BorderSide(
                color: DeepColorTokens.divider,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.borderRadius),
              borderSide: BorderSide(
                color: DeepColorTokens.divider,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.borderRadius),
              borderSide: BorderSide(
                color: DeepColorTokens.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.horizontalSpacing,
              vertical: context.verticalSpacing * 1.25,
            ),
          ),
          items: _businessTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedBusinessType = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner un type de commerce';
            }
            return null;
          },
        ),

        SizedBox(height: context.verticalSpacing * 1.5),

        // Numéro SIRET (optionnel)
        AuthTextField(
          controller: _businessRegistrationController,
          label: 'Numéro SIRET (optionnel)',
          hint: 'Ex: 123 456 789 00012',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s]')),
          ],
        ),

        SizedBox(height: context.verticalSpacing * 1.5),

        // Adresse
        AuthTextField(
          controller: _addressController,
          label: 'Adresse du commerce',
          prefixIcon: Icons.location_on_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'L\'adresse est requise';
            }
            return null;
          },
        ),

        SizedBox(height: context.verticalSpacing * 1.5),

        // Ville et code postal
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AuthTextField(
                controller: _cityController,
                label: 'Ville',
                prefixIcon: Icons.location_city_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requis';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: context.horizontalSpacing),
            Expanded(
              child: AuthTextField(
                controller: _postalCodeController,
                label: 'Code postal',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Requis';
                  }
                  if (value.length != 5) {
                    return 'Invalide';
                  }
                  return null;
                },
              ),
            ),
          ],
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
                  text: 'conditions d\'utilisation marchands',
                  style: TextStyle(
                    color: DeepColorTokens.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' et les '),
                TextSpan(
                  text: 'frais de service',
                  style: TextStyle(
                    color: DeepColorTokens.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Boutons
        Row(
          children: [
            Expanded(
              child: AuthPrimaryButton(
                text: 'Retour',
                icon: Icons.arrow_back_rounded,
                onPressed: _previousStep,
                backgroundColor: DeepColorTokens.neutral300,
                textColor: DeepColorTokens.textPrimary,
              ),
            ),
            SizedBox(width: context.horizontalSpacing),
            Expanded(
              flex: 2,
              child: AuthPrimaryButton(
                text: 'Créer mon compte',
                icon: Icons.check_rounded,
                onPressed: _handleSignup,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Indicateur d'étape
class _StepIndicatorItem extends StatelessWidget {
  final String number;
  final String title;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicatorItem({
    required this.number,
    required this.title,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive
                ? DeepColorTokens.primary
                : DeepColorTokens.neutral300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  )
                : Text(
                    number,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : DeepColorTokens.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSizes.bodyMedium.getSize(context),
                    ),
                  ),
          ),
        ),
        SizedBox(height: context.verticalSpacing / 2),
        Text(
          title,
          style: TextStyle(
            fontSize: FontSizes.caption.getSize(context),
            color: isActive
                ? DeepColorTokens.textPrimary
                : DeepColorTokens.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
