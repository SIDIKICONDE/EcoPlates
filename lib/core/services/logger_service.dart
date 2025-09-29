import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart';

/// Enum pour les niveaux de log
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal;

  String get emoji {
    switch (this) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
    }
  }

  String get label => name.toUpperCase();
}

typedef LogFunction = void Function(LogEvent event);

/// Output console pour le développement
class ConsoleLogOutput {
  void log(LogEvent event) {
    final message = _formatMessage(event);

    if (kDebugMode) {
      developer.log(
        message,
        time: event.timestamp,
        level: _mapLogLevel(event.level),
        name: event.tag,
        error: event.error,
        stackTrace: event.stackTrace,
      );
    }
  }

  String _formatMessage(LogEvent event) {
    final buffer = StringBuffer()
      // Header
      ..write('${event.level.emoji} [${event.level.label}] ')
      ..write('${event.timestamp.toIso8601String()} ')
      ..write('[${event.tag}] ')
      // Message
      ..writeln(event.message);

    // Extra data
    if (event.data.isNotEmpty) {
      buffer
        ..writeln('📊 Data:')
        ..writeln(
          event.data.entries.map((e) => '  ${e.key}: ${e.value}').join('\n'),
        );
    }

    // Error details
    if (event.error != null) {
      buffer.writeln('🚨 Error: ${event.error}');
    }

    return buffer.toString();
  }

  int _mapLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }
}

/// Output fichier pour la production (à implémenter)
class FileLogOutput {
  FileLogOutput({
    required this.filePath,
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.maxFiles = 5,
  });
  final String filePath;
  final int maxFileSize;
  final int maxFiles;

  void log(LogEvent event) {
    // TODO: Implémenter la rotation des logs
    // Pour l'instant, juste un placeholder
    if (kDebugMode) {
      print('Would write to file: ${event.toJson()}');
    }
  }
}

/// Output pour les services d'analytics/crash reporting
class RemoteLogOutput {
  RemoteLogOutput({required this.endpoint, this.headers = const {}});
  final String endpoint;
  final Map<String, String> headers;

  void log(LogEvent event) {
    // Envoyer seulement les logs d'erreur et plus graves
    if (event.level.index >= LogLevel.error.index) {
      unawaited(_sendToRemote(event));
    }
  }

  Future<void> _sendToRemote(LogEvent event) async {
    try {
      // TODO: Implémenter l'envoi réel
      // Pour Firebase Crashlytics:
      // FirebaseCrashlytics.instance.recordError(
      //   event.error,
      //   event.stackTrace,
      //   reason: event.message,
      //   information: event.data.entries.map((e) => '${e.key}: ${e.value}').toList(),
      // );

      if (kDebugMode) {
        print('Would send to remote: ${event.toJson()}');
      }
    } on Exception catch (e) {
      // Ne pas faire échouer l'app si le logging échoue
      if (kDebugMode) {
        print('Failed to send log to remote: $e');
      }
    }
  }
}

/// Événement de log
class LogEvent {
  LogEvent({
    required this.level,
    required this.message,
    required this.tag,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    this.error,
    this.stackTrace,
  }) : timestamp = timestamp ?? DateTime.now(),
       data = data ?? {};

  final LogLevel level;
  final String message;
  final String tag;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final dynamic error;
  final StackTrace? stackTrace;

  Map<String, dynamic> toJson() => {
    'level': level.name,
    'message': message,
    'tag': tag,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
    if (error != null) 'error': error.toString(),
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
  };
}

/// Service principal de logging
class LoggerService {
  LoggerService({
    required this.defaultTag,
    required this.outputs,
    this.minimumLevel = LogLevel.debug,
  });
  final String defaultTag;
  final List<LogFunction> outputs;
  final LogLevel minimumLevel;

  /// Méthode pour créer un logger avec un tag spécifique
  LoggerService tagged(String tag) {
    return LoggerService(
      defaultTag: tag,
      outputs: outputs,
      minimumLevel: minimumLevel,
    );
  }

  /// Log un message debug
  void debug(String message, {Map<String, dynamic>? data, String? tag}) {
    _log(level: LogLevel.debug, message: message, data: data, tag: tag);
  }

  /// Log un message info
  void info(String message, {Map<String, dynamic>? data, String? tag}) {
    _log(level: LogLevel.info, message: message, data: data, tag: tag);
  }

