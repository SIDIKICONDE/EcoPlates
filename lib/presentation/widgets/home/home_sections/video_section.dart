import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/video_preview.dart';
import '../../video_card/index.dart';

/// Section "Vidéos des commerçants" - Vidéos promotionnelles style Apple TV+
class VideoSection extends ConsumerWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Remplacer par un provider réel qui charge les vidéos depuis l'API
    final videos = _getMockVideos();

    return VideoPoolManager(
      autoPauseOnBackground: true,
      autoResumeOnForeground: false, // Économie de batterie
      child: VideoSlider(
        title: VideoSectionConstants.sectionTitle,
        videos: videos,
        height: VideoSectionConstants.videoSliderHeight,
        onVideoTap: (video) {
          // Lecture en modal flottant (in-app PiP)
          showFloatingVideoModal(context, video);
        },
        onSeeAllTap: () {
          // Navigation vers la page de toutes les vidéos
          context.push(VideoSectionConstants.videosRoute);
        },
      ),
    );
  }

  // Données de test pour le développement
  List<VideoPreview> _getMockVideos() {
    final now = DateTime.now();
    
    return [
      VideoPreview(
        id: '1',
        title: 'Préparation de nos pizzas artisanales',
        description: 'Découvrez comment nous préparons nos pizzas avec amour',
        videoUrl: 'https://videos.pexels.com/video-files/5056427/5056427-uhd_2732_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/5056427/pictures/preview-0.jpg',
        merchantId: 'pizza_mario',
        merchantName: 'Pizza Mario',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1555992336-fb0d29498b13?w=100',
        duration: const Duration(minutes: 1, seconds: 12),
        viewCount: 1250,
        publishedAt: now.subtract(const Duration(hours: 2)),
        isFeatured: true,
        tags: ['Italien', 'Pizza', 'Artisanal'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '2',
        title: 'Sushis frais préparés à la commande',
        videoUrl: 'https://videos.pexels.com/video-files/3163534/3163534-uhd_2560_1440_30fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/3163534/pictures/preview-0.jpg',
        merchantId: 'sushi_zen',
        merchantName: 'Sushi Zen',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        duration: const Duration(seconds: 45),
        viewCount: 890,
        publishedAt: now.subtract(const Duration(hours: 5)),
        tags: ['Japonais', 'Sushi'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '3',
        title: 'Croissants fraîchement sortis du four',
        videoUrl: 'https://videos.pexels.com/video-files/4110489/4110489-uhd_2560_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/4110489/pictures/preview-0.jpg',
        merchantId: 'boulangerie_paul',
        merchantName: 'Boulangerie Paul',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        duration: const Duration(minutes: 1, seconds: 15),
        viewCount: 2300,
        publishedAt: now.subtract(const Duration(days: 1)),
        tags: ['Boulangerie', 'Pâtisserie', 'Français'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '4',
        title: 'Burgers gourmets grillés à la perfection',
        videoUrl: 'https://videos.pexels.com/video-files/4253701/4253701-uhd_2560_1440_30fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/4253701/pictures/preview-0.jpg',
        merchantId: 'burger_factory',
        merchantName: 'Burger Factory',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        duration: const Duration(minutes: 1, seconds: 28),
        viewCount: 1890,
        publishedAt: now.subtract(const Duration(days: 2)),
        isFeatured: true,
        tags: ['Américain', 'Burger', 'Street Food'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '5',
        title: 'Salade healthy du chef',
        videoUrl: 'https://videos.pexels.com/video-files/2620043/2620043-uhd_2560_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/2620043/pictures/preview-0.jpg',
        merchantId: 'green_bowl',
        merchantName: 'Green Bowl',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616c041ad7e?w=100',
        duration: const Duration(seconds: 30),
        viewCount: 670,
        publishedAt: now.subtract(const Duration(days: 3)),
        tags: ['Healthy', 'Végétarien', 'Salade'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '6',
        title: 'Préparation de tacos maison',
        videoUrl: 'https://videos.pexels.com/video-files/4098737/4098737-uhd_2560_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/4098737/pictures/preview-0.jpg',
        merchantId: 'el_taco_loco',
        merchantName: 'El Taco Loco',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        duration: const Duration(seconds: 42),
        viewCount: 1120,
        publishedAt: now.subtract(const Duration(days: 4)),
        tags: ['Mexicain', 'Tacos', 'Épicé'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '7',
        title: 'Pâtes fraîches faites maison',
        videoUrl: 'https://videos.pexels.com/video-files/4087239/4087239-uhd_2560_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/4087239/pictures/preview-0.jpg',
        merchantId: 'pasta_fresca',
        merchantName: 'Pasta Fresca',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        duration: const Duration(minutes: 1, seconds: 5),
        viewCount: 980,
        publishedAt: now.subtract(const Duration(days: 1)),
        tags: ['Italien', 'Pâtes', 'Fait maison'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '8',
        title: 'Café artisanal préparé avec soin',
        videoUrl: 'https://videos.pexels.com/video-files/2880569/2880569-uhd_2560_1440_24fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/2880569/pictures/preview-0.jpg',
        merchantId: 'coffee_lab',
        merchantName: 'Coffee Lab',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616c041ad7e?w=100',
        duration: const Duration(seconds: 48),
        viewCount: 567,
        publishedAt: now.subtract(const Duration(hours: 12)),
        tags: ['Café', 'Boisson', 'Artisanal'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '9',
        title: 'Desserts gourmands du jour',
        videoUrl: 'https://videos.pexels.com/video-files/3195394/3195394-uhd_2560_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/3195394/pictures/preview-0.jpg',
        merchantId: 'sweet_delights',
        merchantName: 'Sweet Delights',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        duration: const Duration(seconds: 35),
        viewCount: 1450,
        publishedAt: now.subtract(const Duration(hours: 6)),
        isFeatured: true,
        tags: ['Dessert', 'Pâtisserie', 'Gourmand'],
        focalPoint: VideoFocalPoint.center,
      ),
      VideoPreview(
        id: '10',
        title: 'Smoothies vitaminés et jus frais',
        videoUrl: 'https://videos.pexels.com/video-files/6003196/6003196-uhd_2560_1440_25fps.mp4',
        thumbnailUrl: 'https://images.pexels.com/videos/6003196/pictures/preview-0.jpg',
        merchantId: 'juice_bar',
        merchantName: 'Juice Bar',
        merchantAvatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        duration: const Duration(seconds: 25),
        viewCount: 340,
        publishedAt: now.subtract(const Duration(days: 2)),
        tags: ['Boisson', 'Healthy', 'Smoothie'],
        focalPoint: VideoFocalPoint.center,
      ),
    ];
  }
}