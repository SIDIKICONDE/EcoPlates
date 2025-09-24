import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/adaptive_widgets.dart';

/// Écran de profil et paramètres pour les marchands
class MerchantProfileScreen extends ConsumerWidget {
  const MerchantProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Profil & Paramètres'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // En-tête du profil
              _buildProfileHeader(context),
              
              // Sections de paramètres
              _buildSection(
                title: 'Mon commerce',
                children: [
                  _buildSettingsTile(
                    icon: Icons.store,
                    title: 'Informations du commerce',
                    subtitle: 'Nom, adresse, horaires',
                    onTap: () {
                      // TODO: Navigation vers édition du commerce
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.image,
                    title: 'Photos et médias',
                    subtitle: 'Logo, photos du commerce',
                    onTap: () {
                      // TODO: Navigation vers gestion des médias
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.category,
                    title: 'Catégories et tags',
                    subtitle: 'Types de produits, spécialités',
                    onTap: () {
                      // TODO: Navigation vers gestion des catégories
                    },
                  ),
                ],
              ),
              
              _buildSection(
                title: 'Gestion',
                children: [
                  _buildSettingsTile(
                    icon: Icons.people,
                    title: 'Équipe',
                    subtitle: 'Gérer les accès employés',
                    onTap: () {
                      // TODO: Navigation vers gestion d'équipe
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.payment,
                    title: 'Paiements et facturation',
                    subtitle: 'Méthodes de paiement, factures',
                    onTap: () {
                      // TODO: Navigation vers paiements
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Alertes et rappels',
                    onTap: () {
                      // TODO: Navigation vers paramètres de notifications
                    },
                  ),
                ],
              ),
              
              _buildSection(
                title: 'Performance',
                children: [
                  _buildSettingsTile(
                    icon: Icons.insights,
                    title: 'Objectifs',
                    subtitle: 'Définir et suivre vos objectifs',
                    onTap: () {
                      // TODO: Navigation vers objectifs
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.star,
                    title: 'Avis clients',
                    subtitle: '4.5/5 (123 avis)',
                    trailing: _buildRatingBadge(4.5),
                    onTap: () {
                      // TODO: Navigation vers avis
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.eco,
                    title: 'Impact écologique',
                    subtitle: 'Votre contribution environnementale',
                    onTap: () {
                      // TODO: Navigation vers impact
                    },
                  ),
                ],
              ),
              
              _buildSection(
                title: 'Aide et support',
                children: [
                  _buildSettingsTile(
                    icon: Icons.help_outline,
                    title: 'Centre d\'aide',
                    subtitle: 'FAQ et tutoriels',
                    onTap: () {
                      // TODO: Navigation vers aide
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Contacter le support',
                    subtitle: 'Obtenir de l\'aide',
                    onTap: () {
                      // TODO: Contact support
                    },
                  ),
                  _buildSettingsTile(
                    icon: Icons.article,
                    title: 'Conditions d\'utilisation',
                    subtitle: 'CGU et politique de confidentialité',
                    onTap: () {
                      // TODO: Navigation vers CGU
                    },
                  ),
                ],
              ),
              
              // Actions de déconnexion
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Se déconnecter'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.store,
              size: 48.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          
          // Nom du commerce
          Text(
            'Boulangerie Dupont',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Badge de vérification
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.green[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  color: Colors.green[700],
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Commerce vérifié',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          
          // Statistiques rapides
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickStat(
                icon: Icons.calendar_today,
                value: '2 ans',
                label: 'Ancienneté',
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colors.grey[300],
              ),
              _buildQuickStat(
                icon: Icons.eco,
                value: '2.3t',
                label: 'CO₂ sauvé',
              ),
              Container(
                width: 1,
                height: 40.h,
                color: Colors.grey[300],
              ),
              _buildQuickStat(
                icon: Icons.star,
                value: '4.5',
                label: 'Note',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey[600]),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Theme.of(NavigatorKeys.rootNavigator.currentContext!)
                .primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: Theme.of(NavigatorKeys.rootNavigator.currentContext!)
                .primaryColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing ?? const CupertinoListTileChevron(),
        onTap: onTap,
      );
    }
    
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Theme.of(NavigatorKeys.rootNavigator.currentContext!)
              .primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: Theme.of(NavigatorKeys.rootNavigator.currentContext!)
              .primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            rating.toString(),
            style: TextStyle(
              color: Colors.amber[800],
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    if (PlatformUtils.shouldUseCupertino) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Se déconnecter'),
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implémenter la déconnexion
                context.go('/onboarding');
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implémenter la déconnexion
                context.go('/onboarding');
              },
              child: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// Helper pour les clés de navigation globales
class NavigatorKeys {
  static final rootNavigator = GlobalKey<NavigatorState>();
}