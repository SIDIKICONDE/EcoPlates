import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes/route_constants.dart';

/// Types d'erreurs supportés par la page d'erreur
enum _ErrorType {
  merchant,
  offer,
  product,
  notFound,
}

/// Page d'erreur personnalisée pour l'application EcoPlates
///
/// Gère les erreurs 404 et autres erreurs de navigation
/// selon les directives EcoPlates
class EcoPlatesErrorPage extends StatelessWidget {
  const EcoPlatesErrorPage({
    required this.state,
    super.key,
  });

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(RouteConstants.mainHome),
          tooltip: 'Fermer',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height - kToolbarHeight - 48,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône d'erreur avec animation améliorée
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0, end: 1),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: EdgeInsets.all(
                          12.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.errorContainer.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Icon(
                          _getErrorIcon(),
                          size: 20.0,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.0),

                // Titre de l'erreur
                Text(
                  _getErrorTitle(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.0),

                // Description de l'erreur
                Text(
                  _getErrorDescription(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.0),

                // URL de l'erreur (en mode debug)
                if (state.uri.toString().isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    child: Text(
                      state.uri.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                SizedBox(height: 24.0),

                // Boutons d'action
                _buildActionButtons(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Type d'erreur basé sur l'URI
  _ErrorType _getErrorType() {
    final uriString = state.uri.toString().toLowerCase();

    if (uriString.contains('/merchant/') || uriString.contains('/merchants/')) {
      return _ErrorType.merchant;
    } else if (uriString.contains('/offer/') ||
        uriString.contains('/offers/')) {
      return _ErrorType.offer;
    } else if (uriString.contains('/product/') ||
        uriString.contains('/products/')) {
      return _ErrorType.product;
    } else {
      return _ErrorType.notFound;
    }
  }

  /// Détermine le titre selon le type d'erreur
  String _getErrorTitle() {
    switch (_getErrorType()) {
      case _ErrorType.merchant:
        return 'Marchand introuvable';
      case _ErrorType.offer:
        return 'Offre introuvable';
      case _ErrorType.product:
        return 'Produit introuvable';
      case _ErrorType.notFound:
        return 'Page non trouvée';
    }
  }

  /// Détermine la description selon le type d'erreur
  String _getErrorDescription() {
    switch (_getErrorType()) {
      case _ErrorType.merchant:
        return "Le marchand que vous recherchez n'existe pas ou n'est plus disponible.";
      case _ErrorType.offer:
        return "Cette offre n'est plus disponible ou a été supprimée.";
      case _ErrorType.product:
        return "Ce produit n'est plus disponible ou a été retiré.";
      case _ErrorType.notFound:
        return "La page que vous recherchez n'existe pas ou a été déplacée.";
    }
  }

  /// Détermine l'icône selon le type d'erreur
  IconData _getErrorIcon() {
    switch (_getErrorType()) {
      case _ErrorType.merchant:
        return Icons.storefront_outlined;
      case _ErrorType.offer:
        return Icons.local_offer_outlined;
      case _ErrorType.product:
        return Icons.inventory_2_outlined;
      case _ErrorType.notFound:
        return Icons.error_outline_rounded;
    }
  }

  /// Construit les boutons d'action selon le contexte
  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Bouton principal - Retour à l'accueil
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go(RouteConstants.mainHome),
            icon: Icon(
              Icons.home_rounded,
              size: 20.0,
            ),
            label: const Text("Retour à l'accueil"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
              ),
            ),
          ),
        ),

        SizedBox(height: 8.0),

        // Bouton secondaire - Retour en arrière
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteConstants.mainHome);
              }
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 20.0,
            ),
            label: const Text('Retour'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
