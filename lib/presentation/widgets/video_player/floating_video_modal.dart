import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/services/video_pool_manager.dart';
import '../../../domain/entities/video_preview.dart';

/// API simple pour afficher/masquer le lecteur flottant via OverlayEntry
class FloatingVideoOverlay {
  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static Future<void> show(BuildContext context, VideoPreview video) async {
    if (_entry != null) return; // Déjà affiché
    final overlay = Overlay.of(context);

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _FloatingVideoOverlay(
        video: video,
        onClose: hide,
        // Permet de forcer rebuild si nécessaire
        requestRebuild: () => entry.markNeedsBuild(),
      ),
    );

    _entry = entry;
    overlay.insert(entry);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

/// Raccourci rétrocompatible
Future<void> showFloatingVideoModal(BuildContext context, VideoPreview video) async {
  return FloatingVideoOverlay.show(context, video);
}

class _FloatingVideoOverlay extends StatefulWidget {
  const _FloatingVideoOverlay({required this.video, required this.onClose, required this.requestRebuild});
  final VideoPreview video;
  final VoidCallback onClose;
  final VoidCallback requestRebuild;

  @override
  State<_FloatingVideoOverlay> createState() => _FloatingVideoOverlayState();
}

class _FloatingVideoOverlayState extends State<_FloatingVideoOverlay> with SingleTickerProviderStateMixin {
  final VideoPoolManager _pool = VideoPoolManager();
  VideoPlayerController? _controller;

  // Position absolue du lecteur (depuis le coin supérieur gauche)
  Offset? _position;
  bool _positionInitialized = false;

  // Taille du player (16:9)
  late double _baseWidth; // taille normale
  late double _baseHeight;
  final double _miniWidth = 200;
  double get _miniHeight => _miniWidth * 9 / 16;
  bool _isMini = false;

