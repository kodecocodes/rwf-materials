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

  Widget _customWrapper(BuildContext context, Widget? child) => MaterialApp(
        theme: lightThemeData,
        darkTheme: darkThemeData,
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
    contentsSidePanel: true,
    knobsSidePanel: true,
    initialDeviceFrameData: DeviceFrameData(
      device: Devices.ios.iPhone13,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return Storybook(
      wrapperBuilder: (context, child) => _customWrapper(context, child),
      plugins: kIsWeb ? _plugins : null,
      stories: [...getStories(theme)],
      initialStory: 'Rounded Choice Chip',
    );
  }
}
