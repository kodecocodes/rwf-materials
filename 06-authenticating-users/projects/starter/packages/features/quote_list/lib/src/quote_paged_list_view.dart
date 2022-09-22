import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quote_list/quote_list.dart';
import 'package:quote_list/src/quote_list_bloc.dart';

class QuotePagedListView extends StatelessWidget {
  const QuotePagedListView({
    required this.pagingController,
    this.onQuoteSelected,
    Key? key,
  }) : super(key: key);

  final PagingController<int, Quote> pagingController;
  final QuoteSelected? onQuoteSelected;

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    final onQuoteSelected = this.onQuoteSelected;
    final bloc = context.read<QuoteListBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.screenMargin,
      ),
      child: PagedListView.separated(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<Quote>(
            itemBuilder: (context, quote, index) {
              final isFavorite = quote.isFavorite ?? false;
              return QuoteCard(
                statement: quote.body,
                author: quote.author,
                isFavorite: isFavorite,
                top: const OpeningQuoteSvgAsset(),
                bottom: const ClosingQuoteSvgAsset(),
                onFavorite: () {
                  bloc.add(
                    isFavorite
                        ? QuoteListItemUnfavorited(quote.id)
                        : QuoteListItemFavorited(quote.id),
                  );
                },
                onTap: onQuoteSelected != null
                    ? () async {
                        final updatedQuote = await onQuoteSelected(quote.id);

                        if (updatedQuote != null &&
                            updatedQuote.isFavorite != quote.isFavorite) {
                          bloc.add(
                            QuoteListItemUpdated(
                              updatedQuote,
                            ),
                          );
                        }
                      }
                    : null,
              );
            },
            firstPageErrorIndicatorBuilder: (context) {
              return ExceptionIndicator(
                onTryAgain: () {
                  bloc.add(
                    const QuoteListFailedFetchRetried(),
                  );
                },
              );
            },
          ),
          separatorBuilder: (context, index) =>
              SizedBox(height: theme.gridSpacing)),
    );
  }
}
