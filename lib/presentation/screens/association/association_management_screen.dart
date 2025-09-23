import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/association.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../domain/usecases/manage_association_usecase.dart';
import '../../providers/app_mode_provider.dart';

/// Écran principal de gestion pour les associations
class AssociationManagementScreen extends ConsumerStatefulWidget {
  final String associationId;
  
  const AssociationManagementScreen({
    super.key,
    required this.associationId,
  });
  
  @override
  ConsumerState<AssociationManagementScreen> createState() =>
      _AssociationManagementScreenState();
}

class _AssociationManagementScreenState
    extends ConsumerState<AssociationManagementScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final isIOS = ref.watch(isIOSProvider);

    final associationUseCase = ref.watch(getAssociationByIdUseCaseProvider);
    final associationFuture = associationUseCase(widget.associationId);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Gestion Association'),
      ),
      body: FutureBuilder<Either<Failure, Association>>(
        future: associationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return snapshot.data!.fold(
              (failure) => Center(child: Text('Erreur: ${failure.message}')),
              (association) => _buildMainContent(association, isIOS),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
  
  Widget _buildMainContent(Association association, bool isIOS) {
    return Row(
      children: [
        if (!isIOS) 
          SizedBox(
            width: 300,
            child: _buildDrawer(context),
          ),
        Expanded(
          child: _buildContent(association),
        ),
      ],
    );
  }
  
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.volunteer_activism,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  'Association',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Tableau de bord'),
            selected: _selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text('Offres disponibles'),
            selected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_basket),
            title: const Text('Collectes'),
            selected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Bénévoles'),
            selected: _selectedIndex == 3,
            onTap: () => _onItemTapped(3),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Impact social'),
            selected: _selectedIndex == 4,
            onTap: () => _onItemTapped(4),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
    );
  }
  
  
  Widget _buildContent(Association association) {
    switch (_selectedIndex) {
      case 0:
        return _DashboardView(association: association);
      case 1:
        return _OffersView(associationId: association.id);
      case 2:
        return _CollectionsView(associationId: association.id);
      case 3:
        return _VolunteersView(association: association);
      case 4:
        return _ImpactView(associationId: association.id);
      default:
        return _DashboardView(association: association);
    }
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Fermer le drawer si ouvert
  }
}

/// Vue tableau de bord
class _DashboardView extends StatelessWidget {
  final Association association;
  
  const _DashboardView({required this.association});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec statut
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          association.name,
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      _StatusBadge(status: association.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    association.details.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, 
                        size: 16, 
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${association.details.city}, ${association.details.postalCode}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Statistiques rapides
          Text(
            'Statistiques',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _StatCard(
                title: 'Repas distribués',
                value: association.stats.mealsDistributed.toString(),
                icon: Icons.restaurant,
                color: Colors.green,
              ),
              _StatCard(
                title: 'Personnes aidées',
                value: association.stats.peopleHelped.toString(),
                icon: Icons.people,
                color: Colors.blue,
              ),
              _StatCard(
                title: 'CO₂ évité',
                value: '${association.stats.co2Saved.toStringAsFixed(1)} t',
                icon: Icons.eco,
                color: Colors.teal,
              ),
              _StatCard(
                title: 'Bénévoles actifs',
                value: association.details.activeVolunteers.toString(),
                icon: Icons.volunteer_activism,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Informations détaillées
          Text(
            'Informations',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Président',
                    value: association.details.presidentName,
                  ),
                  _InfoRow(
                    label: 'SIRET',
                    value: association.siret,
                  ),
                  _InfoRow(
                    label: 'RNA',
                    value: association.rna,
                  ),
                  _InfoRow(
                    label: 'Année de création',
                    value: association.details.yearFounded.toString(),
                  ),
                  _InfoRow(
                    label: 'Bénéficiaires',
                    value: '${association.details.beneficiariesCount} personnes',
                  ),
                  if (association.details.hasColdChain)
                    const _InfoRow(
                      label: 'Chaîne du froid',
                      value: '✓ Disponible',
                      valueColor: Colors.green,
                    ),
                  if (association.details.hasVehicles)
                    const _InfoRow(
                      label: 'Véhicules',
                      value: '✓ Disponibles',
                      valueColor: Colors.green,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vue des offres disponibles pour l'association
class _OffersView extends ConsumerWidget {
  final String associationId;
  
  const _OffersView({required this.associationId});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(
      FutureProvider<Either<Failure, List<FoodOffer>>>((ref) async {
        final useCase = ref.watch(getAssociationPriorityOffersUseCaseProvider);
        return await useCase(
          associationId: associationId,
          maxPrice: 5.0,
          radiusKm: 15.0,
        );
      }),
    );
    
    return offersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stack) => Center(
        child: Text('Erreur: $error'),
      ),
      data: (result) => result.fold(
        (failure) => Center(
          child: Text('Erreur: ${failure.message}'),
        ),
        (offers) => _buildOffersList(context, offers),
      ),
    );
  }
  
  Widget _buildOffersList(BuildContext context, List<FoodOffer> offers) {
    if (offers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucune offre disponible',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Revenez plus tard pour voir les nouvelles offres',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return _OfferCard(offer: offer);
      },
    );
  }
}

/// Widget pour afficher une offre
class _OfferCard extends StatelessWidget {
  final FoodOffer offer;
  
  const _OfferCard({required this.offer});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to offer detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: offer.images.isNotEmpty
                      ? Image.network(offer.images.first, fit: BoxFit.cover)
                      : Icon(
                          Icons.fastfood,
                          size: 40,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            offer.title,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (offer.isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'GRATUIT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Text(
                            offer.priceText,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.merchantName,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.inventory_2, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${offer.quantity} disponibles',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatPickupTime(offer.pickupEndTime),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
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
  
  String _formatPickupTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}j';
    }
  }
}

/// Autres vues (simplifiées pour l'instant)
class _CollectionsView extends StatelessWidget {
  final String associationId;
  
  const _CollectionsView({required this.associationId});
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestion des collectes - À implémenter'),
    );
  }
}

class _VolunteersView extends StatelessWidget {
  final Association association;
  
  const _VolunteersView({required this.association});
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestion des bénévoles - À implémenter'),
    );
  }
}

class _ImpactView extends StatelessWidget {
  final String associationId;
  
  const _ImpactView({required this.associationId});
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Rapport d\'impact social - À implémenter'),
    );
  }
}

// Widgets utilitaires
class _StatusBadge extends StatelessWidget {
  final AssociationStatus status;
  
  const _StatusBadge({required this.status});
  
  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final text = _getStatusText();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Color _getStatusColor() {
    switch (status) {
      case AssociationStatus.validated:
        return Colors.green;
      case AssociationStatus.pending:
        return Colors.orange;
      case AssociationStatus.suspended:
        return Colors.red;
      case AssociationStatus.rejected:
        return Colors.red;
      case AssociationStatus.expired:
        return Colors.grey;
    }
  }
  
  String _getStatusText() {
    switch (status) {
      case AssociationStatus.validated:
        return 'VALIDÉE';
      case AssociationStatus.pending:
        return 'EN ATTENTE';
      case AssociationStatus.suspended:
        return 'SUSPENDUE';
      case AssociationStatus.rejected:
        return 'REJETÉE';
      case AssociationStatus.expired:
        return 'EXPIRÉE';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}