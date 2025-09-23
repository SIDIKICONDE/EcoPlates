import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Gestionnaire centralisé des animations pour éviter les collisions
/// et optimiser les performances
class AnimationManager {
  static final AnimationManager _instance = AnimationManager._internal();
  factory AnimationManager() => _instance;
  AnimationManager._internal();
  
  // Map pour tracker les animations actives
  final Map<String, AnimationController> _activeAnimations = {};
  
  // File d'attente pour les animations en attente
  final List<_AnimationTask> _animationQueue = [];
  
  // Limite d'animations simultanées pour éviter les problèmes de performance
  static const int maxConcurrentAnimations = 3;
  
  // Flag pour désactiver les animations si nécessaire (accessibilité)
  bool _animationsEnabled = true;
  
  /// Active ou désactive toutes les animations (pour l'accessibilité)
  void setAnimationsEnabled(bool enabled) {
    _animationsEnabled = enabled;
    if (!enabled) {
      // Arrêter toutes les animations en cours
      _activeAnimations.forEach((key, controller) {
        controller.stop();
      });
      _activeAnimations.clear();
      _animationQueue.clear();
    }
  }
  
  /// Enregistre une animation et la démarre si possible
  Future<void> registerAnimation({
    required String id,
    required AnimationController controller,
    bool priority = false,
  }) async {
    if (!_animationsEnabled) {
      // Si les animations sont désactivées, compléter immédiatement
      controller.value = controller.upperBound;
      return;
    }
    
    // Si une animation avec cet ID existe déjà, l'arrêter
    if (_activeAnimations.containsKey(id)) {
      await cancelAnimation(id);
    }
    
    final task = _AnimationTask(id: id, controller: controller);
    
    if (_activeAnimations.length < maxConcurrentAnimations) {
      // Démarrer immédiatement si sous la limite
      _startAnimation(task);
    } else if (priority) {
      // Ajouter en tête de file si prioritaire
      _animationQueue.insert(0, task);
    } else {
      // Ajouter à la file d'attente
      _animationQueue.add(task);
    }
  }
  
  /// Démarre une animation
  void _startAnimation(_AnimationTask task) {
    _activeAnimations[task.id] = task.controller;
    
    task.controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _onAnimationComplete(task.id);
      }
    });
    
    // Utiliser le scheduler pour optimiser le timing
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (task.controller.isAnimating) return;
      task.controller.forward();
    });
  }
  
  /// Appelé quand une animation se termine
  void _onAnimationComplete(String id) {
    _activeAnimations.remove(id);
    _processQueue();
  }
  
  /// Traite la file d'attente des animations
  void _processQueue() {
    if (_animationQueue.isEmpty) return;
    if (_activeAnimations.length >= maxConcurrentAnimations) return;
    
    final nextTask = _animationQueue.removeAt(0);
    _startAnimation(nextTask);
  }
  
  /// Annule une animation
  Future<void> cancelAnimation(String id) async {
    final controller = _activeAnimations[id];
    if (controller != null) {
      controller.stop();
      _activeAnimations.remove(id);
      _processQueue();
    }
    
    // Retirer aussi de la file d'attente si présent
    _animationQueue.removeWhere((task) => task.id == id);
  }
  
  /// Vérifie si une animation est active
  bool isAnimationActive(String id) {
    return _activeAnimations.containsKey(id);
  }
  
  /// Nettoie toutes les animations
  void dispose() {
    _activeAnimations.forEach((key, controller) {
      controller.dispose();
    });
    _activeAnimations.clear();
    _animationQueue.clear();
  }
}

/// Classe pour représenter une tâche d'animation
class _AnimationTask {
  final String id;
  final AnimationController controller;
  
  _AnimationTask({
    required this.id,
    required this.controller,
  });
}

/// Mixin pour simplifier l'utilisation du gestionnaire d'animations
mixin ManagedAnimationMixin on TickerProviderStateMixin {
  final AnimationManager _animationManager = AnimationManager();
  final List<String> _registeredAnimations = [];
  
  /// Crée une animation gérée
  AnimationController createManagedAnimation({
    required String id,
    required Duration duration,
    bool priority = false,
  }) {
    final controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    
    _registeredAnimations.add(id);
    _animationManager.registerAnimation(
      id: id,
      controller: controller,
      priority: priority,
    );
    
    return controller;
  }
  
  @override
  void dispose() {
    // Nettoyer toutes les animations enregistrées
    for (final id in _registeredAnimations) {
      _animationManager.cancelAnimation(id);
    }
    super.dispose();
  }
}

/// Widget pour désactiver les animations selon les préférences système
class AnimationPreferenceBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool animationsEnabled) builder;
  
  const AnimationPreferenceBuilder({
    super.key,
    required this.builder,
  });
  
  @override
  State<AnimationPreferenceBuilder> createState() => _AnimationPreferenceBuilderState();
}

class _AnimationPreferenceBuilderState extends State<AnimationPreferenceBuilder> {
  bool _animationsEnabled = true;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Vérifier les préférences d'accessibilité du système
    final mediaQuery = MediaQuery.of(context);
    _animationsEnabled = !mediaQuery.disableAnimations;
    AnimationManager().setAnimationsEnabled(_animationsEnabled);
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _animationsEnabled);
  }
}