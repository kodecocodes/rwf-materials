import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

List<Story> getStories(WonderThemeData theme) {
  return [
    Story(
      name: 'ChevronListTile',
      padding: const EdgeInsets.all(Spacing.medium),
      wrapperBuilder: (context, story, widget) {
        return MaterialApp(home: Scaffold(body: widget));
      },
      builder: (_, k) => ChevronListTile(
        label: k.text(
          label: 'Chevron List Tile Label',
          initial: 'Update Profile',
        ),
      ),
    ),
    Story(
      name: 'CountIndicatorIconButton',
      builder: (_, k) => CountIndicatorIconButton(
        count: k.sliderInt(label: 'Count'),
        iconData: k.options(
          label: 'Icon Data',
          initial: Icons.arrow_upward,
          options: const [
            Option('Upward', Icons.arrow_upward),
            Option('Red accent', Icons.arrow_downward),
          ],
        ),
        tooltip: k.text(label: 'Tooltip', initial: 'Count indicator'),
        onTap: k.boolean(label: 'Enabled', initial: true) ? () {} : null,
      ),
    ),
    Story.simple(
      name: 'SearchBar',
      child: const SearchBar(),
    ),
    Story(
      name: 'QuoteCard',
      builder: (_, k) => QuoteCard(
        isFavorite: k.boolean(label: 'Is Favorite', initial: false),
        statement: k.text(label: 'Statement', initial: 'A quote statement'),
        author: k.text(label: 'Author', initial: 'Author name'),
      ),
    ),
    Story(
      name: 'Quotes in List',
      wrapperBuilder: (context, story, child) => ListView.separated(
        itemCount: 15,
        itemBuilder: (_, __) => child,
        separatorBuilder: (_, __) => Divider(height: theme.listSpacing),
      ),
      builder: (_, k) => QuoteCard(
        isFavorite: k.boolean(label: 'Is Favorite', initial: false),
        statement: k.text(label: 'Statement', initial: 'A quote statement'),
        author: k.text(label: 'Author', initial: 'Author name'),
      ),
    ),
    Story(
      name: 'Quotes in Grid',
      wrapperBuilder: (context, story, child) => GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: theme.gridSpacing,
        mainAxisSpacing: theme.gridSpacing,
        children: [for (int i = 0; i < 15; i++) child],
      ),
      builder: (_, k) => QuoteCard(
        isFavorite: k.boolean(label: 'Is Favorite', initial: false),
        statement: k.text(label: 'Statement', initial: 'A quote statement'),
        author: k.text(label: 'Author', initial: 'Author name'),
      ),
    ),
  ];
}
