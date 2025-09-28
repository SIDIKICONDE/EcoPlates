import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/context_responsive_extensions.dart';
import '../../core/responsive/design_tokens.dart';
import '../../core/responsive/responsive_grid.dart';
import '../../core/services/image_cache_service.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/video_preview.dart';
import '../providers/videos_provider.dart';
import '../widgets/video_card/video_card.dart';
import '../widgets/video_player/floating_video_modal.dart';

/// Page affichant toutes les vidéos disponibles
class AllVideosPage extends ConsumerStatefulWidget {
  const AllVideosPage({super.key});

  @override
  ConsumerState<AllVideosPage> createState() => _AllVideosPageState();
}

class _AllVideosPageState extends ConsumerState<AllVideosPage> {
  String _selectedFilter = 'all'; // all, recent, popular

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(videosProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les vidéos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              unawaited(
                showSearch(
                  context: context,
                  delegate: _VideoSearchDelegate(ref: ref),
                ),
              );
            },
          ),
          SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            height: EcoPlatesDesignTokens.size.buttonHeight(context),
            padding: EdgeInsets.symmetric(
              horizontal: EcoPlatesDesignTokens.spacing
                  .contentPadding(context)
                  .horizontal,
              vertical: EcoPlatesDesignTokens.spacing.microGap(context),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Toutes', 'all'),
                SizedBox(
                  width: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                _buildFilterChip('Récentes', 'recent'),
                SizedBox(
                  width: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                _buildFilterChip('Populaires', 'popular'),
                SizedBox(
                  width: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                _buildFilterChip('Anti-gaspi', 'anti-waste'),
                SizedBox(
                  width: EcoPlatesDesignTokens.spacing.microGap(context),
                ),
                _buildFilterChip('Recettes', 'recipes'),
              ],
            ),
          ),

          Divider(height: EcoPlatesDesignTokens.dividerHeight),

          // Liste des vidéos
          Expanded(
            child: videosAsync.when(
              data: (allVideos) {
                // Filtrer les vidéos
                final videos = _filterVideos(allVideos);

                if (videos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_library_outlined,
                          size: EcoPlatesDesignTokens.layout.emptyStateIconSize,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(
                          height: EcoPlatesDesignTokens.spacing.interfaceGap(
                            context,
                          ),
                        ),
                        Text(
                          'Aucune vidéo trouvée',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Grille adaptative
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(videosProvider);
                  },
                  child: SingleChildScrollView(
                    padding: EcoPlatesDesignTokens.spacing.contentPadding(
                      context,
                    ),
                    child: ResponsiveGrid(
                      config: ResponsiveGridConfig(
                        tablet: 2,
                        desktop: 3,
                        desktopLarge: 4,
                        spacing: EcoPlatesDesignTokens.spacing.interfaceGap(
                          context,
                        ),
                        aspectRatio: _getGridAspectRatio(context),
                      ),
                      children: videos.map((videoData) {
                        final video = VideoPreview(
                          id: videoData.id,
                          title: videoData.title,
                          description: videoData.description,
                          videoUrl: videoData.videoUrl,
                          thumbnailUrl: videoData.thumbnailUrl,
                          merchantId: videoData.merchantName
                              .toLowerCase()
                              .replaceAll(' ', '-'),
                          merchantName: videoData.merchantName,
                          duration: _parseDuration(videoData.duration),
                          viewCount: videoData.views,
                          publishedAt: videoData.publishedAt,
                        );

                        return VideoCard(
                          video: video,
                          onTap: () {
                            unawaited(showFloatingVideoModal(context, video));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: EcoPlatesDesignTokens.layout.errorViewIconSize,
                      color: EcoPlatesDesignTokens.errorColorGeneral(context),
                    ),
                    SizedBox(
                      height: EcoPlatesDesignTokens.spacing.interfaceGap(
                        context,
                      ),
                    ),
                    Text(
                      'Erreur de chargement',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: EcoPlatesDesignTokens.errorColorGeneral(context),
                      ),
                    ),
                    SizedBox(
                      height: EcoPlatesDesignTokens.spacing.microGap(context),
                    ),
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
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
      },
      selectedColor: Theme.of(context).primaryColor.withValues(
        alpha: EcoPlatesDesignTokens.opacity.pressed,
      ),
    );
  }

  List<VideoData> _filterVideos(List<VideoData> videos) {
    var filtered = videos;

    // Appliquer le filtre sélectionné
    switch (_selectedFilter) {
      case 'recent':
        final recentThreshold = DateTime.now().subtract(
          Duration(days: EcoPlatesDesignTokens.video.recentDaysThreshold),
        );
        filtered = filtered
            .where((v) => v.publishedAt.isAfter(recentThreshold))
            .toList();
      case 'popular':
        filtered = filtered
            .where(
              (v) => v.views > EcoPlatesDesignTokens.video.popularThreshold,
            )
            .toList();
      case 'anti-waste':
        filtered = filtered
            .where(
              (v) =>
                  v.title.toLowerCase().contains('gaspi') ||
                  v.title.toLowerCase().contains('déchet') ||
                  v.description.toLowerCase().contains('gaspillage'),
            )
            .toList();
      case 'recipes':
        filtered = filtered
            .where(
              (v) =>
                  v.title.toLowerCase().contains('recette') ||
                  v.title.toLowerCase().contains('smoothie') ||
                  v.description.toLowerCase().contains('cuisine'),
            )
            .toList();
    }

    return filtered;
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

  /// Détermine le ratio d'aspect de la grille selon le type d'appareil
  double _getGridAspectRatio(BuildContext context) {
    return context.responsiveValue<double>(
      mobile: EcoPlatesDesignTokens.video.mobileGridAspectRatio,
      tablet: EcoPlatesDesignTokens.video.tabletGridAspectRatio,
      desktop: EcoPlatesDesignTokens.video.desktopGridAspectRatio,
      desktopLarge: EcoPlatesDesignTokens.video.desktopLargeGridAspectRatio,
    );
  }
}

/// Delegate pour la recherche de vidéos
class _VideoSearchDelegate extends SearchDelegate<VideoData?> {
  _VideoSearchDelegate({required this.ref});
  final WidgetRef ref;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final videosAsync = ref.read(videosProvider);

    return videosAsync.when(
      data: (videos) {
        final filtered = videos
            .where(
              (v) =>
                  v.title.toLowerCase().contains(query.toLowerCase()) ||
                  v.merchantName.toLowerCase().contains(query.toLowerCase()) ||
                  v.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: EcoPlatesDesignTokens.layout.emptyStateIconSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(
                  height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                Text(
                  'Aucune vidéo trouvée pour "$query"',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final videoData = filtered[index];
            final video = VideoPreview(
              id: videoData.id,
              title: videoData.title,
              description: videoData.description,
              videoUrl: videoData.videoUrl,
              thumbnailUrl: videoData.thumbnailUrl,
              merchantId: videoData.merchantName.toLowerCase().replaceAll(
                ' ',
                '-',
              ),
              merchantName: videoData.merchantName,
              duration: _parseDuration(videoData.duration),
              viewCount: videoData.views,
              publishedAt: videoData.publishedAt,
            );

            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: EcoPlatesDesignTokens.spacing
                    .contentPadding(context)
                    .horizontal,
                vertical: EcoPlatesDesignTokens.spacing.microGap(context),
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.sm,
                ),
                child: SizedBox(
                  width: EcoPlatesDesignTokens.size.icon(context) * 3,
                  child: AspectRatio(
                    aspectRatio:
                        EcoPlatesDesignTokens.video.thumbnailAspectRatio,
                    child: EcoCachedImage(
                      imageUrl: video.thumbnailUrl,
                      size: ImageSize.small,
                      errorWidget: ColoredBox(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.broken_image,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                video.title,
                maxLines: EcoPlatesDesignTokens.video.titleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '${video.merchantName} • ${video.viewCount} vues',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                close(context, null);
                unawaited(showFloatingVideoModal(context, video));
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          const Center(child: Text('Erreur lors du chargement des vidéos')),
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
}
