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
      supportedLocales: ComponentLibraryLocalizations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ComponentLibraryLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wonder Words Components Library'),
          backgroundColor: const Color(0xFF009245),
          elevation: 0,
        ),
        body: CustomStorybook(
          children: [...getStories(theme)],
          builder: (_) => Row(
            children: const [
              SizedBox(width: 300, child: Contents()),
              Expanded(child: CurrentStory(), flex: 3),
              SizedBox(width: 400, child: KnobPanel())
            ],
          ),
        ),
      ),
    );
  }
}
