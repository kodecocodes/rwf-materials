import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class ExplicitCrash {
  ExplicitCrash({
    @visibleForTesting FirebaseCrashlytics? crashlytics,
  }) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  // 1
  final FirebaseCrashlytics _crashlytics;

  // 2
  crashTheApp() {
    _crashlytics.crash();
  }
}
