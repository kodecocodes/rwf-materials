import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitoring/monitoring.dart';
import 'package:routemaster/routemaster.dart';

typedef ScreenNameExtractor = String? Function(RouteSettings settings);

String? defaultNameExtractor(RouteSettings settings) => settings.name;

class ScreenViewObserver extends RoutemasterObserver {
  ScreenViewObserver({
    this.nameExtractor = defaultNameExtractor,
    Function(PlatformException error)? onError,
  }) : _onError = onError;

  final ScreenNameExtractor nameExtractor;
  final void Function(PlatformException error)? _onError;

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

  @override
  void didChangeRoute(RouteData routeData, Page page) {}

  void _sendScreenView(PageRoute<dynamic> route) {
    final String? screenName = nameExtractor(route.settings);
    if (screenName != null) {
      analytics.setCurrentScreen(screenName: screenName).catchError(
        (Object error) {
          final _onError = this._onError;
          if (_onError == null) {
            log.e('$ScreenViewObserver: $error');
          } else {
            _onError(error as PlatformException);
          }
        },
        test: (Object error) => error is PlatformException,
      );
    }
  }
}
