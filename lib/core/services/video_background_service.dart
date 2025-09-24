import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service pour gérer la lecture vidéo en arrière-plan
/// Alternative au PiP natif pour les vidéos Flutter
class VideoBackgroundService {
  factory VideoBackgroundService() => _instance;
  VideoBackgroundService._internal();
  static final VideoBackgroundService _instance = VideoBackgroundService._internal();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialiser le service de notification
  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    _isInitialized = true;
  }

  /// Afficher la notification de contrôle vidéo
  Future<void> showVideoNotification({
    required String title,
    required String merchant,
    required bool isPlaying,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'video_player',
      'Lecteur vidéo',
      channelDescription: 'Contrôles de lecture vidéo',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      showWhen: false,
      enableVibration: false,
      playSound: false,
      actions: [
        AndroidNotificationAction(
          'play_pause',
          'Play/Pause',
        ),
        AndroidNotificationAction(
          'stop',
          'Fermer',
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1, // ID fixe pour la notification vidéo
      title,
      '$merchant • ${isPlaying ? "En lecture" : "En pause"}',
      details,
    );
  }

  /// Masquer la notification
  Future<void> hideVideoNotification() async {
    await _notifications.cancel(1);
  }

  void _handleNotificationResponse(NotificationResponse response) {
    // Gérer les actions de la notification
    switch (response.actionId) {
      case 'play_pause':
        VideoNotificationEvents.playPausePressed();
      case 'stop':
        VideoNotificationEvents.stopPressed();
    }
  }
}

/// Gestionnaire d'événements pour les actions de notification
class VideoNotificationEvents {
  static final _playPauseCallbacks = <VoidCallback>[];
  static final _stopCallbacks = <VoidCallback>[];

  static void onPlayPause(VoidCallback callback) {
    _playPauseCallbacks.add(callback);
  }

  static void onStop(VoidCallback callback) {
    _stopCallbacks.add(callback);
  }

  static void removePlayPauseListener(VoidCallback callback) {
    _playPauseCallbacks.remove(callback);
  }

  static void removeStopListener(VoidCallback callback) {
    _stopCallbacks.remove(callback);
  }

  static void playPausePressed() {
    for (final callback in _playPauseCallbacks) {
      callback();
    }
  }

  static void stopPressed() {
    for (final callback in _stopCallbacks) {
      callback();
    }
  }
}
