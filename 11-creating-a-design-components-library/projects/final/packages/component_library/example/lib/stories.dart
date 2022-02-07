import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

List<Story> getStories(WonderThemeData theme) {
  return [
    Story(
      name: 'Buttons/Expanded Elevated Button',
      builder: (context) => ExpandedElevatedButton(
        label: context.knobs.text(label: 'label', initial: 'Press me'),
        onTap:
            context.knobs.boolean(label: 'onTap', initial: true) ? () {} : null,
        icon: Icon(
          context.knobs.options(
            label: 'icon',
            initial: Icons.home,
            options: const [
              Option(label: 'Login', value: Icons.login),
              Option(label: 'Refresh', value: Icons.refresh),
              Option(label: 'Logout', value: Icons.logout),
            ],
          ),
        ),
      ),
    ),
    Story(
      name: 'Buttons/InProgress Expanded Elevated Button',
      builder: (context) => ExpandedElevatedButton.inProgress(
        label: context.knobs.text(label: 'label', initial: 'Processing'),
      ),
    ),
    Story(
      name: 'Buttons/InProgress Text Button',
      builder: (context) => InProgressTextButton(
        label: context.knobs.text(label: 'label', initial: 'Processing'),
      ),
    ),
    Story(
      name: 'Buttons/Favorite Button',
      builder: (context) => FavoriteIconButton(
        onTap: () {},
        isFavorite: context.knobs.boolean(label: 'isFavorite', initial: false),
      ),
    ),
    Story(
      name: 'Buttons/Share Icon Button',
      builder: (context) => ShareIconButton(onTap: () {}),
    ),
    Story(
      name: 'Count Indicator Buttons/Count Indicator Icon Button',
      builder: (context) => CountIndicatorIconButton(
        count: context.knobs.sliderInt(label: 'count'),
        iconData: context.knobs.options(
          label: 'iconData',
          initial: Icons.arrow_upward,
          options: const [
            Option(label: 'Upward', value: Icons.arrow_upward),
            Option(label: 'Downward', value: Icons.arrow_downward),
          ],
        ),
        tooltip:
            context.knobs.text(label: 'tooltip', initial: 'Count indicator'),
      ),
    ),
    Story(
      name: 'Count Indicator Buttons/Downvote Icon Button',
      builder: (context) => DownvoteIconButton(
        count: context.knobs.sliderInt(label: 'count'),
        onTap: () {},
        isDownvoted:
            context.knobs.boolean(label: 'isDownvoted', initial: false),
      ),
    ),
    Story(
      name: 'Count Indicator Buttons/Upvote Icon Button',
      builder: (context) => UpvoteIconButton(
        count: context.knobs.sliderInt(label: 'count'),
        onTap: () {},
        isUpvoted: context.knobs.boolean(label: 'isUpvoted', initial: false),
      ),
    ),
    Story(
      name: 'Indicators/Exception Indicator',
      builder: (context) => ExceptionIndicator(
        title: context.knobs.text(label: 'title', initial: 'Exception title'),
        message:
            context.knobs.text(label: 'message', initial: 'Exception message'),
        onTryAgain: context.knobs.boolean(label: 'onTryAgain', initial: false)
            ? () {}
            : null,
      ),
    ),
    Story(
      name: 'Indicators/Loading Indicator',
      builder: (context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: LoadingIndicator(),
      ),
    ),
    Story(
      name: 'Quote/QuoteCard',
      builder: (context) => QuoteCard(
        isFavorite: context.knobs.boolean(label: 'Is Favorite', initial: false),
        statement: context.knobs.text(
            label: 'Statement',
            initial:
                'Wherever you go, no matter what the weather, always bring your own sunshine.'),
        author: context.knobs.text(label: 'Author', initial: 'Author name'),
      ),
    ),
    Story(
      name: 'Quote/Quotes in List',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: 15,
          itemBuilder: (_, __) => QuoteCard(
            isFavorite:
                context.knobs.boolean(label: 'Is Favorite', initial: false),
            statement: context.knobs.text(
                label: 'Statement',
                initial:
                    'The finest steel has to go through the hottest fire.'),
            author: context.knobs.text(label: 'Author', initial: 'Author name'),
          ),
          separatorBuilder: (_, __) => Divider(height: theme.listSpacing),
        ),
      ),
    ),
    Story(
      name: 'Quote/Quotes in Grid',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: theme.gridSpacing,
          mainAxisSpacing: theme.gridSpacing,
          children: [
            for (int i = 0; i < 15; i++)
              QuoteCard(
                isFavorite:
                    context.knobs.boolean(label: 'Is Favorite', initial: false),
                statement: context.knobs
                    .text(label: 'Statement', initial: 'A quote statement'),
                author:
                    context.knobs.text(label: 'Author', initial: 'Author name'),
              )
          ],
        ),
      ),
    ),
    Story(
      name: 'Rounded Choice Chip',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: RoundedChoiceChip(
          label: context.knobs.text(
            label: 'label',
            initial: 'I am a Chip!',
          ),
          isSelected:
              context.knobs.boolean(label: 'isSelected', initial: false),
          avatar: context.knobs.boolean(label: 'avatar', initial: false)
              ? Icon(
                  Icons.favorite,
                  color: theme.roundedChoiceChipSelectedAvatarColor,
                )
              : null,
          onSelected: context.knobs.boolean(label: 'onSelected', initial: true)
              ? (_) {}
              : null,
          backgroundColor: context.knobs.options(
            label: 'backgroundColor',
            initial: null,
            options: const [
              Option(label: 'Light blue', value: Colors.lightBlue),
              Option(label: 'Red accent', value: Colors.redAccent),
            ],
          ),
          selectedBackgroundColor: context.knobs.options(
            label: 'selectedBackgroundColor',
            initial: null,
            options: const [
              Option(
                label: 'Green',
                value: Colors.green,
              ),
              Option(
                label: 'Amber accent',
                value: Colors.amberAccent,
              ),
            ],
          ),
          labelColor: context.knobs.options(
            label: 'labelColor',
            initial: null,
            options: const [
              Option(
                label: 'Teal',
                value: Colors.teal,
              ),
              Option(
                label: 'Orange accent',
                value: Colors.orangeAccent,
              ),
            ],
          ),
          selectedLabelColor: context.knobs.options(
            label: 'selectedLabelColor',
            initial: null,
            options: const [
              Option(
                label: 'Deep purple accent',
                value: Colors.deepPurpleAccent,
              ),
              Option(
                label: 'Amber accent',
                value: Colors.amberAccent,
              ),
            ],
          ),
        ),
      ),
    ),
    Story(
      name: 'Chevron List Tile',
      builder: (context) => Padding(
        padding: const EdgeInsets.all(Spacing.medium),
        child: ChevronListTile(
          label: context.knobs.text(
            label: 'label',
            initial: 'Update Profile',
          ),
        ),
      ),
    ),
    Story(
      name: 'Search Bar',
      builder: (context) => const SearchBar(),
    ),
    Story(
      name: 'Row App Bar',
      builder: (context) => const RowAppBar(
        children: [
          FavoriteIconButton(isFavorite: true),
          UpvoteIconButton(count: 10, isUpvoted: true),
          DownvoteIconButton(count: 5, isDownvoted: false),
        ],
      ),
    ),
    Story(
      name: 'Shrinkable Text',
      builder: (context) => ShrinkableText(
        context.knobs.text(
          label: 'text',
          initial:
              'I am a Shrinkable text. I can resize myself automatically within a space',
        ),
        style: context.knobs.options(
          label: 'style',
          initial: theme.quoteTextStyle.copyWith(fontSize: FontSize.xxLarge),
          options: [
            Option(
              label: 'XX large',
              value: theme.quoteTextStyle.copyWith(fontSize: FontSize.xxLarge),
            ),
            Option(
              label: 'Small',
              value: theme.quoteTextStyle.copyWith(fontSize: FontSize.small),
            ),
          ],
        ),
        textAlign: context.knobs.options(
          label: 'textAlign',
          initial: null,
          options: const [
            Option(label: 'Start', value: TextAlign.start),
            Option(label: 'End', value: TextAlign.end),
            Option(label: 'Center', value: TextAlign.center),
            Option(label: 'Justify', value: TextAlign.justify),
            Option(label: 'Left', value: TextAlign.left),
            Option(label: 'Right', value: TextAlign.right),
          ],
        ),
      ),
    ),
  ];
}
