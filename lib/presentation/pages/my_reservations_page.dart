import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../providers/offer_reservation_provider.dart';
import '../providers/user_reservations_provider.dart';

class MyReservationsPage extends ConsumerWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(userReservationsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
      ),
      body: reservations.isEmpty
          ? _EmptyState(colorScheme: colorScheme)
          : ListView.separated(
              padding: EdgeInsets.all(
                EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              itemCount: reservations.length,
              separatorBuilder: (_, _) => SizedBox(
                height: EcoPlatesDesignTokens.spacing.microGap(context),
              ),
              itemBuilder: (context, index) {
                final r = reservations[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: ListTile(
                    title: Text(r.title),
                    subtitle: Text(
                      'Quantité: ${r.quantity} • ${_formatDate(r.createdAt)}',
                    ),
                    trailing: FilledButton.tonalIcon(
                      onPressed: () async {
                        try {
                          await ref
                              .read(offerReservationProvider.notifier)
                              .cancelById(r.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Réservation annulée: "${r.title}"',
                                ),
                              ),
                            );
                          }
                        } on Exception catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorScheme.error,
                                content: Text('Annulation impossible: $e'),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Annuler'),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/$y • $hh:$mm';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: colorScheme.outline),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
          Text(
            'Aucune réservation',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
          Text(
            'Vos réservations apparaîtront ici',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
