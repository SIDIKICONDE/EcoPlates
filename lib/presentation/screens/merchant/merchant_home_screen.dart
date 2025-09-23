import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Page d'accueil pour les commerçants
class MerchantHomeScreen extends ConsumerWidget {
  const MerchantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoPlates - Commerce'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications bientôt disponibles'),
                ),
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Paramètres'),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Text('Aide'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Déconnexion'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                context.go('/onboarding');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Carte de bienvenue commerçant
              _buildMerchantWelcomeCard(context),
              const SizedBox(height: 20),
              
              // Statistiques du jour
              _buildTodayStats(context),
              const SizedBox(height: 24),
              
              // Actions principales pour commerçant
              Text(
                'Gestion de votre commerce',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Grille d'actions pour commerçant
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _MerchantActionTile(
                    icon: Icons.add_business,
                    title: 'Créer une offre',
                    subtitle: 'Nouveau panier anti-gaspi',
                    color: Colors.green,
                    onTap: () => context.go('/merchant/create-offer'),
                  ),
                  _MerchantActionTile(
                    icon: Icons.inventory,
                    title: 'Mes offres',
                    subtitle: '5 offres actives',
                    color: Colors.blue,
                    badge: '5',
                    onTap: () => context.go('/merchant/offers'),
                  ),
                  _MerchantActionTile(
                    icon: Icons.qr_code_scanner,
                    title: 'Scanner réservation',
                    subtitle: 'Valider une collecte',
                    color: Colors.orange,
                    onTap: () => context.go('/merchant/scan'),
                  ),
                  _MerchantActionTile(
                    icon: Icons.receipt_long,
                    title: 'Réservations',
                    subtitle: '3 en attente',
                    color: Colors.purple,
                    badge: '3',
                    onTap: () => context.go('/merchant/reservations'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Réservations à traiter aujourd'hui
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'À traiter aujourd\'hui',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/merchant/reservations'),
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Liste des réservations du jour
              _buildTodayReservations(context),
              const SizedBox(height: 24),
              
              // Performance écologique
              _buildEcoPerformance(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/merchant/create-offer'),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle offre'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildMerchantWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo,
            Colors.indigo.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Boulangerie Dupont',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Commerce vérifié ✓',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickStat(
                icon: Icons.star,
                value: '4.8',
                label: 'Note',
              ),
              _buildQuickStat(
                icon: Icons.people,
                value: '324',
                label: 'Clients',
              ),
              _buildQuickStat(
                icon: Icons.eco,
                value: '2.3t',
                label: 'CO₂ sauvé',
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
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DailyStatCard(
            title: 'Aujourd\'hui',
            value: '12',
            subtitle: 'paniers vendus',
            icon: Icons.shopping_basket,
            color: Colors.green,
            trend: '+20%',
            trendUp: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DailyStatCard(
            title: 'Revenus',
            value: '48€',
            subtitle: 'générés',
            icon: Icons.euro,
            color: Colors.blue,
            trend: '+15%',
            trendUp: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DailyStatCard(
            title: 'En attente',
            value: '3',
            subtitle: 'à collecter',
            icon: Icons.schedule,
            color: Colors.orange,
            trend: null,
            trendUp: false,
          ),
        ),
      ],
    );
  }

  Widget _buildTodayReservations(BuildContext context) {
    return Column(
      children: [
        _ReservationItem(
          customerName: 'Marie L.',
          offerTitle: 'Panier du soir',
          pickupTime: '18:00 - 19:00',
          status: ReservationStatus.pending,
          confirmationCode: 'AB12CD',
        ),
        const SizedBox(height: 8),
        _ReservationItem(
          customerName: 'Jean P.',
          offerTitle: 'Viennoiseries',
          pickupTime: '19:00 - 20:00',
          status: ReservationStatus.pending,
          confirmationCode: 'EF34GH',
        ),
        const SizedBox(height: 8),
        _ReservationItem(
          customerName: 'Sophie M.',
          offerTitle: 'Panier surprise',
          pickupTime: '20:00 - 21:00',
          status: ReservationStatus.collected,
          confirmationCode: 'IJ56KL',
        ),
      ],
    );
  }

  Widget _buildEcoPerformance(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: Colors.green[700], size: 24),
              const SizedBox(width: 8),
              Text(
                'Performance écologique du mois',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _EcoMetric(
                label: 'Repas sauvés',
                value: '156',
                icon: Icons.restaurant,
              ),
              _EcoMetric(
                label: 'CO₂ économisé',
                value: '78 kg',
                icon: Icons.cloud_off,
              ),
              _EcoMetric(
                label: 'Déchets évités',
                value: '52 kg',
                icon: Icons.delete_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tuile d'action pour les commerçants
class _MerchantActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  const _MerchantActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Carte de statistique journalière
class _DailyStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool trendUp;

  const _DailyStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: trendUp ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 10,
                      color: trendUp ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item de réservation
enum ReservationStatus { pending, collected, cancelled }

class _ReservationItem extends StatelessWidget {
  final String customerName;
  final String offerTitle;
  final String pickupTime;
  final ReservationStatus status;
  final String confirmationCode;

  const _ReservationItem({
    required this.customerName,
    required this.offerTitle,
    required this.pickupTime,
    required this.status,
    required this.confirmationCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getStatusIcon(),
              color: _getStatusColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        confirmationCode,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  offerTitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pickupTime,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 11,
                    color: _getStatusColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.collected:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case ReservationStatus.pending:
        return Icons.schedule;
      case ReservationStatus.collected:
        return Icons.check_circle;
      case ReservationStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText() {
    switch (status) {
      case ReservationStatus.pending:
        return 'En attente';
      case ReservationStatus.collected:
        return 'Collecté';
      case ReservationStatus.cancelled:
        return 'Annulé';
    }
  }
}

/// Métrique écologique
class _EcoMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _EcoMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green[600], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.green[600],
          ),
        ),
      ],
    );
  }
}