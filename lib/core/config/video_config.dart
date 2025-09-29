import 'package:flutter/foundation.dart';

/// Configuration for video optimization and CDN
class VideoConfig {
  VideoConfig._();

  /// CDN base URL for video streaming
  /// In production, this should point to your CDN (CloudFront, Cloudinary, etc.)
  static String get cdnBaseUrl {
    if (kDebugMode) {
      // In debug mode, use local assets
      return '';
    }
    // TODO: Replace with your actual CDN URL
    return const String.fromEnvironment(
      'CDN_BASE_URL',
      defaultValue: 'https://cdn.ecoplates.com/videos',
    );
  }

  /// Whether to use CDN for video streaming
  static bool get useCDN => cdnBaseUrl.isNotEmpty && !kDebugMode;

  /// Maximum video cache size in MB
  static const int maxVideoCacheSizeMB = 100;

  /// Video quality presets
  static const Map<VideoQuality, VideoQualityConfig> qualityPresets = {
    VideoQuality.low: VideoQualityConfig(
      resolution: '480p',
      bitrate: 500, // kbps
      suffix: '_480p',
    ),
    VideoQuality.medium: VideoQualityConfig(
      resolution: '720p',
      bitrate: 1000, // kbps
      suffix: '_720p',
    ),
    VideoQuality.high: VideoQualityConfig(
      resolution: '1080p',
      bitrate: 2000, // kbps
      suffix: '_1080p',
    ),
  };

  /// Get optimal quality based on network conditions
  static VideoQuality getOptimalQuality({
    required double networkSpeedMbps,
    required bool isWifi,
    required bool dataSaverEnabled,
  }) {
    if (dataSaverEnabled) {
      return VideoQuality.low;
    }

    if (!isWifi && networkSpeedMbps < 2.0) {
      return VideoQuality.low;
    }

    if (networkSpeedMbps >= 5.0) {
      return VideoQuality.high;
    } else if (networkSpeedMbps >= 2.0) {
      return VideoQuality.medium;
    }

    return VideoQuality.low;
  }

  /// Build video URL with quality suffix
  static String buildVideoUrl(String baseUrl, VideoQuality quality) {
    if (!useCDN) {
      // Return local asset path as-is
      return baseUrl;
    }

    final config = qualityPresets[quality]!;
    final extension = baseUrl.split('.').last;
    final nameWithoutExtension = baseUrl.substring(0, baseUrl.lastIndexOf('.'));
    
    // For CDN, append quality suffix
    return '$cdnBaseUrl/$nameWithoutExtension${config.suffix}.$extension';
  }

  /// Video preloading configuration
  static const int preloadNextVideos = 2;
  static const double preloadStartThreshold = 0.8; // Start preloading at 80% completion

  /// Lazy loading configuration
  static const double lazyLoadThreshold = 200; // pixels before viewport
  static const int initialLoadCount = 3; // Number of videos to load initially
}

enum VideoQuality { low, medium, high }

class VideoQualityConfig {

  const VideoQualityConfig({
    required this.resolution,
    required this.bitrate,
    required this.suffix,
  });
  final String resolution;
  final int bitrate;
  final String suffix;
}

/// Adaptive bitrate streaming configuration
class AdaptiveBitrateConfig {
  AdaptiveBitrateConfig._();

  /// Enable adaptive bitrate switching
  static const bool enabled = true;

  /// Network speed check interval
  static const Duration checkInterval = Duration(seconds: 5);

  /// Quality switch threshold (avoid frequent switching)
  static const double switchThresholdMbps = 1;

  /// Buffer configuration
  static const Duration minBufferDuration = Duration(seconds: 10);
  static const Duration maxBufferDuration = Duration(seconds: 30);
  
  /// Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
