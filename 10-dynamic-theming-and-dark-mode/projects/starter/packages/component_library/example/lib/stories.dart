import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

List<Story> getStories(WonderThemeData theme) {
  return [
    Story.simple(
      name: 'Simple Expanded Elevated Button',
      section: 'Buttons',
      child: ExpandedElevatedButton(
        label: 'Press me',
        onTap: () {},
      ),
    ),
    Story(
      name: 'Expanded Elevated Button',
      section: 'Buttons',
      builder: (_, k) => ExpandedElevatedButton(
        label: k.text(
          label: 'label',
          initial: 'Press me',
        ),
        onTap: k.boolean(
          label: 'onTap',
          initial: true,
        )
            ? () {}
            : null,
        icon: Icon(
          k.options(
            label: 'icon',
            initial: Icons.home,
            options: const [
              Option(
                'Login',
                Icons.login,
              ),
              Option(
                'Refresh',
                Icons.refresh,
              ),
              Option(
                'Logout',
                Icons.logout,
              ),
            ],
          ),
        ),
      ),
    ),
    Story(
      name: 'InProgress Expanded Elevated Button',
      section: 'Buttons',
      builder: (_, k) => ExpandedElevatedButton.inProgress(
        label: k.text(
          label: 'label',
          initial: 'Processing',
        ),
      ),
    ),
    Story(
      name: 'InProgress Text Button',
      section: 'Buttons',
      builder: (_, k) => InProgressTextButton(
        label: k.text(
          label: 'label',
          initial: 'Processing',
        ),
      ),
    ),
    Story(
      name: 'Favorite Button',
      section: 'Buttons',
      builder: (_, k) => FavoriteIconButton(
        onTap: () {},
        isFavorite: k.boolean(
          label: 'isFavorite',
          initial: false,
        ),
      ),
    ),
    Story.simple(
      name: 'Share Icon Button',
      section: 'Buttons',
      child: ShareIconButton(onTap: () {}),
    ),
    Story(
      name: 'Count Indicator Icon Button',
      section: 'Count Indicator Buttons',
      builder: (_, k) => CountIndicatorIconButton(
        count: k.sliderInt(
          label: 'count',
        ),
        iconData: k.options(
          label: 'iconData',
          initial: Icons.arrow_upward,
          options: const [
            Option(
              'Upward',
              Icons.arrow_upward,
            ),
            Option(
              'Downward',
              Icons.arrow_downward,
            ),
          ],
        ),
        tooltip: k.text(
          label: 'tooltip',
          initial: 'Count indicator',
        ),
      ),
    ),
    Story(
      name: 'Upvote Icon Button',
      section: 'Count Indicator Buttons',
      builder: (_, k) => UpvoteIconButton(
        count: k.sliderInt(
          label: 'count',
          max: 10,
          min: 0,
          initial: 0,
          divisions: 9,
        ),
        onTap: () {},
        isUpvoted: k.boolean(
          label: 'isUpvoted',
          initial: false,
        ),
      ),
    ),
    Story(
      name: 'Exception Indicator',
      section: 'Indicators',
      builder: (_, k) => ExceptionIndicator(
        title: k.text(
          label: 'title',
          initial: 'Exception title',
        ),
        message: k.text(
          label: 'message',
          initial: 'Exception message',
        ),
        onTryAgain: k.boolean(
          label: 'onTryAgain',
          initial: false,
        )
            ? () {}
            : null,
      ),
    ),
    Story(
      name: 'QuoteCard',
      section: 'Quote',
      builder: (_, k) => QuoteCard(
        isFavorite: k.boolean(
          label: 'Is Favorite',
          initial: false,
        ),
        statement: k.text(
          label: 'Statement',
          initial:
              'Wherever you go, no matter what the weather, always bring your own sunshine.',
        ),
        author: k.text(
          label: 'Author',
          initial: 'Author name',
        ),
      ),
    ),
    Story(
      name: 'Quotes in List',
      section: 'Quote',
      wrapperBuilder: (context, story, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: 15,
          itemBuilder: (_, __) => child,
          separatorBuilder: (_, __) => const Divider(
            height: 16.0,
          ),
        ),
      ),
      builder: (_, k) => QuoteCard(
        isFavorite: k.boolean(
          label: 'Is Favorite',
          initial: false,
        ),
        statement: k.text(
          label: 'Statement',
          initial: 'The finest steel has to go through the hottest fire.',
        ),
        author: k.text(
          label: 'Author',
          initial: 'Author name',
        ),
      ),
    ),
    Story(
      name: 'Quotes in Grid',
      section: 'Quote',
      wrapperBuilder: (context, story, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: theme.gridSpacing,
          mainAxisSpacing: theme.gridSpacing,
          children: [for (int i = 0; i < 15; i++) child],
        ),
      ),
      builder: (_, k) => QuoteCard(
        isFavorite: k.boolean(
          label: 'Is Favorite',
          initial: false,
        ),
        statement: k.text(
          label: 'Statement',
          initial: 'A quote statement',
        ),
        author: k.text(
          label: 'Author',
          initial: 'Author name',
        ),
      ),
    ),
    Story.simple(
      name: 'Centered Circular Progress Indicator',
      child: const CenteredCircularProgressIndicator(),
    ),
    Story(
      name: 'Rounded Choice Chip',
      padding: const EdgeInsets.all(
        Spacing.medium,
      ),
      builder: (_, k) => RoundedChoiceChip(
        label: k.text(
          label: 'label',
          initial: 'I am a Chip!',
        ),
        isSelected: k.boolean(
          label: 'isSelected',
          initial: false,
        ),
        avatar: k.boolean(
          label: 'avatar',
          initial: false,
        )
            ? Icon(
                Icons.favorite,
                color: theme.roundedChoiceChipSelectedAvatarColor,
              )
            : null,
        onSelected: k.boolean(
          label: 'onSelected',
          initial: true,
        )
            ? (_) {}
            : null,
        backgroundColor: k.options(
          label: 'backgroundColor',
          initial: null,
          options: const [
            Option(
              'Light blue',
              Colors.lightBlue,
            ),
            Option(
              'Red accent',
              Colors.redAccent,
            ),
          ],
        ),
        selectedBackgroundColor: k.options(
          label: 'selectedBackgroundColor',
          initial: null,
          options: const [
            Option(
              'Green',
              Colors.green,
            ),
            Option(
              'Amber accent',
              Colors.amberAccent,
            ),
          ],
        ),
        labelColor: k.options(
          label: 'labelColor',
          initial: null,
          options: const [
            Option(
              'Teal',
              Colors.teal,
            ),
            Option(
              'Orange accent',
              Colors.orangeAccent,
            ),
          ],
        ),
        selectedLabelColor: k.options(
          label: 'selectedLabelColor',
          initial: null,
          options: const [
            Option(
              'Deep purple accent',
              Colors.deepPurpleAccent,
            ),
            Option(
              'Amber accent',
              Colors.amberAccent,
            ),
          ],
        ),
      ),
    ),
    Story(
      name: 'Chevron List Tile',
      padding: const EdgeInsets.all(
        Spacing.medium,
      ),
      builder: (_, k) => ChevronListTile(
        label: k.text(
          label: 'label',
          initial: 'Update Profile',
        ),
      ),
    ),
    Story.simple(
      name: 'Search Bar',
      child: const SearchBar(),
    ),
    Story.simple(
      name: 'Row App Bar',
      child: const RowAppBar(
        children: [
          FavoriteIconButton(
            isFavorite: true,
          ),
          UpvoteIconButton(
            count: 10,
            isUpvoted: true,
          ),
          DownvoteIconButton(
            count: 5,
            isDownvoted: false,
          ),
        ],
      ),
    ),
    Story(
      name: 'Shrinkable Text',
      builder: (_, k) => SafeArea(
        child: ShrinkableText(
          k.text(
            label: 'text',
            initial:
                'I am shrinkable text. I can resize myself automatically within a space.',
          ),
          style: k.options(
            label: 'style',
            initial: theme.quoteTextStyle.copyWith(
              fontSize: FontSize.xxLarge,
            ),
            options: [
              Option(
                'XX large',
                theme.quoteTextStyle.copyWith(
                  fontSize: FontSize.xxLarge,
                ),
              ),
              Option(
                'Small',
                theme.quoteTextStyle.copyWith(
                  fontSize: FontSize.small,
                ),
              ),
            ],
          ),
          textAlign: k.options(
            label: 'textAlign',
            initial: null,
            options: const [
              Option(
                'Start',
                TextAlign.start,
              ),
              Option(
                'End',
                TextAlign.end,
              ),
              Option(
                'Center',
                TextAlign.center,
              ),
              Option(
                'Justify',
                TextAlign.justify,
              ),
              Option(
                'Left',
                TextAlign.left,
              ),
              Option(
                'Right',
                TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}
