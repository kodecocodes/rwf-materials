import 'dart:async';
import 'dart:isolate';

import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:flutter/material.dart';
import 'package:forgot_my_password/forgot_my_password.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:monitoring/monitoring.dart';
import 'package:profile_menu/profile_menu.dart';
import 'package:quote_details/quote_details.dart';
import 'package:quote_list/quote_list.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:update_profile/update_profile.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wonder_words/l10n/app_localizations.dart';
import 'package:wonder_words/routes.dart';
import 'package:wonder_words/screen_view_observer.dart';

// TODO: replace the implementation of main() function
void main() async {
  // 1
  WidgetsFlutterBinding.ensureInitialized();
  // 2
  await initializeMonitoringPackage();

  // TODO: Perform explicit crash

  // TODO: Add Error reporting

  // the following line of code will be relavant for next chapter
  final remoteValueService = RemoteValueService();
  await remoteValueService.load();
  runApp(
    WonderWords(
      remoteValueService: remoteValueService,
    ),
  );
}

class WonderWords extends StatefulWidget {
  const WonderWords({
    required this.remoteValueService,
    Key? key,
  }) : super(key: key);

  final RemoteValueService remoteValueService;

  @override
  _WonderWordsState createState() => _WonderWordsState();
}

class _WonderWordsState extends State<WonderWords> {
  final _keyValueStorage = KeyValueStorage();
  final _analyticsService = AnalyticsService();
  final _dynamicLinkService = DynamicLinkService();
  late final _favQsApi = FavQsApi(
    userTokenSupplier: () => _userRepository.getUserToken(),
  );
  late final _quoteRepository = QuoteRepository(
    remoteApi: _favQsApi,
    keyValueStorage: _keyValueStorage,
  );
  late final _userRepository = UserRepository(
    remoteApi: _favQsApi,
    noSqlStorage: _keyValueStorage,
  );
  late final _navigator = RoutemasterDelegate(
    observers: [
      // TODO: add observers to RoutemasterDelegate
    ],
    routesBuilder: (context) => Routes(
      navigator: _navigator,
      userRepository: _userRepository,
      quoteRepository: _quoteRepository,
      remoteValueService: widget.remoteValueService,
      dynamicLinkService: _dynamicLinkService,
    ),
  );
  final _lightTheme = LightWonderThemeData();
  final _darkTheme = DarkWonderThemeData();

  @override
  void initState() {
    super.initState();
    _openInitialDynamicLinkIfAny();

    _dynamicLinkService.setListener(
      (String path) => _navigator.push,
    );
  }

  Future<void> _openInitialDynamicLinkIfAny() async {
    final path = await _dynamicLinkService.getInitialDeepLinkPath();
    if (path != null) {
      _navigator.push(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DarkModePreference>(
      stream: _userRepository.getDarkModePreference(),
      builder: (context, snapshot) {
        final darkModePreference = snapshot.data;
        return WonderTheme(
          lightTheme: _lightTheme,
          darkTheme: _darkTheme,
          child: MaterialApp.router(
            theme: _lightTheme.materialThemeData,
            darkTheme: _darkTheme.materialThemeData,
            themeMode: darkModePreference?.toThemeMode(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ComponentLibraryLocalizations.delegate,
              ProfileMenuLocalizations.delegate,
              QuoteListLocalizations.delegate,
              QuoteDetailsLocalizations.delegate,
              SignInLocalizations.delegate,
              ForgotMyPasswordLocalizations.delegate,
              SignUpLocalizations.delegate,
              UpdateProfileLocalizations.delegate,
            ],
            routerDelegate: _navigator,
            routeInformationParser: const RoutemasterParser(),
          ),
        );
      },
    );
  }
}

extension on DarkModePreference {
  ThemeMode toThemeMode() {
    switch (this) {
      case DarkModePreference.useSystemSettings:
        return ThemeMode.system;
      case DarkModePreference.alwaysLight:
        return ThemeMode.light;
      case DarkModePreference.alwaysDark:
        return ThemeMode.dark;
    }
  }
}
