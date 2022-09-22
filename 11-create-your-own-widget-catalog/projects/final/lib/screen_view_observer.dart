import 'package:flutter/material.dart';
import 'package:monitoring/monitoring.dart';
import 'package:routemaster/routemaster.dart';

class ScreenViewObserver extends RoutemasterObserver {
  ScreenViewObserver({
    required this.analyticsService,
  });

  final AnalyticsService analyticsService;

  void _sendScreenView(PageRoute<dynamic> route) {
    final String? screenName = route.settings.name;

    if (screenName != null) {
      analyticsService.setCurrentScreen(screenName);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
