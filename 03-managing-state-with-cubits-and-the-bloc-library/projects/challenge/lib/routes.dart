import 'package:domain_models/domain_models.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:forgot_my_password/forgot_my_password.dart';
import 'package:profile_menu/profile_menu.dart';
import 'package:quote_details/quote_details.dart';
import 'package:quote_list/quote_list.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sign_in/sign_in.dart';
import 'package:sign_up/sign_up.dart';
import 'package:update_profile/update_profile.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wonder_words/dynamic_link.dart';
import 'package:wonder_words/home_screen.dart';

class Routes extends RouteMap {
  Routes({
    required RoutemasterDelegate navigator,
    required UserRepository userRepository,
    required QuoteRepository quoteRepository,
  }) : super(
          routes: {
            _RoutePaths.homePath: (_) => CupertinoTabPage(
                  child: const HomeScreen(),
                  paths: [
                    _RoutePaths.quoteListPath,
                    _RoutePaths.profileMenuPath,
                  ],
                ),
            _RoutePaths.quoteListPath: (route) {
              return MaterialPage(
                name: 'quotes-list',
                child: QuoteListScreen(
                  quoteRepository: quoteRepository,
                  userRepository: userRepository,
                  onAuthenticationError: (context) {
                    navigator.push(_RoutePaths.signInPath);
                  },
                  onQuoteSelected: (id) {
                    final navigation = navigator.push<Quote?>(
                      _RoutePaths.quoteDetailsPath(
                        quoteId: id,
                      ),
                    );
                    return navigation.result;
                  },
                ),
              );
            },
            _RoutePaths.profileMenuPath: (_) {
              return MaterialPage(
                name: 'profile-menu',
                child: ProfileMenuScreen(
                  quoteRepository: quoteRepository,
                  userRepository: userRepository,
                  onSignInTap: () {
                    navigator.push(
                      _RoutePaths.signInPath,
                    );
                  },
                  onUpdateProfileTap: () {
                    navigator.push(
                      _RoutePaths.updateProfilePath,
                    );
                  },
                ),
              );
            },
            _RoutePaths.updateProfilePath: (_) => MaterialPage(
                  name: 'update-profile',
                  child: UpdateProfileScreen(
                    userRepository: userRepository,
                    onUpdateProfileSuccess: () {
                      navigator.pop();
                    },
                  ),
                ),
            _RoutePaths.quoteDetailsPath(): (info) {
              return MaterialPage(
                name: 'quote-details',
                child: QuoteDetailsScreen(
                  quoteRepository: quoteRepository,
                  quoteId: int.parse(
                      info.pathParameters[_RoutePaths.idPathParameter] ?? ''),
                  onAuthenticationError: () {
                    navigator.push(_RoutePaths.signInPath);
                  },
                  shareableLinkGenerator: (quote) => DynamicLink(
                    path: _RoutePaths.quoteDetailsPath(
                      quoteId: quote.id,
                    ),
                    socialMetaTagParameters: SocialMetaTagParameters(
                      title: quote.body,
                      description: quote.author,
                    ),
                  ).url,
                ),
              );
            },
            _RoutePaths.signInPath: (_) => MaterialPage(
                  name: 'sign-in',
                  fullscreenDialog: true,
                  child: Builder(
                    builder: (context) {
                      return SignInScreen(
                        userRepository: userRepository,
                        onSignInSuccess: () {
                          navigator.pop();
                        },
                        onSignUpTap: () {
                          navigator.push(_RoutePaths.signUpPath);
                        },
                        onForgotMyPasswordTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ForgotMyPasswordDialog(
                                userRepository: userRepository,
                                onCancelTap: () {
                                  navigator.pop();
                                },
                                onEmailRequestSuccess: () {
                                  navigator.pop();
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
            _RoutePaths.signUpPath: (_) => MaterialPage(
                  name: 'sign-up',
                  child: SignUpScreen(
                    userRepository: userRepository,
                    onSignUpSuccess: () async {
                      await navigator.pop();
                      navigator.pop();
                    },
                  ),
                ),
          },
        );
}

class _RoutePaths {
  const _RoutePaths._();

  static String get homePath => '/';

  static String get quoteListPath => '${homePath}quotes';

  static String get profileMenuPath => '${homePath}user';

  static String get updateProfilePath => '$profileMenuPath/update-profile';

  static String get signInPath => '${homePath}sign-in';

  static String get signUpPath => '$signInPath/sign-up';

  static String get idPathParameter => 'id';

  static String quoteDetailsPath({
    int? quoteId,
  }) =>
      '$quoteListPath/${quoteId ?? ':$idPathParameter'}';
}
