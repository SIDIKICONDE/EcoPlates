import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/video_preview.dart';
import '../../../providers/videos_provider.dart';
import '../../../screens/all_videos_page.dart';
import '../../video_card/video_card.dart';
import '../../video_player/floating_video_modal.dart';

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
          padding: EdgeInsets.fromLTRB(
            20.0,
            8.0,
            20.0,
            20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vidéos & Astuces',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: DeepColorTokens.neutral900,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      unawaited(
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const AllVideosPage(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 16.0,
                      color: DeepColorTokens.primary,
                    ),
                    label: Text(
                      'Voir tout',
                      style: TextStyle(
                        color: DeepColorTokens.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Liste horizontale de vidéos avec cartes verticales compactes
        SizedBox(
          height: 240.0,
          child: videosAsync.when(
            data: (videos) {
              if (videos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.play_circle_outline,
                        size: 48.0,
                        color: DeepColorTokens.neutral500,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Aucune vidéo disponible',
                        style: TextStyle(
                          color: DeepColorTokens.neutral700,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Convertir VideoData en VideoPreview pour utiliser VideoCard
              final videoPreviews = videos
                  .map(
                    (v) => VideoPreview(
                      id: v.id,
                      title: v.title,
                      description: v.description,
                      videoUrl: v.videoUrl,
                      thumbnailUrl: v.thumbnailUrl,
                      merchantId: v.merchantName.toLowerCase().replaceAll(
                        ' ',
                        '-',
                      ),
                      merchantName: v.merchantName,
                      duration: _parseDuration(v.duration),
                      viewCount: v.views,
                      publishedAt: v.publishedAt,
                    ),
                  )
                  .toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: videoPreviews.length,
                itemBuilder: (context, index) {
                  final video = videoPreviews[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: SizedBox(
                      width: 160.0,
                      child: VideoCard(
                        video: video,
                        width: 160.0,
                        height: 120.0,
                        onTap: () {
                          _showVideoModal(context, video);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.0,
                    color: DeepColorTokens.error,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: DeepColorTokens.neutral700,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
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

        SizedBox(height: 20.0),
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
    return Duration.zero;
  }

  void _showVideoModal(BuildContext context, VideoPreview video) {
    // Utiliser la fonction fournie par le module video_player
    unawaited(showFloatingVideoModal(context, video));
  }
}
