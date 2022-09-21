import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Wrapper around [FirebaseAnalytics].
class AnalyticsService {
  AnalyticsService({
    @visibleForTesting FirebaseAnalytics? analytics,
  }) : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  Future<void> setCurrentScreen(String screenName) {
    return _analytics.setCurrentScreen(
      screenName: screenName,
    );
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) {
    return _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
