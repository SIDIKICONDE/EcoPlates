import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../../domain/entities/association.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../domain/usecases/manage_association_usecase.dart';
import '../../../data/services/association_service.dart';

/// Provider pour l'association actuelle
final currentAssociationIdProvider = StateProvider<String>((ref) => 'default-association-id');

/// Provider pour récupérer l'association actuelle
final currentAssociationProvider = FutureProvider<Association>((ref) async {
  final associationId = ref.watch(currentAssociationIdProvider);
  final useCase = ref.watch(getAssociationByIdUseCaseProvider);
  final result = await useCase(associationId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (association) => association,
  );
});

/// Provider pour les statistiques d'impact
final associationImpactProvider = FutureProvider<AssociationImpactReport>((ref) async {
  final associationId = ref.watch(currentAssociationIdProvider);
  final useCase = ref.watch(calculateAssociationImpactUseCaseProvider);
  final result = await useCase(
    associationId: associationId,
    fromDate: DateTime.now().subtract(const Duration(days: 30)),
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (impact) => impact,
  );
});

/// Provider pour les offres prioritaires
final associationPriorityOffersProvider = FutureProvider<List<FoodOffer>>((ref) async {
  final associationId = ref.watch(currentAssociationIdProvider);
  final useCase = ref.watch(getAssociationPriorityOffersUseCaseProvider);
  final result = await useCase(
    associationId: associationId,
    maxPrice: 5.0,
    radiusKm: 20.0,
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (offers) => offers,
  );
});

/// Page d'accueil dédiée aux associations
class AssociationHomeScreen extends ConsumerWidget {
  final String associationId;
  
  const AssociationHomeScreen({
    super.key,
    required this.associationId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Définir l'ID de l'association
    ref.read(currentAssociationIdProvider.notifier).state = associationId;
    
    final theme = Theme.of(context);
    final associationAsync = ref.watch(currentAssociationProvider);
    
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Tableau de bord Association'),
      ),
      body: associationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              AdaptiveButton(
                onPressed: () => ref.invalidate(currentAssociationProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (association) => RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(currentAssociationProvider);
            ref.invalidate(associationImpactProvider);
            ref.invalidate(associationPriorityOffersProvider);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Carte de bienvenue avec statut
                _buildWelcomeCard(context, ref, association),
                const SizedBox(height: 20),
                
                // Actions rapides
                _buildQuickActions(context, ref, association),
                const SizedBox(height: 24),
                
                // Statistiques d'impact
                _buildImpactStats(context, ref),
                const SizedBox(height: 24),
                
                // Collecte groupée suggérée
                _buildGroupedCollectionCard(context, ref, association),
                const SizedBox(height: 24),
                
                // Offres prioritaires
                Text(
                  'Offres prioritaires',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPriorityOffers(context, ref),
                const SizedBox(height: 24),
                
                // Section bénévoles disponibles
                Text(
                  'Bénévoles disponibles',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildVolunteersSection(context, ref, association),
                const SizedBox(height: 24),
                
                // Collectes récentes et à venir
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Collectes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/association/$associationId/collections'),
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCollectionsSection(context, ref),
                const SizedBox(height: 24),
                
                // Actualités et partenaires
                _buildNewsSection(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildWelcomeCard(BuildContext context, WidgetRef ref, Association association) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;
    
    if (hour < 12) {
      greeting = 'Bonjour';
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'Bon après-midi';
      icon = Icons.wb_cloudy;
    } else {
      greeting = 'Bonsoir';
      icon = Icons.nights_stay;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha: 0.7),
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
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      association.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(association.status),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Ensemble, luttons contre le gaspillage alimentaire',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          if (association.details.hasCollectAgreement) ...[
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.verified, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Agrément collecte alimentaire',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStatusBadge(AssociationStatus status) {
    Color color;
    String text;
    IconData icon;
    
    switch (status) {
      case AssociationStatus.validated:
        color = Colors.green;
        text = 'Active';
        icon = Icons.check_circle;
        break;
      case AssociationStatus.pending:
        color = Colors.orange;
        text = 'En attente';
        icon = Icons.pending;
        break;
      case AssociationStatus.suspended:
        color = Colors.red;
        text = 'Suspendue';
        icon = Icons.block;
        break;
      default:
        color = Colors.grey;
        text = 'Inactive';
        icon = Icons.cancel;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions(BuildContext context, WidgetRef ref, Association association) {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          
          _QuickActionItem(
            icon: Icons.shopping_basket,
            label: 'Collectes',
            color: Colors.orange,
            onTap: () => context.go('/association/${association.id}/manage'),
          ),
          const SizedBox(width: 12),
          _QuickActionItem(
            icon: Icons.people,
            label: 'Bénévoles',
            color: Colors.purple,
            onTap: () => context.go('/association/${association.id}/volunteers'),
          ),
          const SizedBox(width: 12),
          _QuickActionItem(
            icon: Icons.analytics,
            label: 'Rapports',
            color: Colors.green,
            onTap: () => context.go('/association/${association.id}/reports'),
          ),
          const SizedBox(width: 12),
          _QuickActionItem(
            icon: Icons.settings,
            label: 'Paramètres',
            color: Colors.grey,
            onTap: () => context.go('/association/${association.id}/settings'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildImpactStats(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final impactAsync = ref.watch(associationImpactProvider);
    
    return impactAsync.when(
      loading: () => const _StatsLoadingCard(),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Impossible de charger les statistiques',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ),
      data: (impact) => LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          
          if (isTablet) {
            return Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.restaurant,
                    value: impact.totalMealsDistributed.toString(),
                    label: 'Repas distribués',
                    color: Colors.green,
                    trend: '+12%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.people_alt,
                    value: impact.totalPeopleHelped.toString(),
                    label: 'Personnes aidées',
                    color: Colors.blue,
                    trend: '+8%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.eco,
                    value: '${impact.totalCo2Saved.toStringAsFixed(1)}t',
                    label: 'CO₂ évité',
                    color: Colors.teal,
                    trend: '+15%',
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.restaurant,
                        value: impact.totalMealsDistributed.toString(),
                        label: 'Repas distribués',
                        color: Colors.green,
                        trend: '+12%',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people_alt,
                        value: impact.totalPeopleHelped.toString(),
                        label: 'Personnes aidées',
                        color: Colors.blue,
                        trend: '+8%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatCard(
                  icon: Icons.eco,
                  value: '${impact.totalCo2Saved.toStringAsFixed(1)}t',
                  label: 'CO₂ évité',
                  color: Colors.teal,
                  trend: '+15%',
                  isFullWidth: true,
                ),
              ],
            );
          }
        },
      ),
    );
  }
  
  Widget _buildGroupedCollectionCard(BuildContext context, WidgetRef ref, Association association) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.route,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tournée optimisée suggérée',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '5 commerces • 12.3 km • ~45 min',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MerchantChip(name: 'Boulangerie Bio', items: 15),
                const SizedBox(width: 8),
                _MerchantChip(name: 'Super U', items: 8),
                const SizedBox(width: 8),
                const Text('...'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/association/${association.id}/collection-route'),
                icon: const Icon(Icons.map),
                label: const Text('Voir la tournée'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPriorityOffers(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(associationPriorityOffersProvider);
    
    return offersAsync.when(
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, stack) => SizedBox(
        height: 180,
        child: Center(
          child: Text('Erreur: $error'),
        ),
      ),
      data: (offers) {
        if (offers.isEmpty) {
          return const _EmptyOffersCard();
        }
        
        return SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final offer = offers[index];
              return _PriorityOfferCard(
                offer: offer,
                onTap: () => context.go('/offer/${offer.id}'),
              );
            },
          ),
        );
      },
    );
  }
  
  Widget _buildVolunteersSection(BuildContext context, WidgetRef ref, Association association) {
    // Mock data pour l'instant
    final volunteers = [
      _VolunteerData('Marie D.', true, 'assets/avatar1.jpg'),
      _VolunteerData('Jean P.', true, 'assets/avatar2.jpg'),
      _VolunteerData('Sophie L.', false, 'assets/avatar3.jpg'),
      _VolunteerData('Ahmed B.', true, 'assets/avatar4.jpg'),
    ];
    
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: volunteers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final volunteer = volunteers[index];
          return _VolunteerAvatar(volunteer: volunteer);
        },
      ),
    );
  }
  
