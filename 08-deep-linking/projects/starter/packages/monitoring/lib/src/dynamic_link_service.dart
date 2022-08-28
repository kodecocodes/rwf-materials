import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

export 'package:firebase_dynamic_links/firebase_dynamic_links.dart'
    show SocialMetaTagParameters;

typedef OnNewDynamicLinkPath = void Function(String newDynamicLinkPath);

/// Wrapper around [FirebaseDynamicLinks].
class DynamicLinkService {
  // TODO: Create a constant to hold your dynamic link prefix.
  static const _iOSBundleId = 'com.raywenderlich.wonderWords';
  static const _androidPackageName = 'com.raywenderlich.wonder_words';

  DynamicLinkService({
    @visibleForTesting FirebaseDynamicLinks? dynamicLinks,
  }) : _dynamicLinks = dynamicLinks ?? FirebaseDynamicLinks.instance;

  final FirebaseDynamicLinks _dynamicLinks;

  // TODO: Create a function that generates dynamic links

  // TODO: Create a function that returns the link that launched the app.

  // TODO: Expose a way to listen to new links.
}
