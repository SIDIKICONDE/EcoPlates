import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/design_tokens.dart';
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
            context.scaleMD_LG_XL_XXL,
            context.scaleXS_SM_MD_LG,
            context.scaleMD_LG_XL_XXL,
            context.scaleMD_LG_XL_XXL,
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
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                    ),
                  ),
                  Text(
                    'Recettes et conseils anti-gaspi',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
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
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),

        // Liste horizontale de vidéos avec cartes verticales compactes
        SizedBox(
          height:
              EcoPlatesDesignTokens.layout.merchantCardHeight(context) * 0.8,
          child: videosAsync.when(
            data: (videos) {
              if (videos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: EcoPlatesDesignTokens.size.modalIcon(context),
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.subtle,
                            ),
                      ),
                      SizedBox(height: context.scaleXS_SM_MD_LG),
                      Text(
                        'Aucune vidéo disponible',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(
                                alpha:
                                    EcoPlatesDesignTokens.opacity.almostOpaque,
                              ),
                          fontSize: EcoPlatesDesignTokens.typography.text(
                            context,
                          ),
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
                  horizontal: context.scaleMD_LG_XL_XXL,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: videoPreviews.length,
                itemBuilder: (context, index) {
                  final video = videoPreviews[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXXS_XS_SM_MD,
                    ),
                    child: SizedBox(
                      width:
                          EcoPlatesDesignTokens.layout.merchantCardHeight(
                            context,
                          ) *
                          0.6,
                      child: VideoCard(
                        video: video,
                        width:
                            EcoPlatesDesignTokens.layout.merchantCardHeight(
                              context,
                            ) *
                            0.6,
                        height:
                            EcoPlatesDesignTokens.layout.merchantCardHeight(
                              context,
                            ) *
                            0.7,
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
                    size: EcoPlatesDesignTokens.size.modalIcon(context),
                    color: EcoPlatesDesignTokens.colors.snackbarError
                        .withValues(
                          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                        ),
                  ),
                  SizedBox(height: context.scaleXS_SM_MD_LG),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: EcoPlatesDesignTokens.colors.snackbarError,
                    ),
                  ),
                  SizedBox(height: context.scaleXS_SM_MD_LG),
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

        SizedBox(height: context.scaleMD_LG_XL_XXL),
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
