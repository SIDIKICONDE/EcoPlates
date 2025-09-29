import 'package:flutter/material.dart';
import '../../core/services/video_pool_manager.dart' as core_services;

/// Widget wrapper qui gère automatiquement la pause/reprise des vidéos
/// selon l'état de l'application (avant-plan/arrière-plan)
class VideoPoolManager extends StatefulWidget {
  const VideoPoolManager({
    required this.child,
    super.key,
    this.autoPauseOnBackground = true,
    this.autoResumeOnForeground = true,
  });
  final bool autoPauseOnBackground;
  final bool autoResumeOnForeground;
  final Widget child;

  @override
  State<VideoPoolManager> createState() => _VideoPoolManagerState();
}

class _VideoPoolManagerState extends State<VideoPoolManager>
    with WidgetsBindingObserver {
  final core_services.VideoPoolManager _poolManager =
      core_services.VideoPoolManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        if (widget.autoPauseOnBackground) {
          _poolManager.disposeAll();
        }
      case AppLifecycleState.resumed:
        // Les vidéos se réinitialiseront automatiquement quand elles seront rejouées
        break;
      case AppLifecycleState.detached:
        _poolManager.disposeAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
