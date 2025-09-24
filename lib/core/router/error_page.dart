import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes/route_constants.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône d'erreur avec animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 80,
                      color: theme.colorScheme.error,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Titre de l'erreur
              Text(
                _getErrorTitle(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description de l'erreur
              Text(
                _getErrorDescription(),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // URL de l'erreur (en mode debug)
              if (state.uri.toString().isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.uri.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Boutons d'action
              _buildActionButtons(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  /// Détermine le titre selon le type d'erreur
  String _getErrorTitle() {
    if (state.uri.toString().contains('merchant')) {
      return 'Marchand introuvable';
    } else if (state.uri.toString().contains('offer')) {
      return 'Offre introuvable';
    } else {
      return 'Page non trouvée';
    }
  }

  /// Détermine la description selon le type d'erreur
  String _getErrorDescription() {
    if (state.uri.toString().contains('merchant')) {
      return "Le marchand que vous recherchez n'existe pas ou n'est plus disponible.";
    } else if (state.uri.toString().contains('offer')) {
      return "Cette offre n'est plus disponible ou a été supprimée.";
    } else {
      return "La page que vous recherchez n'existe pas ou a été déplacée.";
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
            icon: const Icon(Icons.home_rounded),
            label: const Text("Retour à l'accueil"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
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
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Retour'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
