import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_details/src/l10n/quote_details_localizations.dart';
import 'package:quote_details/src/quote_details_bloc.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:share_plus/share_plus.dart';

typedef QuoteDetailsShareableLinkGenerator = Future<String> Function(
  Quote quote,
);

class QuoteDetailsScreen extends StatelessWidget {
  const QuoteDetailsScreen({
    required this.quoteId,
    required this.onAuthenticationError,
    required this.quoteRepository,
    required this.shareableLinkGenerator,
    Key? key,
  }) : super(key: key);

  final int quoteId;
  final VoidCallback onAuthenticationError;
  final QuoteRepository quoteRepository;
  final QuoteDetailsShareableLinkGenerator shareableLinkGenerator;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteDetailsBloc>(
      create: (_) => QuoteDetailsBloc(
        quoteId: quoteId,
        quoteRepository: quoteRepository,
      ),
      child: QuoteDetailsView(
        onAuthenticationError: onAuthenticationError,
        shareableLinkGenerator: shareableLinkGenerator,
      ),
    );
  }
}

@visibleForTesting
class QuoteDetailsView extends StatelessWidget {
  const QuoteDetailsView({
    required this.onAuthenticationError,
    required this.shareableLinkGenerator,
    Key? key,
  }) : super(key: key);

  final VoidCallback onAuthenticationError;
  final QuoteDetailsShareableLinkGenerator shareableLinkGenerator;

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return StyledStatusBar.dark(
      child: BlocConsumer<QuoteDetailsBloc, QuoteDetailsState>(
        listener: (context, state) {
          final eventError =
              state is QuoteDetailsSuccess ? state.eventError : null;
          if (eventError != null) {
            final snackBar = eventError is UserAuthenticationRequiredException
                ? const AuthenticationRequiredErrorSnackBar()
                : const GenericErrorSnackBar();

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);

            if (eventError is UserAuthenticationRequiredException) {
              onAuthenticationError();
            }
          }
        },
        builder: (context, state) {
          final quote = state is QuoteDetailsSuccess ? state.quote : null;
          final bloc = context.read<QuoteDetailsBloc>();
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop(quote);
              return false;
            },
            child: Scaffold(
              appBar: RowAppBar(
                children: [
                  if (quote != null) ...[
                    FavoriteIconButton(
                      isFavorite: quote.isFavorite ?? false,
                      onTap: () {
                        bloc.add(
                          (quote.isFavorite ?? false)
                              ? const QuoteDetailsUnfavorited()
                              : const QuoteDetailsFavorited(),
                        );
                      },
                    ),
                    UpvoteIconButton(
                      count: quote.upvotesCount,
                      isUpvoted: quote.isUpvoted ?? false,
                      onTap: () {
                        bloc.add(
                          (quote.isUpvoted ?? false)
                              ? const QuoteDetailsUnvoted()
                              : const QuoteDetailsUpvoted(),
                        );
                      },
                    ),
                    DownvoteIconButton(
                      count: quote.downvotesCount,
                      isDownvoted: quote.isDownvoted ?? false,
                      onTap: () {
                        bloc.add(
                          (quote.isDownvoted ?? false)
                              ? const QuoteDetailsUnvoted()
                              : const QuoteDetailsDownvoted(),
                        );
                      },
                    ),
                    ShareIconButton(
                      onTap: () async {
                        final url = await shareableLinkGenerator(quote);
                        Share.share(
                          QuoteDetailsLocalizations.of(context).shareQuoteText(
                            url,
                          ),
                        );
                      },
                    ),
                  ]
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(
                    theme.screenMargin,
                  ),
                  child: quote != null
                      ? _Quote(
                          quote: quote,
                        )
                      : state is QuoteDetailsFailure
                          ? ExceptionIndicator(
                              onTryAgain: () {
                                bloc.add(
                                  const QuoteDetailsRetried(),
                                );
                              },
                            )
                          : const CenteredCircularProgressIndicator(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Quote extends StatelessWidget {
  static const double _quoteIconWidth = 46;

  const _Quote({
    required this.quote,
    Key? key,
  }) : super(key: key);

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: OpeningQuoteSvgAsset(
            width: _quoteIconWidth,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.xxLarge,
            ),
            child: Center(
              child: ShrinkableText(
                quote.body,
                style: theme.quoteTextStyle.copyWith(
                  fontSize: FontSize.xxLarge,
                ),
              ),
            ),
          ),
        ),
        const ClosingQuoteSvgAsset(
          width: _quoteIconWidth,
        ),
        const SizedBox(
          height: Spacing.medium,
        ),
        Text(
          quote.author ?? '',
          style: const TextStyle(
            fontSize: FontSize.large,
          ),
        ),
      ],
    );
  }
}
