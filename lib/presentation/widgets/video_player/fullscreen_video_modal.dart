import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../core/services/video_pool_manager.dart';
import '../../../domain/entities/video_preview.dart';

/// Ouvre un lecteur vidéo en modal plein écran
Future<void> showFullscreenVideoModal(BuildContext context, VideoPreview video) async {
  await Navigator.of(context).push(
    PageRouteBuilder(
      opaque: true,
      barrierColor: Colors.black,
      pageBuilder: (_, __, ___) => FullscreenVideoModal(video: video),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    ),
  );
}

class FullscreenVideoModal extends StatefulWidget {
  const FullscreenVideoModal({super.key, required this.video});

  final VideoPreview video;

  @override
  State<FullscreenVideoModal> createState() => _FullscreenVideoModalState();
}

class _FullscreenVideoModalState extends State<FullscreenVideoModal> {
  final VideoPoolManager _pool = VideoPoolManager();
  VideoPlayerController? _controller;
  bool _showControls = true;
  bool _muted = true;
  Timer? _hideTimer;

  void _scheduleHideControls() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  Future<void> _init() async {
    try {
      // Récupère ou crée un contrôleur via le pool
      _controller = _pool.getController(widget.video.videoUrl) ??
          await _pool.createController(widget.video.videoUrl);

      if (!mounted) return;

      // Configuration du contrôleur
      await _controller!.setLooping(true);
      await _controller!.setVolume(_muted ? 0 : 1);
      await _controller!.play();

      // Écoute les changements pour rafraîchir l'UI (position, état)
      _controller!.addListener(() {
        if (!mounted) return;
        // Rafraîchir légèrement (on ne setState que si nécessaire serait mieux, mais suffisant ici)
        setState(() {});
      });

      setState(() {});
    } catch (e) {
      debugPrint('Erreur init modal vidéo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Mode plein écran immersif
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _init();
    _scheduleHideControls();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    // On ne dispose pas le controller ici (pool gère le cycle). On met en pause pour économiser.
    _controller?.pause();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    final isPlaying = _controller!.value.isPlaying;
    if (isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    setState(() {});
    _scheduleHideControls();
  }

  void _toggleMute() {
    _muted = !_muted;
    _controller?.setVolume(_muted ? 0 : 1);
    setState(() {});
    _scheduleHideControls();
  }

  void _onSeek(double seconds) {
    if (_controller == null) return;
    _controller!.seekTo(Duration(seconds: seconds.floor()));
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _controller != null && _controller!.value.isInitialized;

    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls) _scheduleHideControls();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              // Contenu vidéo
              Positioned.fill(
                child: isReady
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio == 0
                              ? 16 / 9
                              : _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      )
                    : _buildLoading(),
              ),

              // Barre supérieure
              if (_showControls) _buildTopBar(context),

              // Contrôles centraux
              if (_showControls) _buildCenterControls(),

              // Barre inférieure (timeline)
              if (_showControls) _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Placeholder image si disponible
        Image.network(
          widget.video.thumbnailUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
        ),
        const Center(
          child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Fermer',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.video.merchantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: _muted ? 'Activer le son' : 'Couper le son',
              onPressed: _toggleMute,
              icon: Icon(_muted ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls() {
    final isPlaying = _controller?.value.isPlaying ?? false;
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(40)),
        child: IconButton(
          onPressed: _togglePlayPause,
          iconSize: 56,
          color: Colors.white,
          icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final value = _controller?.value;
    final duration = value?.duration ?? Duration.zero;
    final position = value?.position ?? Duration.zero;

    double max = duration.inSeconds.toDouble();
    if (!max.isFinite || max <= 0) max = 1;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(_format(position), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: position.inSeconds.clamp(0, max.toInt()).toDouble(),
                    min: 0,
                    max: max,
                    onChanged: (v) {
                      _onSeek(v);
                      _scheduleHideControls();
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white24,
                  ),
                ),
                const SizedBox(width: 8),
                Text(_format(duration), style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
