import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class ExplicitCrash {
  ExplicitCrash({
    @visibleForTesting FirebaseCrashlytics? crashlytics,
  }) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;

  crashTheApp() {
    _crashlytics.crash();
  }
}
