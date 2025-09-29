import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

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
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_checkPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(_controller.start());
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_controller.stop());
    }
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() => _hasPermission = true);
      unawaited(_controller.start());
    } else {
      final result = await Permission.camera.request();
      setState(() => _hasPermission = result.isGranted);
      if (result.isGranted) {
        unawaited(_controller.start());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        actions: [
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
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Erreur scanner: $error',
                            style: TextStyle(color: theme.colorScheme.error),
                            textAlign: TextAlign.center,
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
      decoration: const ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 16,
          borderLength: 40,
          borderWidth: 3,
          cutOutSize: 250,
        ),
      ),
    );
  }

  Widget _buildControls(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
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
            SizedBox(height: 16),

            // Boutons de contrôle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Torche
                IconButton.filled(
                  onPressed: () => _controller.toggleTorch(),
                  icon: const Icon(Icons.flash_off),
                  tooltip: 'Torche',
                ),

                // Changer de caméra
                IconButton.filled(
                  onPressed: () => _controller.switchCamera(),
                  icon: const Icon(Icons.cameraswitch),
                  tooltip: 'Changer de caméra',
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Permission caméra requise',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              "Pour scanner les QR codes, l'application a besoin d'accéder à votre caméra.",
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
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

  void _onDetect(BarcodeCapture capture) async {
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
      // Pour activer les vibrations, il faudrait ajouter le package vibration
      // et appeler: Vibration.vibrate(duration: 100);
    }

    // Simuler le traitement du scan
    await Future<void>.delayed(Duration(seconds: 1));

    if (mounted) {
      setState(() => _isProcessing = false);

      // Afficher un résultat simulé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR Code scanné: $code'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Réinitialiser après délai pour permettre un nouveau scan
    Future<void>.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _lastScannedCode = null);
      }
    });
  }

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment scanner un QR code:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('1. Placez le QR code dans le cadre de scan'),
              Text('2. Le scan est automatique'),
              Text('3. Validez la commande affichée'),
              SizedBox(height: 16),
              Text(
                'Mode hors ligne:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('• Les scans sont enregistrés localement'),
              Text('• Ils seront synchronisés automatiquement'),
              Text('• Vous pouvez forcer la synchronisation'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris'),
          ),
        ],
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

    final path = Path()
      ..addRect(rect)
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      );

    // Paint overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

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
    final cornerLength = borderLength;

    // Top left
    canvas..drawLine(
      Offset(rect.left, rect.top + cornerLength),
      Offset(rect.left, rect.top),
      paint,
    )
    ..drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.left + cornerLength, rect.top),
      paint,
    )

    // Top right
    ..drawLine(
      Offset(rect.right - cornerLength, rect.top),
      Offset(rect.right, rect.top),
      paint,
    )
    ..drawLine(
      Offset(rect.right, rect.top),
      Offset(rect.right, rect.top + cornerLength),
      paint,
    )

    // Bottom left
    ..drawLine(
      Offset(rect.left, rect.bottom - cornerLength),
      Offset(rect.left, rect.bottom),
      paint,
    )
    ..drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.left + cornerLength, rect.bottom),
      paint,
    )

    // Bottom right
    ..drawLine(
      Offset(rect.right - cornerLength, rect.bottom),
      Offset(rect.right, rect.bottom),
      paint,
    )
    ..drawLine(
      Offset(rect.right, rect.bottom),
      Offset(rect.right, rect.bottom - cornerLength),
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
