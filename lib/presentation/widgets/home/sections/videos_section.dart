import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/videos_provider.dart';
import '../../../../domain/entities/video_preview.dart';
import '../../video_card/video_card.dart';
import '../../video_player/floating_video_modal.dart';
import '../../../screens/all_videos_page.dart';
/// Section affichant les vidéos de recettes et conseils anti-gaspi
class VideosSection extends ConsumerWidget {
  const VideosSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(videosProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vidéos & Astuces',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Recettes et conseils anti-gaspi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllVideosPage(),
                    ),
                  );
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),
        
        // Liste horizontale de vidéos avec cartes verticales compactes
        SizedBox(
          height: 140, // Hauteur réduite de 50%
          child: videosAsync.when(
            data: (videos) {
              if (videos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aucune vidéo disponible',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Convertir VideoData en VideoPreview pour utiliser VideoCard
              final videoPreviews = videos.map((v) => VideoPreview(
                id: v.id,
                title: v.title,
                description: v.description,
                videoUrl: v.videoUrl,
                thumbnailUrl: v.thumbnailUrl,
                merchantId: v.merchantName.toLowerCase().replaceAll(' ', '-'),
                merchantName: v.merchantName,
                duration: _parseDuration(v.duration),
                viewCount: v.views,
                publishedAt: v.publishedAt,
                tags: [],
                focalPoint: VideoFocalPoint.center,
              )).toList();
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: videoPreviews.length,
                itemBuilder: (context, index) {
                  final video = videoPreviews[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SizedBox(
                      width: 100, // Largeur réduite de 50%
                      child: VideoCard(
                        video: video,
                        width: 100,
                        height: 130, // Hauteur réduite de 50%
                        play: false, // Ne pas jouer automatiquement dans la liste
                        onTap: () {
                          _showVideoModal(context, video);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      ref.invalidate(videosProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Duration _parseDuration(String durationStr) {
    final parts = durationStr.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return const Duration(minutes: 0);
  }

  void _showVideoModal(BuildContext context, VideoPreview video) {
    // Utiliser la fonction fournie par le module video_player
    showFloatingVideoModal(context, video);
  }
}