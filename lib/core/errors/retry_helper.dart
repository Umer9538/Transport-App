import 'dart:async';
import 'dart:math';
import 'app_exceptions.dart';

class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final bool Function(Exception)? retryIf;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.retryIf,
  });

  static const RetryConfig defaultConfig = RetryConfig();

  static const RetryConfig networkConfig = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 2),
    backoffMultiplier: 2.0,
  );

  static const RetryConfig aggressiveConfig = RetryConfig(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 500),
    backoffMultiplier: 1.5,
  );
}

class RetryHelper {
  static Future<T> retry<T>(
    Future<T> Function() action, {
    RetryConfig config = RetryConfig.defaultConfig,
    void Function(int attempt, Exception error)? onRetry,
  }) async {
    int attempt = 0;
    Duration delay = config.initialDelay;

    while (true) {
      attempt++;
      try {
        return await action();
      } on Exception catch (e) {
        if (attempt >= config.maxAttempts) {
          rethrow;
        }

        if (config.retryIf != null && !config.retryIf!(e)) {
          rethrow;
        }

        // Don't retry auth or validation errors
        if (e is AuthException || e is ValidationException) {
          rethrow;
        }

        onRetry?.call(attempt, e);

        await Future.delayed(delay + _jitter(delay));

        delay = Duration(
          milliseconds: min(
            (delay.inMilliseconds * config.backoffMultiplier).round(),
            config.maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }

  static Duration _jitter(Duration base) {
    final random = Random();
    final jitterMs = (base.inMilliseconds * 0.1 * random.nextDouble()).round();
    return Duration(milliseconds: jitterMs);
  }
}
