import 'package:flutter/material.dart';
import 'package:monitoring/monitoring.dart';
import 'package:routemaster/routemaster.dart';

class ScreenViewObserver extends RoutemasterObserver {
  ScreenViewObserver({
    required this.analyticsService,
  });

  final AnalyticsService analyticsService;

  // TODO: replace with _sendScreenView() methode implementation

  // TODO: override didPush and didPop methode
}
