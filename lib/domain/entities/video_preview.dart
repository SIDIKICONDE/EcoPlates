import 'package:equatable/equatable.dart';

/// Point focal pour le cadrage vidéo (pas de dépendance Flutter dans le domaine)
enum VideoFocalPoint { center, top, bottom }

/// Entité représentant une vidéo de présentation d'un commerçant
class VideoPreview extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String videoUrl;
  final String thumbnailUrl;
  final String merchantId;
  final String merchantName;
  final String? merchantAvatarUrl;
  final Duration duration;
  final int viewCount;
  final DateTime publishedAt;
  final bool isFeatured;
  final List<String> tags;
  final VideoFocalPoint focalPoint;
  
  const VideoPreview({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.merchantId,
    required this.merchantName,
    this.merchantAvatarUrl,
    required this.duration,
    this.viewCount = 0,
    required this.publishedAt,
    this.isFeatured = false,
    this.tags = const [],
    this.focalPoint = VideoFocalPoint.center,
  });

  /// Label sémantique pour l'accessibilité
  String get semanticLabel {
    final buffer = StringBuffer();
    buffer.write('Vidéo: $title par $merchantName. ');
    buffer.write('Durée: ${_formatDuration(duration)}. ');
    if (viewCount > 0) {
      buffer.write('$viewCount vues. ');
    }
    if (isFeatured) {
      buffer.write('Vidéo mise en avant. ');
    }
    return buffer.toString();
  }

  /// Formatage de la durée pour l'affichage
  String get formattedDuration => _formatDuration(duration);

  /// Formatage du nombre de vues
  String get formattedViewCount {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  /// Formatage de la date de publication
  String get formattedPublishedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Il y a ${difference.inMinutes} min';
      }
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else if (difference.inDays < 30) {
      return 'Il y a ${(difference.inDays / 7).floor()} sem';
    } else if (difference.inDays < 365) {
      return 'Il y a ${(difference.inDays / 30).floor()} mois';
    }
    return 'Il y a ${(difference.inDays / 365).floor()} an${(difference.inDays / 365).floor() > 1 ? 's' : ''}';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        videoUrl,
        thumbnailUrl,
        merchantId,
        merchantName,
        merchantAvatarUrl,
        duration,
        viewCount,
        publishedAt,
        isFeatured,
        tags,
        focalPoint,
      ];
}