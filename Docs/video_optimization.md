# Video Optimization Guide for EcoPlates

## Current Issues
- Large video files (4-24MB) are bundled with the app
- No CDN/streaming implementation
- No adaptive bitrate support
- Limited caching optimization

## Recommended Solutions

### 1. Immediate Optimizations (P2)

#### a) Compress Existing Videos
```bash
# Install ffmpeg if not already installed
# Then compress videos to multiple qualities:

# Low quality (480p)
ffmpeg -i assets/videos/Pizza.mp4 -vf scale=854:480 -c:v libx264 -crf 28 -preset fast -c:a aac -b:a 128k assets/videos/Pizza_480p.mp4

# Medium quality (720p) 
ffmpeg -i assets/videos/Pizza.mp4 -vf scale=1280:720 -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k assets/videos/Pizza_720p.mp4

# High quality (1080p)
ffmpeg -i assets/videos/Pizza.mp4 -vf scale=1920:1080 -c:v libx264 -crf 20 -preset fast -c:a aac -b:a 256k assets/videos/Pizza_1080p.mp4
```

#### b) Implement Lazy Loading
The `VideoPoolManager` already exists. Enhance it with:
- Viewport-based loading (only load videos in view)
- Preload next 2 videos when user scrolls
- Dispose controllers when videos go out of view

#### c) Use Thumbnail Previews
- Generate static thumbnails for each video
- Show thumbnail until video needs to play
- Reduces initial load time significantly

### 2. CDN Integration (P3)

#### a) Upload Videos to CDN
Options:
- **Cloudinary**: Good for automatic optimization
- **AWS CloudFront**: Cost-effective for high volume
- **Bunny CDN**: Simple and affordable

#### b) Implement Adaptive Streaming
```dart
// Use the VideoConfig class created above
final videoUrl = VideoConfig.buildVideoUrl(
  baseVideoPath,
  VideoConfig.getOptimalQuality(
    networkSpeedMbps: connectionSpeed,
    isWifi: isWifi,
    dataSaverEnabled: dataSaverEnabled,
  ),
);
```

#### c) Progressive Enhancement
- Start with lowest quality
- Upgrade quality as buffer allows
- Downgrade on network issues

### 3. Advanced Optimizations (Future)

#### a) HLS/DASH Streaming
- Convert videos to HLS format for true adaptive streaming
- Use video_player package with HLS support
- Automatic quality switching based on bandwidth

#### b) Edge Caching
- Use CDN edge locations
- Implement geographic routing
- Reduce latency for global users

#### c) P2P Video Delivery
- Implement WebRTC for peer-assisted delivery
- Reduce CDN costs
- Better performance in high-traffic scenarios

## Implementation Priority

1. **Phase 1 (Immediate)**
   - Compress existing videos to 3 quality levels
   - Implement viewport-based lazy loading
   - Add thumbnail previews

2. **Phase 2 (Next Sprint)**
   - Set up CDN account
   - Upload compressed videos
   - Implement quality selection based on network

3. **Phase 3 (Future)**
   - Convert to HLS/DASH
   - Implement full adaptive streaming
   - Add offline video caching

## Performance Metrics to Track

- Initial app size reduction: Target 50% reduction
- Video start time: Target < 2 seconds
- Buffering events: Target < 1 per video
- Data usage: 60% reduction on mobile networks

## Code Examples

### Enhanced Video Widget
```dart
class OptimizedVideoCard extends StatelessWidget {
  final String videoPath;
  final String thumbnailPath;
  
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(videoPath),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          // Start loading video
          context.read(videoPoolManagerProvider).preloadVideo(videoPath);
        } else {
          // Pause/dispose if out of view
          context.read(videoPoolManagerProvider).pauseVideo(videoPath);
        }
      },
      child: VideoPlayer(
        videoPath: videoPath,
        thumbnailPath: thumbnailPath,
      ),
    );
  }
}
```

### Network-Aware Loading
```dart
class NetworkAwareVideoLoader {
  Stream<VideoQuality> getOptimalQuality() async* {
    final connectivity = Connectivity();
    
    await for (final result in connectivity.onConnectivityChanged) {
      if (result == ConnectivityResult.wifi) {
        yield VideoQuality.high;
      } else if (result == ConnectivityResult.mobile) {
        // Check actual speed
        final speed = await measureNetworkSpeed();
        yield VideoConfig.getOptimalQuality(
          networkSpeedMbps: speed,
          isWifi: false,
          dataSaverEnabled: await isDataSaverEnabled(),
        );
      } else {
        yield VideoQuality.low;
      }
    }
  }
}
```

## Testing Recommendations

1. Test on low-end devices with limited RAM
2. Test on 3G/slow networks
3. Monitor memory usage during video playback
4. Track app size before/after optimization

## Resources

- [FFmpeg Compression Guide](https://trac.ffmpeg.org/wiki/Encode/H.264)
- [Flutter Video Optimization](https://flutter.dev/docs/development/ui/assets-and-images#video)
- [CDN Comparison](https://www.cdnplanet.com/compare/)
- [HLS Implementation Guide](https://developer.apple.com/streaming/)