import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/adaptive_widgets.dart';
import '../../providers/app_mode_provider.dart';

/// Écran de sélection du type d'utilisateur
class UserTypeSelectionScreen extends ConsumerWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo et titre
              Icon(
                Icons.eco,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Bienvenue sur EcoPlates',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Choisissez votre profil pour commencer',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Carte Consommateur
              _UserTypeCard(
                icon: Icons.person,
                title: 'Je suis un consommateur',
                subtitle: 'J\'emprunte des assiettes recyclables',
                features: const [
                  'Scanner et emprunter des assiettes',
                  'Suivre mon score écologique',
                  'Trouver les points de collecte',
                  'Gagner des récompenses',
                ],
                color: Colors.blue,
                onTap: () {
                  // Pour la démo, on simule une connexion directe
                  ref.read(appModeProvider.notifier).setMode(AppMode.consumer);
                  context.go('/');
                },
              ),

              const SizedBox(height: 20),

              // Carte Commerçant
              _UserTypeCard(
                icon: Icons.store,
                title: 'Je suis un commerçant',
                subtitle: 'Je gère un restaurant/café',
                features: const [
                  'Gérer mon inventaire d\'assiettes',
                  'Scanner les retours',
                  'Voir mes statistiques',
                  'Gérer mon équipe',
                ],
                color: Colors.orange,
                onTap: () {
                  // Pour la démo, on simule une connexion directe
                  ref.read(appModeProvider.notifier).setMode(AppMode.merchant);
                  context.go('/merchant/dashboard');
                },
              ),

              const Spacer(),

              // Liens en bas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Afficher plus d'infos sur EcoPlates
                    },
                    child: const Text('En savoir plus'),
                  ),
                  const Text(' • ', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // TODO: Conditions d'utilisation
                    },
                    child: const Text('Conditions'),
                  ),
                  const Text(' • ', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      // TODO: Support
                    },
                    child: const Text('Aide'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget pour les cartes de sélection du type d'utilisateur
class _UserTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> features;
  final Color color;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: color.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
          color: color.withAlpha(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 16, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
