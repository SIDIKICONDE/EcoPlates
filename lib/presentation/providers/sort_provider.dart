import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/sort_options.dart';

/// Provider pour l'option de tri sélectionnée
final sortOptionProvider = StateProvider<SortOption>((ref) => SortOption.relevance);

/// Provider pour savoir si le modal de tri est ouvert
final sortModalOpenProvider = StateProvider<bool>((ref) => false);
