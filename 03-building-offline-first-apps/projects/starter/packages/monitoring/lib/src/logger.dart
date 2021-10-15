import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

late Logger log = Logger(level: kDebugMode ? Level.verbose : Level.nothing);

FirebaseAnalytics analytics = FirebaseAnalytics();
