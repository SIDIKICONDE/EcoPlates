import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/search_service.dart';
import '../../providers/consumer/search_provider.dart';

/// Barre de recherche intelligente avec suggestions
class SmartSearchBar extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  final bool autofocus;
  final bool showBackButton;

  const SmartSearchBar({
    super.key,
    this.onTap,
    this.autofocus = false,
    this.showBackButton = false,
  });

  @override
  ConsumerState<SmartSearchBar> createState() => _SmartSearchBarState();
}

class _SmartSearchBarState extends ConsumerState<SmartSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final GlobalKey _searchBarKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showSuggestions();
      } else {
        _hideSuggestions();
      }
    });
  }

  @override
  void dispose() {
    _hideSuggestions();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showSuggestions() {
    final searchNotifier = ref.read(searchProvider.notifier);
    searchNotifier.toggleSuggestions(true);

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSuggestions() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    final searchNotifier = ref.read(searchProvider.notifier);
    searchNotifier.toggleSuggestions(false);
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
        _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: _SuggestionsOverlay(
            onSuggestionTap: (suggestion) {
              _controller.text = suggestion.text;
              _focusNode.unfocus();

              final searchNotifier = ref.read(searchProvider.notifier);
              searchNotifier.selectSuggestion(suggestion);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);

    return Container(
      key: _searchBarKey,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
        boxShadow: widget.showBackButton
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          if (widget.showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          else
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(Icons.search, color: Colors.grey),
            ),

          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              onTap: widget.onTap,
              onChanged: (value) {
                searchNotifier.updateQuery(value);
                if (_overlayEntry != null) {
                  _overlayEntry!.markNeedsBuild();
                }
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  searchNotifier.search(value);
                  _focusNode.unfocus();
                }
              },
              decoration: InputDecoration(
                hintText: 'Rechercher une offre, un commerçant...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),

          if (searchState.query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                searchNotifier.clearSearch();
                _focusNode.unfocus();
              },
            ),
        ],
      ),
    );
  }
}

/// Widget d'overlay pour les suggestions
class _SuggestionsOverlay extends ConsumerWidget {
  final Function(SearchSuggestion) onSuggestionTap;

  const _SuggestionsOverlay({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    if (!searchState.showSuggestions) {
      return const SizedBox.shrink();
    }

    final items = <Widget>[];

    // Suggestions
    if (searchState.suggestions.isNotEmpty) {
      for (final suggestion in searchState.suggestions) {
        items.add(
          _SuggestionTile(
            suggestion: suggestion,
            onTap: () => onSuggestionTap(suggestion),
          ),
        );
      }
    }

    // Historique si pas de recherche active
    if (searchState.query.isEmpty && searchState.searchHistory.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recherches récentes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(searchProvider.notifier).clearHistory();
                },
                child: Text(
                  'Effacer',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      for (final term in searchState.searchHistory.take(5)) {
        items.add(
          _HistoryTile(
            term: term,
            onTap: () {
              final suggestion = SearchSuggestion(
                text: term,
                type: SuggestionType.history,
                icon: SearchSuggestionIcon.history,
              );
              onSuggestionTap(suggestion);
            },
            onDelete: () {
              ref.read(searchProvider.notifier).removeFromHistory(term);
            },
          ),
        );
      }
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: items),
      ),
    );
  }
}

/// Tuile pour une suggestion
class _SuggestionTile extends StatelessWidget {
  final SearchSuggestion suggestion;
  final VoidCallback onTap;

  const _SuggestionTile({required this.suggestion, required this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (suggestion.icon) {
      case SearchSuggestionIcon.history:
        iconData = Icons.history;
        iconColor = Colors.grey;
        break;
      case SearchSuggestionIcon.trending:
        iconData = Icons.trending_up;
        iconColor = Colors.orange;
        break;
      case SearchSuggestionIcon.category:
        iconData = Icons.category;
        iconColor = Colors.blue;
        break;
      case SearchSuggestionIcon.store:
        iconData = Icons.store;
        iconColor = Colors.green;
        break;
      case SearchSuggestionIcon.filter:
        iconData = Icons.filter_list;
        iconColor = Colors.purple;
        break;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(iconData, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion.text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (suggestion.type == SuggestionType.popular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Populaire',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Tuile pour un élément d'historique
class _HistoryTile extends StatelessWidget {
  final String term;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryTile({
    required this.term,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.history, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(child: Text(term, style: const TextStyle(fontSize: 14))),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