  bool _muted = true;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_positionInitialized) {
      final size = MediaQuery.of(context).size;
      // Largeur responsive
      _baseWidth = size.width <= 400
          ? size.width * 0.9
          : size.width <= 800
              ? 360
              : 420;
      _baseHeight = _baseWidth * 9 / 16;

      const margin = 16.0;
      // Position initiale: coin bas-droit
      _position = Offset(size.width - _baseWidth - margin, size.height - _baseHeight - margin);
      _positionInitialized = true;
      // Initialisation contrôleur
      _initController();
      _planHideControls();
    }
  }

  double get _currentWidth => _isMini ? _miniWidth : _baseWidth;
  double get _currentHeight => _isMini ? _miniHeight : _baseHeight;

  void _planHideControls() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  Future<void> _initController() async {
    try {
      _controller = _pool.getController(widget.video.videoUrl) ??
          await _pool.createController(widget.video.videoUrl);
      if (!mounted) return;
      await _controller!.setLooping(true);
      await _controller!.setVolume(_muted ? 0 : 1);
      await _controller!.play();
      _controller!.addListener(() {
        if (!mounted) return;
        setState(() {});
      });
      setState(() {});
    } catch (e) {
      debugPrint('Erreur init lecteur flottant: $e');
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    // Ne pas disposer: le pool gère la mémoire. Mettre en pause suffit.
    _controller?.pause();
    super.dispose();
  }

  void _togglePlayPause() {
    final c = _controller;
    if (c == null) return;
    if (c.value.isPlaying) {
      c.pause();
    } else {
      c.play();
    }
    setState(() {});
    _planHideControls();
  }

  void _toggleMute() {
    _muted = !_muted;
    _controller?.setVolume(_muted ? 0 : 1);
    setState(() {});
    _planHideControls();
  }

  void _seek(double seconds) {
    _controller?.seekTo(Duration(seconds: seconds.floor()));
  }

  void _onDrag(DragUpdateDetails d) {
    if (_position == null) return;
    final size = MediaQuery.of(context).size;
    final margin = 8.0;
    var next = _position! + d.delta;
    // Contrainte dans l'écran
    final maxX = size.width - _currentWidth - margin;
    final maxY = size.height - _currentHeight - margin;
    next = Offset(
      next.dx.clamp(margin, maxX),
      next.dy.clamp(margin, maxY),
    );
    setState(() => _position = next);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_position == null) return;
    final size = MediaQuery.of(context).size;
    const margin = 16.0;

    final corners = <Offset>[
      Offset(margin, margin), // top-left
      Offset(size.width - _currentWidth - margin, margin), // top-right
      Offset(margin, size.height - _currentHeight - margin), // bottom-left
      Offset(size.width - _currentWidth - margin, size.height - _currentHeight - margin), // bottom-right
    ];

    // Choisir le coin le plus proche
    Offset best = corners.first;
    double bestDist = (best - _position!).distanceSquared;
    for (final c in corners.skip(1)) {
      final d = (c - _position!).distanceSquared;
      if (d < bestDist) {
        best = c;
        bestDist = d;
      }
    }

    setState(() => _position = best);
  }

  void _toggleMini() {
    setState(() {
      _isMini = !_isMini;
      // S'assurer que la position reste dans l'écran
      final size = MediaQuery.of(context).size;
      const margin = 8.0;
      final maxX = size.width - _currentWidth - margin;
      final maxY = size.height - _currentHeight - margin;
      _position = Offset(
        _position!.dx.clamp(margin, maxX),
        _position!.dy.clamp(margin, maxY),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_positionInitialized || _position == null) {
      return const SizedBox.shrink();
    }

    final isReady = _controller != null && _controller!.value.isInitialized;

    return IgnorePointer(
      ignoring: false, // On n'ignore pas les pointeurs sur la fenêtre flottante
      child: Stack(children: [
        // Toute zone hors de la fenêtre reste interactive pour l'app dessous

        // Lecteur flottant positionné avec animation
        AnimatedPositioned(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          left: _position!.dx,
          top: _position!.dy,
          width: _currentWidth,
          height: _currentHeight,
          child: GestureDetector(
            onPanUpdate: _onDrag,
            onPanEnd: _onDragEnd,
            onTap: () {
              setState(() => _showControls = !_showControls);
              if (_showControls) _planHideControls();
            },
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8)),
                  ],
                ),
                child: Stack(children: [
                  // Vidéo
                  Positioned.fill(
                    child: isReady
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller!.value.size.width,
                              height: _controller!.value.size.height,
                              child: VideoPlayer(_controller!),
                            ),
                          )
                        : _buildLoading(),
                  ),

                  // Top bar
                  if (_showControls)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Text(
                              widget.video.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ),
                          IconButton(
                            tooltip: _isMini ? 'Agrandir' : 'Minimiser',
                            onPressed: _toggleMini,
                            icon: Icon(_isMini ? Icons.open_in_full_rounded : Icons.close_fullscreen_rounded, color: Colors.white),
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: _muted ? 'Activer le son' : 'Couper le son',
                            onPressed: _toggleMute,
                            icon: Icon(_muted ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: Colors.white),
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Fermer',
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close_rounded, color: Colors.white),
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                          ),
                        ]),
                      ),
                    ),

                  // Centre: Play/Pause
                  if (_showControls)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(28)),
                        child: IconButton(
                          onPressed: _togglePlayPause,
                          icon: Icon((_controller?.value.isPlaying ?? false) ? Icons.pause_rounded : Icons.play_arrow_rounded),
                          color: Colors.white,
                          iconSize: 36,
                        ),
                      ),
                    ),

                  // Bas: timeline (compacte)
                  if (_showControls)
                    Positioned(
                      left: 6,
                      right: 6,
                      bottom: 4,
                      child: _buildTimeline(),
                    ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildLoading() {
    return Stack(fit: StackFit.expand, children: [
      Image.network(
        widget.video.thumbnailUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
      ),
      const Center(child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2)),
    ]);
  }

  Widget _buildTimeline() {
    final value = _controller?.value;
    final duration = value?.duration ?? Duration.zero;
    final position = value?.position ?? Duration.zero;
    double max = duration.inSeconds.toDouble();
    if (!max.isFinite || max <= 0) max = 1;

    return Row(children: [
      Text(_fmt(position), style: const TextStyle(color: Colors.white70, fontSize: 10)),
      Expanded(
        child: Slider(
          value: position.inSeconds.clamp(0, max.toInt()).toDouble(),
          min: 0,
          max: max,
          onChanged: (v) {
            _seek(v);
            _planHideControls();
          },
          activeColor: Colors.white,
          inactiveColor: Colors.white24,
        ),
      ),
      Text(_fmt(duration), style: const TextStyle(color: Colors.white70, fontSize: 10)),
    ]);
  }

  String _fmt(Duration d) {
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    final h = d.inHours;
    if (h > 0) return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
