import 'package:component_library/component_library.dart';
import 'package:component_library/stories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ComponentBookCustom extends StatelessWidget {
  final ThemeData lightThemeData, darkThemeData;

  const ComponentBookCustom({
    Key? key,
    required this.lightThemeData,
    required this.darkThemeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return MaterialApp(
      theme: lightThemeData,
      darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ComponentLibraryLocalizations.delegate,
      ],
      home: Scaffold(
        body: CustomStorybook(
          children: [
            ...getStories(theme),
          ],
          builder: (_) => Row(
            children: const [
              SizedBox(
                width: 200,
                child: Contents(),
              ),
              Expanded(child: CurrentStory()),
              SizedBox(
                width: 200,
                child: KnobPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
