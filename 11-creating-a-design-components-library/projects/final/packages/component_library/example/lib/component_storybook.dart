import 'package:component_library/component_library.dart';
import 'package:component_library_storybook/stories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ComponentStorybook extends StatelessWidget {
  final ThemeData lightThemeData, darkThemeData;

  ComponentStorybook({
    Key? key,
    required this.lightThemeData,
    required this.darkThemeData,
  }) : super(key: key);

  Widget customWrapper(BuildContext context, Widget? child) => MaterialApp(
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          ComponentLibraryLocalizations.delegate,
        ],
        home: Scaffold(body: Center(child: child)),
      );

  final _plugins = initializePlugins(
    contentsSidePanel: kIsWeb ? true : false,
    knobsSidePanel: kIsWeb ? true : false,
  );

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return Storybook(
      wrapperBuilder: (context, child) => customWrapper(context, child),
      plugins: _plugins,
      stories: [...getStories(theme)],
      initialStory: 'Rounded Choice Chip',
    );
  }
}
