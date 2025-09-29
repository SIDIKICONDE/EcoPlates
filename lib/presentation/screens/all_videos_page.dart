import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/image_cache_service.dart';
import '../../core/widgets/eco_cached_image.dart';
import '../../domain/entities/video_preview.dart';
import '../providers/videos_provider.dart';
import '../widgets/common/empty_state.dart';
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
          SizedBox(width: 8.0),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            height: 48.0,
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Toutes', 'all'),
                SizedBox(
                  width: 8.0,
                ),
                _buildFilterChip('Récentes', 'recent'),
                SizedBox(
                  width: 8.0,
                ),
                _buildFilterChip('Populaires', 'popular'),
                SizedBox(
                  width: 8.0,
                ),
                _buildFilterChip('Anti-gaspi', 'anti-waste'),
                SizedBox(
                  width: 8.0,
                ),
                _buildFilterChip('Recettes', 'recipes'),
              ],
            ),
          ),

          Divider(height: 1.0),

          // Liste des vidéos
          Expanded(
            child: videosAsync.when(
              data: (allVideos) {
                // Filtrer les vidéos
                final videos = _filterVideos(allVideos);

                if (videos.isEmpty) {
                  return const EmptyState(
                    icon: Icons.video_library_outlined,
                    title: 'Aucune vidéo trouvée',
                  );
                }

                // Grille adaptative
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(videosProvider);
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1200
                            ? 4
                            : MediaQuery.of(context).size.width > 800
                            ? 3
                            : MediaQuery.of(context).size.width > 600
                            ? 2
                            : 1,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio: _getGridAspectRatio(context),
                      ),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final videoData = videos[index];
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
                      },
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
                      size: 48.0,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Erreur de chargement',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
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
        alpha: 0.2,
      ),
    );
  }

  List<VideoData> _filterVideos(List<VideoData> videos) {
    var filtered = videos;

    // Appliquer le filtre sélectionné
    switch (_selectedFilter) {
      case 'recent':
        final recentThreshold = DateTime.now().subtract(
          const Duration(days: 7),
        );
        filtered = filtered
            .where((v) => v.publishedAt.isAfter(recentThreshold))
            .toList();
      case 'popular':
        filtered = filtered
            .where(
              (v) => v.views > 1000,
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
    return 16.0 / 9.0; // Ratio standard 16:9
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
                  size: 80.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(
                  height: 16.0,
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
                horizontal: 16.0,
                vertical: 8.0,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                child: SizedBox(
                  width: 18.0 * 3,
                  child: AspectRatio(
                    aspectRatio: 16.0 / 9.0,
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
                maxLines: 2,
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
