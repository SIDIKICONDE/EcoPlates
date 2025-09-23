import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../core/widgets/adaptive_widgets.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/association.dart';
import '../../../domain/usecases/manage_association_usecase.dart';
import '../../../data/services/association_service.dart';
import '../../providers/app_mode_provider.dart';

/// Écran de profil public d'une association
class AssociationProfileScreen extends ConsumerWidget {
  final String associationId;
  
  const AssociationProfileScreen({
    super.key,
    required this.associationId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = ref.watch(isIOSProvider);
    
    final associationAsync = ref.watch(
      FutureProvider<Either<Failure, Association>>((ref) async {
        final useCase = ref.watch(getAssociationByIdUseCaseProvider);
        return await useCase(associationId);
      }),
    );
    
    final impactAsync = ref.watch(
      FutureProvider<Either<Failure, AssociationImpactReport>>((ref) async {
        final useCase = ref.watch(calculateAssociationImpactUseCaseProvider);
        return await useCase(
          associationId: associationId,
          fromDate: DateTime.now().subtract(const Duration(days: 365)),
        );
      }),
    );
    
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text('Profil Association'),
        actions: [
          if (isIOS)
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.share),
              onPressed: () => _shareAssociation(context, associationId),
            )
          else
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareAssociation(context, associationId),
            ),
        ],
      ),
      body: associationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) => Center(
          child: Text('Erreur: $error'),
        ),
        data: (result) => result.fold(
          (failure) => Center(
            child: Text('Erreur: ${failure.message}'),
          ),
          (association) => _buildProfile(context, ref, association, impactAsync),
        ),
      ),
    );
  }
  
  
  Widget _buildProfile(
    BuildContext context,
    WidgetRef ref,
    Association association,
    AsyncValue<Either<Failure, AssociationImpactReport>> impactAsync,
  ) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec image de couverture
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volunteer_activism,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      association.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (association.status == AssociationStatus.validated)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.verified, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Vérifiée',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          // Description et infos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'À propos',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          association.details.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoChips(context, association),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Impact social
                Text(
                  'Impact social',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                impactAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  error: (error, stack) => const SizedBox.shrink(),
                  data: (result) => result.fold(
                    (failure) => const SizedBox.shrink(),
                    (report) => _buildImpactSection(context, report),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Informations pratiques
                Text(
                  'Informations pratiques',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildContactInfo(
                          icon: Icons.location_on,
                          title: 'Adresse',
                          content: '${association.details.address}\n'
                              '${association.details.postalCode} ${association.details.city}',
                        ),
                        const Divider(),
                        _buildContactInfo(
                          icon: Icons.phone,
                          title: 'Téléphone',
                          content: association.details.phone,
                          onTap: () => _callAssociation(association.details.phone),
                        ),
                        const Divider(),
                        _buildContactInfo(
                          icon: Icons.email,
                          title: 'Email',
                          content: association.details.email,
                          onTap: () => _emailAssociation(association.details.email),
                        ),
                        if (association.details.website.isNotEmpty) ...[
                          const Divider(),
                          _buildContactInfo(
                            icon: Icons.language,
                            title: 'Site web',
                            content: association.details.website,
                            onTap: () => _openWebsite(association.details.website),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Horaires de collecte
                Text(
                  'Horaires de collecte',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _buildOpeningHours(context, association.details.collectHours),
                const SizedBox(height: 16),
                
                // Boutons d'action
                _buildActionButtons(context, ref, association),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoChips(BuildContext context, Association association) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          icon: Icons.foundation,
          label: _getAssociationTypeLabel(association.type),
        ),
        _InfoChip(
          icon: Icons.calendar_today,
          label: 'Depuis ${association.details.yearFounded}',
        ),
        _InfoChip(
          icon: Icons.people,
          label: '${association.details.activeVolunteers} bénévoles',
        ),
        if (association.details.hasColdChain)
          const _InfoChip(
            icon: Icons.ac_unit,
            label: 'Chaîne du froid',
          ),
        if (association.details.hasVehicles)
          const _InfoChip(
            icon: Icons.local_shipping,
            label: 'Véhicules',
          ),
      ],
    );
  }
  
  Widget _buildImpactSection(BuildContext context, AssociationImpactReport report) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _ImpactCard(
              icon: Icons.restaurant,
              value: '${report.totalMealsDistributed}',
              label: 'Repas distribués',
              color: Colors.green,
            ),
            _ImpactCard(
              icon: Icons.people_alt,
              value: '${report.totalPeopleHelped}',
              label: 'Personnes aidées',
              color: Colors.blue,
            ),
            _ImpactCard(
              icon: Icons.eco,
              value: '${report.totalCo2Saved.toStringAsFixed(1)}t',
              label: 'CO₂ évité',
              color: Colors.teal,
            ),
            _ImpactCard(
              icon: Icons.recycling,
              value: '${report.totalFoodSaved.toStringAsFixed(1)}t',
              label: 'Nourriture sauvée',
              color: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Score d\'impact: ${report.impactScore.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildOpeningHours(BuildContext context, OpeningHours hours) {
    final isOpen = hours.isOpenNow;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isOpen ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isOpen ? 'Ouvert maintenant' : 'Fermé',
                  style: TextStyle(
                    color: isOpen ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...DayOfWeek.values.map((day) {
              final slot = hours.schedule[day];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getDayLabel(day),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      slot == null || !slot.isOpen
                          ? 'Fermé'
                          : '${slot.openTimeFormatted} - ${slot.closeTimeFormatted}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: slot == null || !slot.isOpen
                            ? Colors.grey
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (hours.specialNotes != null) ...[
              const Divider(),
              Text(
                hours.specialNotes!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactInfo({
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: onTap != null ? Colors.blue : null,
                      decoration: onTap != null
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, WidgetRef ref, Association association) {
    final isIOS = ref.watch(isIOSProvider);
    
    return Column(
      children: [
        if (association.isActive)
          SizedBox(
            width: double.infinity,
            child: isIOS
                ? CupertinoButton.filled(
                    onPressed: () => _contactAssociation(context, association),
                    child: const Text('Contacter l\'association'),
                  )
                : ElevatedButton.icon(
                    onPressed: () => _contactAssociation(context, association),
                    icon: const Icon(Icons.message),
                    label: const Text('Contacter l\'association'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: isIOS
              ? CupertinoButton(
                  onPressed: () => _becomeVolunteer(context, association),
                  child: const Text('Devenir bénévole'),
                )
              : OutlinedButton.icon(
                  onPressed: () => _becomeVolunteer(context, association),
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text('Devenir bénévole'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
        ),
      ],
    );
  }
  
  // Méthodes utilitaires
  String _getAssociationTypeLabel(AssociationType type) {
    switch (type) {
      case AssociationType.foodBank:
        return 'Banque alimentaire';
      case AssociationType.socialRestaurant:
        return 'Restaurant social';
      case AssociationType.charity:
        return 'Association caritative';
      case AssociationType.studentAssociation:
        return 'Association étudiante';
      case AssociationType.religiousOrg:
        return 'Organisation religieuse';
      case AssociationType.redCross:
        return 'Croix-Rouge';
      case AssociationType.other:
        return 'Autre';
    }
  }
  
  String _getDayLabel(DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday:
        return 'Lundi';
      case DayOfWeek.tuesday:
        return 'Mardi';
      case DayOfWeek.wednesday:
        return 'Mercredi';
      case DayOfWeek.thursday:
        return 'Jeudi';
      case DayOfWeek.friday:
        return 'Vendredi';
      case DayOfWeek.saturday:
        return 'Samedi';
      case DayOfWeek.sunday:
        return 'Dimanche';
    }
  }
  
  void _shareAssociation(BuildContext context, String associationId) {
    // TODO: Implémenter le partage
  }
  
  void _callAssociation(String phone) {
    // TODO: Lancer l'appel
  }
  
  void _emailAssociation(String email) {
    // TODO: Ouvrir l'email
  }
  
  void _openWebsite(String website) {
    // TODO: Ouvrir le site web
  }
  
  void _contactAssociation(BuildContext context, Association association) {
    // TODO: Ouvrir le formulaire de contact
  }
  
  void _becomeVolunteer(BuildContext context, Association association) {
    // TODO: Ouvrir le formulaire pour devenir bénévole
  }
}

// Widgets réutilisables
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  
  const _InfoChip({
    required this.icon,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  
  const _ImpactCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}