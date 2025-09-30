import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/services/qr_code_service.dart';
import '../../../core/services/totp_service.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher un QR code sécurisé avec rotation automatique
class QRCodeDisplayWidget extends ConsumerStatefulWidget {
  const QRCodeDisplayWidget({
    required this.orderId,
    this.size = 280.0,
    this.onExpired,
    super.key,
  });

  final String orderId;
  final double size;
  final VoidCallback? onExpired;

  @override
  ConsumerState<QRCodeDisplayWidget> createState() =>
      _QRCodeDisplayWidgetState();
}

class _QRCodeDisplayWidgetState extends ConsumerState<QRCodeDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation pour la rotation du QR code
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Animation pour le fade lors du changement
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: _fadeController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _animateQRChange() {
    // Fade out, rotate, fade in
    _fadeController.forward().then((_) {
      _rotationController.forward(from: 0);
      _fadeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeAsync = ref.watch(currentQRCodeProvider(widget.orderId));
    final timerAsync = ref.watch(totpTimerProvider);
    final progressAsync = ref.watch(totpProgressProvider);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre
            Text(
              'QR Code Sécurisé',
              style: TextStyle(
                color: DeepColorTokens.neutral800,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 16),

            // QR Code avec animations
            qrCodeAsync.when(
              data: (qrPayload) {
                if (qrPayload == null) {
                  return _buildErrorState();
                }

                // Détecter le changement de QR code
                ref.listen<AsyncValue<QRPayload?>>(
                  currentQRCodeProvider(widget.orderId),
                  (previous, next) {
                    if (previous?.value?.rawData != next.value?.rawData) {
                      _animateQRChange();
                    }
                  },
                );

                return _buildQRCode(qrPayload, Theme.of(context));
              },
              loading: _buildLoadingState,
              error: (error, stack) => _buildErrorState(),
            ),

            const SizedBox(height: 24),

            // Timer et progress
            timerAsync.when(
              data: (timeRemaining) {
                return progressAsync.when(
                  data: (progress) => _buildTimerSection(
                    timeRemaining,
                    progress,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            // Instructions
            _buildInstructions(),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCode(QRPayload qrPayload, ThemeData theme) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(
              _rotationController.value * math.pi,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral0,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: DeepColorTokens.primary,
                  width: 3,
                ),
              ),
              child: QrImageView(
                data: qrPayload.rawData,
                size: widget.size,
                backgroundColor: DeepColorTokens.neutral0,
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text(
                      'Erreur QR',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: DeepColorTokens.error),
                    ),
                  );
                },
                embeddedImage: const AssetImage('assets/images/logo.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(40, 40),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerSection(
    int timeRemaining,
    double progress,
  ) {
    final isExpiringSoon = timeRemaining <= 10;
    final timerColor = isExpiringSoon
        ? DeepColorTokens.error
        : timeRemaining <= 20
        ? DeepColorTokens.warning
        : DeepColorTokens.primary;

    if (isExpiringSoon && widget.onExpired != null) {
      widget.onExpired!();
    }

    return Column(
      children: [
        // Progress circulaire avec timer
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            children: [
              // Cercle de progression
              Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: DeepColorTokens.neutral300,
                    valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                  ),
                ),
              ),
              // Timer au centre
              Center(
                child: Semantics(
                  label: 'Temps restant: $timeRemaining secondes',
                  child: Text(
                    '${timeRemaining}s',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: timerColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Message d'état
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            isExpiringSoon
                ? 'QR code expire bientôt!'
                : timeRemaining <= 20
                ? 'Préparez-vous au renouvellement'
                : 'QR code valide',
            key: ValueKey(isExpiringSoon ? 'expiring' : 'valid'),
            style: TextStyle(
              color: timerColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DeepColorTokens.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: DeepColorTokens.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Instructions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: DeepColorTokens.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Présentez ce QR code au commerçant.\n'
            'Le code se renouvelle automatiquement toutes les 30 secondes.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: DeepColorTokens.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        color: DeepColorTokens.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DeepColorTokens.error,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: DeepColorTokens.errorDark,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de génération',
            style: TextStyle(
              color: DeepColorTokens.errorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Force refresh
              ref.invalidate(currentQRCodeProvider(widget.orderId));
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

/// Widget simple pour afficher un QR code statique
class SimpleQRCodeDisplay extends StatelessWidget {
  const SimpleQRCodeDisplay({
    required this.data,
    this.size = 200.0,
    this.backgroundColor = DeepColorTokens.neutral0,
    this.foregroundColor = DeepColorTokens.neutral1000,
    super.key,
  });

  final String data;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: QrImageView(
        data: data,
        size: size,
        backgroundColor: backgroundColor,
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: foregroundColor,
        ),
        errorStateBuilder: (cxt, err) {
          return const Center(
            child: Text(
              'QR Error',
              textAlign: TextAlign.center,
              style: TextStyle(color: DeepColorTokens.error),
            ),
          );
        },
      ),
    );
  }
}
