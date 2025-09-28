import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/responsive/design_tokens.dart';
import '../../core/services/qr_scanner_service.dart';
import '../../presentation/providers/app_mode_provider.dart';

/// Page de scan QR pour les commerçants
class MerchantQRScannerPage extends ConsumerStatefulWidget {
  const MerchantQRScannerPage({super.key});

  static const String routeName = '/merchant/qr-scanner';

  @override
  ConsumerState<MerchantQRScannerPage> createState() =>
      _MerchantQRScannerPageState();
}

class _MerchantQRScannerPageState extends ConsumerState<MerchantQRScannerPage>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isProcessing = false;
  String? _lastScannedCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_checkPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(mobileScannerControllerProvider);

    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(controller.start());
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(controller.stop());
    }
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _hasPermission = true);
    } else {
      final result = await Permission.camera.request();
      setState(() => _hasPermission = result.isGranted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offlineCount = ref.watch<int>(offlineScansCountProvider);

    // Écouter les synchronisations automatiques
    ref.listen<AsyncValue<SyncResult>>(autoSyncProvider, (_, next) {
      next.whenData((result) {
        if (result.synced > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result.synced} scans synchronisés'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        actions: [
          if (offlineCount > 0)
            Container(
              margin: EcoPlatesDesignTokens.spacing.offlineChipMargin,
              child: Chip(
                avatar: Icon(
                  Icons.cloud_off,
                  size: EcoPlatesDesignTokens.layout.offlineChipIconSize,
                ),
                label: Text('$offlineCount'),
                backgroundColor: Colors.orange,
                labelStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: _hasPermission
          ? Stack(
              children: [
                // Scanner camera
                MobileScanner(
                  controller: ref.watch(mobileScannerControllerProvider),
                  onDetect: _onDetect,
                  errorBuilder: (context, error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size:
                                EcoPlatesDesignTokens.layout.errorStateIconSize,
                            color: theme.colorScheme.error,
                          ),
                          SizedBox(
                            height: EcoPlatesDesignTokens.spacing.interfaceGap(
                              context,
                            ),
                          ),
                          Text(
                            'Erreur scanner: $error',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Overlay de scan
                _buildScanOverlay(theme),

                // Indicateur de traitement
                if (_isProcessing)
                  const ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Contrôles en bas
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildControls(theme),
                ),
              ],
            )
          : _buildNoPermissionView(theme),
    );
  }

  Widget _buildScanOverlay(ThemeData theme) {
    return Container(
      decoration: ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: theme.colorScheme.primary,
          borderRadius: EcoPlatesDesignTokens.layout.qrScannerBorderRadius,
          borderLength: EcoPlatesDesignTokens.layout.qrScannerBorderLength,
          borderWidth: EcoPlatesDesignTokens.layout.qrScannerBorderWidth,
          cutOutSize: EcoPlatesDesignTokens.layout.qrScannerCutOutSize,
        ),
      ),
    );
  }

  Widget _buildControls(ThemeData theme) {
    final controller = ref.watch(mobileScannerControllerProvider);

    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(
          alpha: EcoPlatesDesignTokens.layout.qrControlsOpacity,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.xl),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Instructions
            Text(
              'Placez le QR code dans le cadre',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),

            // Boutons de contrôle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Torche
                IconButton.filled(
                  onPressed: controller.toggleTorch,
                  icon: const Icon(Icons.flash_off),
                  tooltip: 'Torche',
                ),

                // Changer de caméra
                IconButton.filled(
                  onPressed: controller.switchCamera,
                  icon: const Icon(Icons.cameraswitch),
                  tooltip: 'Changer de caméra',
                ),

                // Synchroniser manuellement
                if (ref.watch(offlineScansCountProvider) > 0)
                  IconButton.filled(
                    onPressed: _syncOfflineScans,
                    icon: const Icon(Icons.sync),
                    tooltip: 'Synchroniser les scans',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoPermissionView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          EcoPlatesDesignTokens.spacing.sectionSpacing(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: EcoPlatesDesignTokens.layout.errorViewIconSize,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            Text(
              'Permission caméra requise',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),
            Text(
              "Pour scanner les QR codes, l'application a besoin "
              "d'accéder à votre caméra.",
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await openAppSettings();
                unawaited(_checkPermission());
              },
              icon: const Icon(Icons.settings),
              label: const Text('Ouvrir les paramètres'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty || _isProcessing) return;

    final barcode = barcodes.first;
    final code = barcode.rawValue;

    if (code == null || code == _lastScannedCode) return;

    setState(() {
      _isProcessing = true;
      _lastScannedCode = code;
    });

    // Vibration feedback
    if (Platform.isAndroid || Platform.isIOS) {
      // HapticFeedback.mediumImpact();
    }

    // Traiter le scan
    final scannerService = ref.read(qrScannerServiceProvider);

    // Récupérer le merchant ID depuis l'utilisateur actuel
    final merchantId = ref.read(currentMerchantIdProvider);

    if (merchantId == null) {
      _showErrorDialog(
        const QRScanResult(
          success: false,
          error: 'NO_MERCHANT_ID',
          message: 'Utilisateur non connecté ou profil invalide',
        ),
      );
      setState(() => _isProcessing = false);
      return;
    }

    final result = await scannerService.processScan(
      code,
      merchantId: merchantId,
      location: EcoPlatesDesignTokens.layout.defaultScanLocation,
    );

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (result.success) {
      _showSuccessDialog(result);
    } else {
      _showErrorDialog(result);
    }

    // Réinitialiser après délai pour permettre un nouveau scan
    Future.delayed(EcoPlatesDesignTokens.layout.qrScanResetDuration, () {
      if (mounted) {
        setState(() => _lastScannedCode = null);
      }
    });
  }

  void _showSuccessDialog(QRScanResult result) {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: EcoPlatesDesignTokens.layout.errorStateIconSize,
          ),
          title: const Text('Validation réussie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client: ${result.order!.customerName}'),
              SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
              Text('Montant: ${result.order!.totalAmount.toStringAsFixed(2)}€'),
              Divider(height: EcoPlatesDesignTokens.spacing.microGap(context)),
              const Text(
                'Articles:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...result.order!.items.map(
                (item) => Padding(
                  padding: EcoPlatesDesignTokens.spacing.qrDialogItemPadding,
                  child: Text('• ${item.quantity}x ${item.name}'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Marquer comme récupéré
              },
              child: const Text('Confirmer la récupération'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(QRScanResult result) {
    Theme.of(context);
    final isOffline = result.error == 'OFFLINE';

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            isOffline ? Icons.cloud_off : Icons.error_outline,
            color: isOffline ? Colors.orange : Colors.red,
            size: EcoPlatesDesignTokens.layout.errorStateIconSize,
          ),
          title: Text(isOffline ? 'Mode hors ligne' : 'Erreur de validation'),
          content: Text(result.message ?? 'Une erreur est survenue'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aide'),
          content: const _HelpDialogContent(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Compris'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _syncOfflineScans() async {
    final scanner = ref.read(qrScannerServiceProvider);
    final result = await scanner.syncOfflineScans();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Synchronisation: ${result.synced} réussi(s), ${result.failed} échoué(s)',
        ),
        backgroundColor: result.hasErrors ? Colors.orange : Colors.green,
      ),
    );
  }
}

/// Custom painter pour l'overlay du scanner
class QrScannerOverlayShape extends ShapeBorder {
  const QrScannerOverlayShape({
    this.borderColor = const Color(0xFFFFFFFF),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.borderWidth = 3,
    this.cutOutSize = 250,
  });

  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: rect.center,
          width: cutOutSize,
          height: cutOutSize,
        ),
        Radius.circular(borderRadius),
      ),
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    // Paint overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(
        alpha: EcoPlatesDesignTokens.layout.qrScannerOverlayOpacity,
      )
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    // Paint border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw corner lines
    _drawCorners(canvas, cutOutRect, borderPaint);
  }

  void _drawCorners(Canvas canvas, Rect rect, Paint paint) {
    canvas
      // Top left
      ..drawLine(
        Offset(rect.left, rect.top + borderLength),
        Offset(rect.left, rect.top),
        paint,
      )
      ..drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.left + borderLength, rect.top),
        paint,
      )
      // Top right
      ..drawLine(
        Offset(rect.right - borderLength, rect.top),
        Offset(rect.right, rect.top),
        paint,
      )
      ..drawLine(
        Offset(rect.right, rect.top),
        Offset(rect.right, rect.top + borderLength),
        paint,
      )
      // Bottom left
      ..drawLine(
        Offset(rect.left, rect.bottom - borderLength),
        Offset(rect.left, rect.bottom),
        paint,
      )
      ..drawLine(
        Offset(rect.left, rect.bottom),
        Offset(rect.left + borderLength, rect.bottom),
        paint,
      )
      // Bottom right
      ..drawLine(
        Offset(rect.right - borderLength, rect.bottom),
        Offset(rect.right, rect.bottom),
        paint,
      )
      ..drawLine(
        Offset(rect.right, rect.bottom),
        Offset(rect.right, rect.bottom - borderLength),
        paint,
      );
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderRadius: borderRadius,
      borderLength: borderLength * t,
      borderWidth: borderWidth * t,
      cutOutSize: cutOutSize * t,
    );
  }
}

/// Widget pour le contenu du dialogue d'aide avec espacement responsive
class _HelpDialogContent extends StatelessWidget {
  const _HelpDialogContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comment scanner un QR code:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
          const Text('1. Placez le QR code dans le cadre de scan'),
          const Text('2. Le scan est automatique'),
          const Text('3. Validez la commande affichée'),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
          const Text(
            'Mode hors ligne:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
          const Text('• Les scans sont enregistrés localement'),
          const Text('• Ils seront synchronisés automatiquement'),
          const Text('• Vous pouvez forcer la synchronisation'),
        ],
      ),
    );
  }
}
