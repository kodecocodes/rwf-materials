import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quote_list/quote_list.dart';
import 'package:quote_list/src/quote_list_bloc.dart';

class QuoteSliverGrid extends StatelessWidget {
  static const _gridColumnCount = 2;

  const QuoteSliverGrid({
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
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.screenMargin,
      ),
      sliver: PagedStaggeredSliverGrid.count(
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
                final bloc = context.read<QuoteListBloc>();
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
                        final bloc = context.read<QuoteListBloc>();
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
                final bloc = context.read<QuoteListBloc>();
                bloc.add(
                  const QuoteListFirstPageRequested(),
                );
              },
            );
          },
          firstPageProgressIndicatorBuilder: (context) {
            return const LoadingIndicator();
          },
          newPageProgressIndicatorBuilder: (context) {
            return const LoadingIndicator();
          },
        ),
        crossAxisCount: _gridColumnCount,
        crossAxisSpacing: theme.gridSpacing,
        mainAxisSpacing: theme.gridSpacing,
        staggeredTileBuilder: (_) => const StaggeredTile.fit(
          1,
        ),
      ),
    );
  }
}