  Widget _buildCollectionsSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _CollectionTile(
          title: 'Collecte programmée',
          subtitle: 'Aujourd\'hui 14h30 - 5 commerces',
          status: _CollectionStatus.upcoming,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _CollectionTile(
          title: 'Collecte terminée',
          subtitle: 'Hier - 45 repas collectés',
          status: _CollectionStatus.completed,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _CollectionTile(
          title: 'Collecte en cours',
          subtitle: 'Marie D. - Boulangerie Bio',
          status: _CollectionStatus.inProgress,
          onTap: () {},
        ),
      ],
    );
  }
  
  Widget _buildNewsSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actualités EcoPlates',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'NOUVEAU',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Il y a 2 jours',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Nouveau partenariat avec Carrefour',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '15 nouveaux magasins rejoignent le réseau EcoPlates dans votre région.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lire plus →'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Widgets réutilisables

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
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
  final String? trend;
  final bool isFullWidth;
  
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.trend,
    this.isFullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(icon, color: color, size: 24),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trend!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsLoadingCard extends StatelessWidget {
  const _StatsLoadingCard();
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) => Expanded(
        child: Container(
          margin: EdgeInsets.only(left: index > 0 ? 12 : 0),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      )),
    );
  }
}

class _MerchantChip extends StatelessWidget {
  final String name;
  final int items;
  
  const _MerchantChip({
    required this.name,
    required this.items,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              items.toString(),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityOfferCard extends StatelessWidget {
  final FoodOffer offer;
  final VoidCallback onTap;
  
  const _PriorityOfferCard({
    required this.offer,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 100,
                width: double.infinity,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Stack(
                  children: [
                    if (offer.images.isNotEmpty)
                      Image.network(
                        offer.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    else
                      const Center(
                        child: Icon(Icons.restaurant, size: 40),
                      ),
                    // Badge gratuit
                    if (offer.isFree)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'GRATUIT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Quantité
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${offer.quantity} disponibles',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.merchantName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer.title,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _EmptyOffersCard extends StatelessWidget {
  const _EmptyOffersCard();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Aucune offre prioritaire',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Revenez plus tard',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modèle temporaire pour les bénévoles
class _VolunteerData {
  final String name;
  final bool isAvailable;
  final String avatar;
  
  _VolunteerData(this.name, this.isAvailable, this.avatar);
}

class _VolunteerAvatar extends StatelessWidget {
  final _VolunteerData volunteer;
  
  const _VolunteerAvatar({required this.volunteer});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[300],
              child: Text(
                volunteer.name.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: volunteer.isAvailable ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          volunteer.name,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

enum _CollectionStatus {
  upcoming,
  inProgress,
  completed,
}

class _CollectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final _CollectionStatus status;
  final VoidCallback onTap;
  
  const _CollectionTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    
    switch (status) {
      case _CollectionStatus.upcoming:
        icon = Icons.schedule;
        color = Colors.orange;
        break;
      case _CollectionStatus.inProgress:
        icon = Icons.directions_car;
        color = Colors.blue;
        break;
      case _CollectionStatus.completed:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
    }
    
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}