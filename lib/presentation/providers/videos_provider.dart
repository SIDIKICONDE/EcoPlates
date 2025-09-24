import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modèle pour les données vidéo
class VideoData {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String merchantName;
  final String duration;
  final int views;
  final int likes;
  final bool isLiked;
  final String description;
  final DateTime publishedAt;

  const VideoData({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.merchantName,
    required this.duration,
    required this.views,
    required this.likes,
    this.isLiked = false,
    required this.description,
    required this.publishedAt,
  });
}

/// Provider pour les vidéos de recettes et conseils anti-gaspi
final videosProvider = FutureProvider<List<VideoData>>((ref) async {
  // Simuler un appel API
  await Future.delayed(const Duration(milliseconds: 500));
  
  // Données mockées de vidéos
  final now = DateTime.now();
  return [
    VideoData(
      id: 'video-1',
      title: '5 astuces anti-gaspi en cuisine',
      thumbnailUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      merchantName: 'Chef Marie',
      duration: '3:45',
      views: 15420,
      likes: 892,
      isLiked: false,
      description: 'Découvrez comment réduire le gaspillage alimentaire avec ces astuces simples',
      publishedAt: now.subtract(const Duration(days: 2)),
    ),
    VideoData(
      id: 'video-2',
      title: 'Recette : Pain perdu aux fruits de saison',
      thumbnailUrl: 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      merchantName: 'Boulangerie Paul',
      duration: '5:20',
      views: 8932,
      likes: 567,
      isLiked: true,
      description: 'Transformez votre pain rassis en délicieux dessert',
      publishedAt: now.subtract(const Duration(days: 5)),
    ),
    VideoData(
      id: 'video-3',
      title: 'Comment conserver vos légumes plus longtemps',
      thumbnailUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      merchantName: 'Green Bowl',
      duration: '4:15',
      views: 12789,
      likes: 1023,
      isLiked: false,
      description: 'Techniques de conservation pour garder vos légumes frais',
      publishedAt: now.subtract(const Duration(hours: 12)),
    ),
    VideoData(
      id: 'video-4',
      title: 'Batch cooking : Préparer ses repas à l\'avance',
      thumbnailUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      merchantName: 'Le Bistrot du Coin',
      duration: '8:30',
      views: 21456,
      likes: 2341,
      isLiked: false,
      description: 'Organisez vos repas de la semaine et évitez le gaspillage',
      publishedAt: now.subtract(const Duration(days: 1)),
    ),
    VideoData(
      id: 'video-5',
      title: 'Smoothie zéro déchet avec épluchures',
      thumbnailUrl: 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      merchantName: 'Smoothie Bar',
      duration: '2:55',
      views: 6543,
      likes: 432,
      isLiked: true,
      description: 'Utilisez toutes les parties de vos fruits pour des smoothies nutritifs',
      publishedAt: now.subtract(const Duration(days: 3)),
    ),
    VideoData(
      id: 'video-6',
      title: 'Congélation : Les bonnes pratiques',
      thumbnailUrl: 'https://images.unsplash.com/photo-1597843786411-a7fa8ad44a95?w=400',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      merchantName: 'Picard',
      duration: '6:45',
      views: 9876,
      likes: 789,
      isLiked: false,
      description: 'Tout savoir sur la congélation pour préserver vos aliments',
      publishedAt: now.subtract(const Duration(hours: 6)),
    ),
  ];
});

/// Provider pour filtrer les vidéos populaires (> 10k vues)
final popularVideosProvider = Provider<List<VideoData>>((ref) {
  final videosAsync = ref.watch(videosProvider);
  
  return videosAsync.when(
    data: (videos) => videos.where((v) => v.views > 10000).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});