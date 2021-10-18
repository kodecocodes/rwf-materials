import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:package_info/package_info.dart';

class DynamicLink {
  static const _domainUriPrefix = 'https://wonderwordsdev.page.link';

  final String path;
  final SocialMetaTagParameters? socialMetaTagParameters;

  DynamicLink({
    required this.path,
    this.socialMetaTagParameters,
  });

  Future<String> get url async {
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
