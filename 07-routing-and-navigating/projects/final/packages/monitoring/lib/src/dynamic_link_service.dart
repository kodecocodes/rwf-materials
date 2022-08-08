import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

export 'package:firebase_dynamic_links/firebase_dynamic_links.dart'
    show SocialMetaTagParameters;

typedef OnNewDynamicLinkPath = void Function(String newDynamicLinkPath);

/// Wrapper around [FirebaseDynamicLinks].
class DynamicLinkService {
  static const _domainUriPrefix = 'https://wonderwords.page.link';

  DynamicLinkService({
    @visibleForTesting FirebaseDynamicLinks? dynamicLinks,
  }) : _dynamicLinks = dynamicLinks ?? FirebaseDynamicLinks.instance;

  final FirebaseDynamicLinks _dynamicLinks;

  Future<String?> getInitialDeepLinkPath() async {
    final data = await _dynamicLinks.getInitialLink();
    final link = data?.link;
    return link?.path;
  }

  void setListener(
    OnNewDynamicLinkPath onNewDynamicLinkPath,
  ) {
    _dynamicLinks.onLink(
      onSuccess: (
        PendingDynamicLinkData? data,
      ) async {
        final link = data?.link;
        final path = link?.path;

        if (path != null) {
          onNewDynamicLinkPath(path);
        }
      },
    );
  }

  Future<String> generateDynamicLinkUrl({
    required String path,
    SocialMetaTagParameters? socialMetaTagParameters,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: _domainUriPrefix,
      link: Uri.parse(
        '$_domainUriPrefix$path',
      ),
      androidParameters: AndroidParameters(
        packageName: packageName,
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: packageName,
        minimumVersion: '0',
      ),
      socialMetaTagParameters: socialMetaTagParameters,
    );

    final shortLink = await parameters.buildShortLink();
    return shortLink.shortUrl.toString();
  }
}
