import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quote_list/src/filter_horizontal_list.dart';
import 'package:quote_list/src/l10n/quote_list_localizations.dart';
import 'package:quote_list/src/quote_list_bloc.dart';
import 'package:quote_list/src/quote_sliver_grid.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:user_repository/user_repository.dart';

typedef QuoteSelected = Future<Quote?> Function(int selectedQuote);

class QuoteListScreen extends StatelessWidget {
  const QuoteListScreen({
    required this.quoteRepository,
    required this.userRepository,
    required this.onAuthenticationError,
    this.onQuoteSelected,
    Key? key,
  }) : super(key: key);

  final QuoteRepository quoteRepository;
  final UserRepository userRepository;
  final QuoteSelected? onQuoteSelected;
  final void Function(BuildContext context) onAuthenticationError;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuoteListBloc>(
      create: (_) => QuoteListBloc(
        quoteRepository: quoteRepository,
        userRepository: userRepository,
      ),
      child: QuoteListView(
        onAuthenticationError: onAuthenticationError,
        onQuoteSelected: onQuoteSelected,
      ),
    );
  }
}

@visibleForTesting
class QuoteListView extends StatefulWidget {
  const QuoteListView({
    required this.onAuthenticationError,
    this.onQuoteSelected,
    Key? key,
  }) : super(key: key);

  final QuoteSelected? onQuoteSelected;
  final void Function(BuildContext context) onAuthenticationError;

  @override
  _QuoteListViewState createState() => _QuoteListViewState();
}

class _QuoteListViewState extends State<QuoteListView> {
  final PagingController<int, Quote> _pagingController = PagingController(
    firstPageKey: 1,
  );

  final TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageNumber) {
      final isSubsequentPage = pageNumber > 1;
      if (isSubsequentPage) {
        final bloc = context.read<QuoteListBloc>();
        bloc.add(
          QuoteListNewPageRequested(
            pageNumber: pageNumber,
          ),
        );
      }
    });

    _searchBarController.addListener(() {
      final bloc = context.read<QuoteListBloc>();
      bloc.add(
        QuoteListSearchTermChanged(
          _searchBarController.text,
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    final l10n = QuoteListLocalizations.of(context);
    return BlocListener<QuoteListBloc, QuoteListState>(
      listener: (context, state) {
        final searchBarText = _searchBarController.text;
        final isSearching =
            state.filter != null && state.filter is QuoteListFilterBySearchTerm;
        if (searchBarText.isNotEmpty && !isSearching) {
          _searchBarController.text = '';
        }

        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.quoteListRefreshErrorMessage,
              ),
            ),
          );
        } else if (state.favoriteToggleError != null) {
          final snackBar =
              state.favoriteToggleError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          widget.onAuthenticationError(context);
        }

        _pagingController.value = state.toPagingState();
      },
      child: StyledStatusBar.dark(
        child: SafeArea(
          child: Scaffold(
            body: GestureDetector(
              onTap: () => _releaseFocus(context),
              child: RefreshIndicator(
                onRefresh: () {
                  final bloc = context.read<QuoteListBloc>();
                  bloc.add(
                    const QuoteListRefreshed(),
                  );

                  final stateChangeFuture = bloc.stream.first;
                  return stateChangeFuture;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.screenMargin,
                        ),
                        child: SearchBar(
                          controller: _searchBarController,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: FilterHorizontalList(),
                    ),
                    QuoteSliverGrid(
                      pagingController: _pagingController,
                      onQuoteSelected: widget.onQuoteSelected,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(
        context,
      ).unfocus();

  @override
  void dispose() {
    _pagingController.dispose();
    _searchBarController.dispose();
    super.dispose();
  }
}

extension on QuoteListState {
  PagingState<int, Quote> toPagingState() {
    return PagingState(
      itemList: itemList,
      nextPageKey: nextPage,
      error: error,
    );
  }
}