  /// Log un message warning
  void warning(String message, {Map<String, dynamic>? data, String? tag}) {
    _log(level: LogLevel.warning, message: message, data: data, tag: tag);
  }

  /// Log une erreur
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  }) {
    _log(
      level: LogLevel.error,
      message: message,
      error: error,
      stackTrace: stackTrace ?? (error is Error ? error.stackTrace : null),
      data: data,
      tag: tag,
    );
  }

  /// Log une erreur fatale
  void fatal(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
    String? tag,
  }) {
    _log(
      level: LogLevel.fatal,
      message: message,
      error: error,
      stackTrace: stackTrace ?? (error is Error ? error.stackTrace : null),
      data: data,
      tag: tag,
    );
  }

  /// Méthode interne pour logger
  void _log({
    required LogLevel level,
    required String message,
    Map<String, dynamic>? data,
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    // Vérifier le niveau minimum
    if (level.index < minimumLevel.index) return;

    // Créer l'événement
    final event = LogEvent(
      level: level,
      message: message,
      tag: tag ?? defaultTag,
      data: data ?? {},
      error: error,
      stackTrace: stackTrace != null ? Trace.from(stackTrace).terse : null,
    );

    // Envoyer à tous les outputs
    for (final output in outputs) {
      try {
        output(event);
      } on Exception catch (e) {
        // Ne pas faire échouer si un output échoue
        if (kDebugMode) {
          print('Log output failed: $e');
        }
      }
    }
  }

  /// Log une action métier
  void logBusinessEvent(
    String action, {
    Map<String, dynamic>? parameters,
    String? userId,
    String? result,
  }) {
    info(
      'Business Event: $action',
      data: {
        'action': action,
        'parameters': ?parameters,
        'userId': ?userId,
        'result': ?result,
        'timestamp': DateTime.now().toIso8601String(),
      },
      tag: 'BusinessEvent',
    );
  }

  /// Log une performance metric
  void logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metadata,
  }) {
    final milliseconds = duration.inMilliseconds;
    final level = milliseconds > 1000
        ? LogLevel.warning
        : milliseconds > 500
        ? LogLevel.info
        : LogLevel.debug;

    _log(
      level: level,
      message: 'Performance: $operation took ${milliseconds}ms',
      data: {
        'operation': operation,
        'duration_ms': milliseconds,
        if (metadata != null) ...metadata,
      },
      tag: 'Performance',
    );
  }

  /// Mesurer et logger la durée d'une opération
  Future<T> measure<T>(
    String operation,
    Future<T> Function() task, {
    Map<String, dynamic>? metadata,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await task();
      stopwatch.stop();
      logPerformance(operation, stopwatch.elapsed, metadata: metadata);
      return result;
    } catch (e, stack) {
      stopwatch.stop();
      error(
        'Operation failed: $operation',
        error: e,
        stackTrace: stack,
        data: {
          'operation': operation,
          'duration_ms': stopwatch.elapsedMilliseconds,
          if (metadata != null) ...metadata,
        },
      );
      rethrow;
    }
  }
}

/// Provider pour le service de logging
final loggerServiceProvider = Provider<LoggerService>((ref) {
  final outputs = <LogFunction>[];

  // Console output en dev
  if (kDebugMode) {
    outputs.add(ConsoleLogOutput().log);
  }

  // File output (à activer en production)
  // outputs.add(FileLogOutput(filePath: 'logs/ecoplates.log'));

  // Remote output (à configurer avec vos services)
  // outputs.add(RemoteLogOutput(endpoint: 'https://logs.ecoplates.com/v1/logs'));

  return kDebugMode
      ? LoggerService(defaultTag: 'EcoPlates', outputs: outputs)
      : LoggerService(
          defaultTag: 'EcoPlates',
          outputs: outputs,
          minimumLevel: LogLevel.info,
        );
});

/// Extension pour créer facilement des loggers tagués
extension LoggerProviderExtension on WidgetRef {
  LoggerService logger([String? tag]) {
    final service = read(loggerServiceProvider);
    return tag != null ? service.tagged(tag) : service;
  }
}

/// Mixin pour ajouter facilement du logging aux classes
mixin LoggerMixin {
  late final LoggerService logger = LoggerService(
    defaultTag: runtimeType.toString(),
    outputs: [ConsoleLogOutput().log],
  );
}
