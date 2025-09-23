import 'package:flutter/material.dart';
import '../../../data/services/qr_scanner_service.dart';

/// Painter pour l'overlay du scanner avec cadre de détection
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scanAreaSize = size.width * 0.75;
    final scanAreaLeft = (size.width - scanAreaSize) / 2;
    final scanAreaTop = (size.height - scanAreaSize) / 2;

    // Dessiner l'overlay sombre
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5);

    final scanArea = RRect.fromRectAndRadius(
      Rect.fromLTWH(scanAreaLeft, scanAreaTop, scanAreaSize, scanAreaSize),
      const Radius.circular(20),
    );

    // Créer le chemin avec le trou pour la zone de scan
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(scanArea)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);

    // Dessiner le cadre de la zone de scan
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(scanArea, borderPaint);

    // Dessiner les coins accentués
    final cornerPaint = Paint()
      ..color = Theme.of(NavigatorState().context).primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;

    // Coin supérieur gauche
    canvas.drawLine(
      Offset(scanAreaLeft, scanAreaTop + cornerLength),
      Offset(scanAreaLeft, scanAreaTop + 20),
      cornerPaint,
    );
    canvas.drawArc(
      Rect.fromLTWH(scanAreaLeft, scanAreaTop, 40, 40),
      -3.14159, // π radians
      -1.5708, // π/2 radians
      false,
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft + 20, scanAreaTop),
      Offset(scanAreaLeft + cornerLength, scanAreaTop),
      cornerPaint,
    );

    // Coin supérieur droit
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize - cornerLength, scanAreaTop),
      Offset(scanAreaLeft + scanAreaSize - 20, scanAreaTop),
      cornerPaint,
    );
    canvas.drawArc(
      Rect.fromLTWH(scanAreaLeft + scanAreaSize - 40, scanAreaTop, 40, 40),
      -1.5708, // -π/2 radians
      -1.5708, // -π/2 radians
      false,
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize, scanAreaTop + 20),
      Offset(scanAreaLeft + scanAreaSize, scanAreaTop + cornerLength),
      cornerPaint,
    );

    // Coin inférieur droit
    canvas.drawLine(
      Offset(
        scanAreaLeft + scanAreaSize,
        scanAreaTop + scanAreaSize - cornerLength,
      ),
      Offset(scanAreaLeft + scanAreaSize, scanAreaTop + scanAreaSize - 20),
      cornerPaint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        scanAreaLeft + scanAreaSize - 40,
        scanAreaTop + scanAreaSize - 40,
        40,
        40,
      ),
      0,
      -1.5708,
      false,
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft + scanAreaSize - 20, scanAreaTop + scanAreaSize),
      Offset(
        scanAreaLeft + scanAreaSize - cornerLength,
        scanAreaTop + scanAreaSize,
      ),
      cornerPaint,
    );

    // Coin inférieur gauche
    canvas.drawLine(
      Offset(scanAreaLeft + cornerLength, scanAreaTop + scanAreaSize),
      Offset(scanAreaLeft + 20, scanAreaTop + scanAreaSize),
      cornerPaint,
    );
    canvas.drawArc(
      Rect.fromLTWH(scanAreaLeft, scanAreaTop + scanAreaSize - 40, 40, 40),
      1.5708,
      -1.5708,
      false,
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanAreaLeft, scanAreaTop + scanAreaSize - 20),
      Offset(scanAreaLeft, scanAreaTop + scanAreaSize - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bottom sheet pour afficher le résultat du scan QR
class QrResultBottomSheet extends StatelessWidget {
  final QrScanResult result;
  final VoidCallback onConfirm;

  const QrResultBottomSheet({
    super.key,
    required this.result,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String title;
    String description;
    String buttonText;

    switch (result.action) {
      case QrScanAction.borrow:
        icon = Icons.shopping_bag_outlined;
        color = Colors.blue;
        title = 'Action non disponible';
        description = 'Cette fonctionnalité n\'est plus utilisée';
        buttonText = 'Confirmer l\'emprunt';
        break;

      case QrScanAction.returnPlate:
        icon = Icons.assignment_return;
        color = Colors.green;
        title = 'Action non disponible';
        description = 'Cette fonctionnalité n\'est plus utilisée';
        buttonText = 'Confirmer le retour';
        break;

      case QrScanAction.collect:
        icon = Icons.assignment_turned_in;
        color = Colors.blue;
        title = 'Valider cette commande ?';
        description =
            'Commande ${result.reservationId}\nCode: ${result.confirmationCode}';
        buttonText = 'Confirmer la collecte';
        break;

      case QrScanAction.info:
        icon = Icons.info_outline;
        color = Colors.orange;
        title = 'Information';
        description = result.message ?? 'Information indisponible';
        buttonText = 'OK';
        break;

      default:
        icon = Icons.error_outline;
        color = Colors.red;
        title = 'Erreur';
        description = result.message ?? 'Une erreur est survenue';
        buttonText = 'Fermer';
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: color),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Informations supplémentaires pour la collecte
              if (result.action == QrScanAction.collect) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Vérifiez que le client a bien effectué sa commande avant de valider la collecte',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Boutons
              if (result.action != QrScanAction.info) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
