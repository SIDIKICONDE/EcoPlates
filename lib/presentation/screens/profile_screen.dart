import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/adaptive_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header du profil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Utilisateur EcoPlates',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'user@ecoplates.com',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatCard(
                        icon: Icons.eco,
                        value: '250',
                        label: 'Points Eco',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 16),
                      _StatCard(
                        icon: Icons.shopping_bag,
                        value: '25',
                        label: 'Commandes',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _StatCard(
                        icon: Icons.co2,
                        value: '1.2kg',
                        label: 'CO2 économisé',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Options du profil
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Informations personnelles',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité à venir'),
                        ),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: AdaptiveSwitch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  _ProfileMenuItem(
                    icon: Icons.language,
                    title: 'Langue',
                    subtitle: 'Français',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Thème sombre',
                    trailing: AdaptiveSwitch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  const Divider(height: 32),
                  _ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Aide et support',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Politique de confidentialité',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'À propos',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AdaptiveDialog.show(
                          context: context,
                          title: 'Déconnexion',
                          content: 'Êtes-vous sûr de vouloir vous déconnecter ?',
                          actions: [
                            AdaptiveDialogAction(
                              text: 'Annuler',
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            AdaptiveDialogAction(
                              text: 'Déconnexion',
                              onPressed: () {
                                Navigator.of(context).pop();
                                // TODO: Implémenter la déconnexion
                              },
                              isDestructive: true,
                            ),
                          ],
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
      onTap: onTap,
    );
  }
}