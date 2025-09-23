import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/reservation.dart';
import '../../providers/commerce/reservations_provider.dart';
import '../../widgets/commerce/reservation_card.dart';

/// Écran de gestion des réservations
class ReservationsScreen extends ConsumerStatefulWidget {
  const ReservationsScreen({super.key});

  @override
  ConsumerState<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends ConsumerState<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              text: 'En cours',
              icon: Icon(Icons.schedule),
            ),
            Tab(
              text: 'Historique',
              icon: Icon(Icons.history),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveReservations(),
          _buildReservationHistory(),
        ],
      ),
    );
  }

  Widget _buildActiveReservations() {
    final reservationsAsync = ref.watch(activeReservationsProvider);
    final upcomingPickups = ref.watch(upcomingPickupsProvider);

    return reservationsAsync.when(
      data: (reservations) {
        if (reservations.isEmpty) {
          return _buildEmptyState(
            icon: Icons.shopping_basket_outlined,
            title: 'Aucune réservation active',
            subtitle: 'Découvrez les offres disponibles\net réservez vos paniers anti-gaspillage',
            buttonLabel: 'Voir les offres',
            onButtonPressed: () => Navigator.pushNamed(context, '/offers'),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeReservationsProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Rappel pour les collectes imminentes
              if (upcomingPickups.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${upcomingPickups.length} réservation${upcomingPickups.length > 1 ? 's' : ''} '
                            'à récupérer dans moins de 2h !',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Liste des réservations actives
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final reservation = reservations[index];
                    return ReservationCard(
                      reservation: reservation,
                      onTap: () => _showReservationDetails(reservation),
                      onCancel: () => _cancelReservation(reservation.id),
                    );
                  },
                  childCount: reservations.length,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildReservationHistory() {
    final historyAsync = ref.watch(
      reservationHistoryProvider((page: 1, limit: 50)),
    );

    return historyAsync.when(
      data: (reservations) {
        if (reservations.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'Aucun historique',
            subtitle: 'Vos réservations passées\napparaîtront ici',
          );
        }

        // Grouper par statut
        final collected = reservations
            .where((r) => r.status == ReservationStatus.collected)
            .toList();
        final cancelled = reservations
            .where((r) => r.status == ReservationStatus.cancelled)
            .toList();
        final noShow = reservations
            .where((r) => r.status == ReservationStatus.noShow)
            .toList();

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(reservationHistoryProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Statistiques
              SliverToBoxAdapter(
                child: _buildStatisticsCard(
                  collected: collected.length,
                  cancelled: cancelled.length,
                  noShow: noShow.length,
                ),
              ),
              
              // Liste par catégorie
              if (collected.isNotEmpty) ...[
                _buildSectionHeader('Collectées', Colors.green),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ReservationCard(
                      reservation: collected[index],
                      isHistory: true,
                      onTap: () => _showReservationDetails(collected[index]),
                    ),
                    childCount: collected.length,
                  ),
                ),
              ],
              
              if (cancelled.isNotEmpty) ...[
                _buildSectionHeader('Annulées', Colors.orange),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ReservationCard(
                      reservation: cancelled[index],
                      isHistory: true,
                      onTap: () => _showReservationDetails(cancelled[index]),
                    ),
                    childCount: cancelled.length,
                  ),
                ),
              ],
              
              if (noShow.isNotEmpty) ...[
                _buildSectionHeader('Non récupérées', Colors.red),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ReservationCard(
                      reservation: noShow[index],
                      isHistory: true,
                      onTap: () => _showReservationDetails(noShow[index]),
                    ),
                    childCount: noShow.length,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard({
    required int collected,
    required int cancelled,
    required int noShow,
  }) {
    final total = collected + cancelled + noShow;
    final successRate = total > 0 ? (collected / total * 100) : 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                label: 'Collectées',
                value: collected.toString(),
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              _buildStatItem(
                label: 'Annulées',
                value: cancelled.toString(),
                color: Colors.orange,
                icon: Icons.cancel,
              ),
              _buildStatItem(
                label: 'Non récupérées',
                value: noShow.toString(),
                color: Colors.red,
                icon: Icons.error,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Barre de progression du taux de succès
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Taux de collecte',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${successRate.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: successRate / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  successRate > 80
                      ? Colors.green
                      : successRate > 50
                          ? Colors.orange
                          : Colors.red,
                ),
                minHeight: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonLabel,
    VoidCallback? onButtonPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.explore),
                label: Text(buttonLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(activeReservationsProvider);
                ref.invalidate(reservationHistoryProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReservationDetails(Reservation reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReservationDetailsSheet(
        reservationId: reservation.id,
      ),
    );
  }

  Future<void> _cancelReservation(String reservationId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler cette réservation ?\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(reservationsStateProvider.notifier)
            .cancelReservation(reservationId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Réservation annulée'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

/// Widget pour afficher les détails d'une réservation
class ReservationDetailsSheet extends ConsumerWidget {
  final String reservationId;

  const ReservationDetailsSheet({
    super.key,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationAsync = ref.watch(
      reservationWithOfferProvider(reservationId),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: reservationAsync.when(
        data: (data) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de poignée
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Titre et statut
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.offer.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusChip(data.reservation.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.offer.merchantName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Code de confirmation
                if (data.reservation.status == ReservationStatus.confirmed)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Code de confirmation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.reservation.confirmationCode,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _showQRCode(context, ref, reservationId),
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Afficher QR Code'),
                        ),
                      ],
                    ),
                  ),
                
                // Plus de détails...
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ReservationStatus status) {
    Color color;
    String label;
    
    switch (status) {
      case ReservationStatus.confirmed:
        color = Colors.blue;
        label = 'Confirmée';
        break;
      case ReservationStatus.collected:
        color = Colors.green;
        label = 'Collectée';
        break;
      case ReservationStatus.cancelled:
        color = Colors.orange;
        label = 'Annulée';
        break;
      case ReservationStatus.noShow:
        color = Colors.red;
        label = 'Non récupérée';
        break;
      default:
        color = Colors.grey;
        label = 'En attente';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showQRCode(BuildContext context, WidgetRef ref, String reservationId) {
    // Afficher le QR code
    // À implémenter avec un package QR
  }
}