import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/qr_scanner_service.dart';
import '../widgets/scanner/scanner_widgets.dart';

/// Écran de scan QR pour valider les commandes (réservé aux commerçants)
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _cameraController;
  bool _isProcessing = false;
  bool _hasPermission = false;
  bool _torchEnabled = false;
  String? _lastScannedCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null) return;

    switch (state) {
      case AppLifecycleState.paused:
        _cameraController!.stop();
        break;
      case AppLifecycleState.resumed:
        _cameraController!.start();
        break;
      default:
        break;
    }
  }

  Future<void> _initializeCamera() async {
    // Vérifier la permission de la caméra
    final status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _cameraController = MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        );
      });
    } else {
      setState(() => _hasPermission = false);
    }
  }

  Future<void> _processQrCode(String code) async {
    // Éviter de traiter le même code plusieurs fois
    if (_isProcessing || code == _lastScannedCode) return;

    setState(() {
      _isProcessing = true;
      _lastScannedCode = code;
    });

    // Vibrer pour feedback
    // HapticFeedback.mediumImpact();

    // Arrêter temporairement le scanner
    _cameraController?.stop();

    try {
      final service = ref.read(qrScannerServiceProvider);
      final result = await service.processQrCode(code);

      if (!mounted) return;

      // Afficher le résultat approprié
      if (result.isError) {
        _showErrorDialog(result.message!);
      } else {
        _showResultBottomSheet(result);
      }
    } catch (e) {
      _showErrorDialog('Erreur inattendue: $e');
    } finally {
      setState(() => _isProcessing = false);
      // Redémarrer le scanner après un délai
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _cameraController?.start();
        }
      });
    }
  }

  void _showResultBottomSheet(QrScanResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QrResultBottomSheet(
        result: result,
        onConfirm: () => _handleAction(result),
      ),
    );
  }

  Future<void> _handleAction(QrScanResult result) async {
    Navigator.pop(context);

    final service = ref.read(qrScannerServiceProvider);
    bool success = false;

    try {
      switch (result.action) {
        case QrScanAction.collect:
          // Validation d'une commande (réservation) - réservé aux commerçants
          success = await service.confirmOrder(
            result.reservationId!,
            result.confirmationCode!,
          );
          if (success && mounted) {
            _showSuccessDialog(
              'Commande validée !',
              'La commande ${result.reservationId} a été confirmée avec succès.',
            );
          }
          break;

        // Cases historiques (assiettes) - conservées pour compatibilité mais non utilisées
        case QrScanAction.borrow:
        case QrScanAction.returnPlate:
          // Plus utilisé dans le nouveau flux
          break;

        default:
          break;
      }
    } catch (e) {
      _showErrorDialog('Erreur lors de l\'action: $e');
    }

    // Réinitialiser pour permettre un nouveau scan
    setState(() => _lastScannedCode = null);
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/merchant/dashboard');
            },
            child: const Text('Aller au dashboard'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 48),
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scanner une assiette'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Permission caméra requise',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Pour scanner les QR codes des commandes, nous avons besoin d\'accéder à votre caméra.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final status = await Permission.camera.request();
                  if (status.isGranted) {
                    _initializeCamera();
                  } else if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }
                },
                icon: const Icon(Icons.settings),
                label: const Text('Autoriser la caméra'),
              ),
            ],
          ),
        ),
      );
    }

    if (_cameraController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner une commande'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() => _torchEnabled = !_torchEnabled);
              _cameraController?.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _cameraController!,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _processQrCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // Overlay avec cadre de scan
          CustomPaint(
            painter: ScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),

          // Instructions
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Placez le QR code de la commande dans le cadre',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Indicateur de traitement
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Traitement en cours...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          // Historique récent
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Commandes du jour',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Utilisez ce scanner pour valider les commandes',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/plates'),
                    child: const Text('Voir'),
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
