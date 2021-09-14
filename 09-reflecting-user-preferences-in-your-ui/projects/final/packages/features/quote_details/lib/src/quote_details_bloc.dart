import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_repository/quote_repository.dart';

part 'quote_details_event.dart';
part 'quote_details_state.dart';

class QuoteDetailsBloc extends Bloc<QuoteDetailsEvent, QuoteDetailsState> {
  QuoteDetailsBloc({
    required this.quoteId,
    required this.quoteRepository,
  }) : super(
          const QuoteDetailsInProgress(),
        ) {
    add(const QuoteDetailsStarted());
  }

  final int quoteId;
  final QuoteRepository quoteRepository;

  @override
  Stream<QuoteDetailsState> mapEventToState(QuoteDetailsEvent event) async* {
    if (event is QuoteDetailsStarted || event is QuoteDetailsRetried) {
      yield* _fetchQuoteDetails();
    } else {
      try {
        Quote updatedQuote;
        if (event is QuoteDetailsUpvoted) {
          updatedQuote = await quoteRepository.upvoteQuote(quoteId);
        } else if (event is QuoteDetailsDownvoted) {
          updatedQuote = await quoteRepository.downvoteQuote(quoteId);
        } else if (event is QuoteDetailsFavorited) {
          updatedQuote = await quoteRepository.favoriteQuote(quoteId);
        } else if (event is QuoteDetailsUnfavorited) {
          updatedQuote = await quoteRepository.unfavoriteQuote(quoteId);
        } else {
          updatedQuote = await quoteRepository.unvoteQuote(quoteId);
        }

        yield QuoteDetailsSuccess(
          quote: updatedQuote,
        );
      } catch (error) {
        final lastState = state;
        if (lastState is QuoteDetailsSuccess) {
          yield QuoteDetailsSuccess(
            quote: lastState.quote,
            eventError: error,
          );
        }
      }
    }
  }

  Stream<QuoteDetailsState> _fetchQuoteDetails() async* {
    yield const QuoteDetailsInProgress();
    try {
      final quote = await quoteRepository.getQuoteDetails(quoteId);
      yield QuoteDetailsSuccess(quote: quote);
    } catch (error) {
      yield const QuoteDetailsFailure();
    }
  }
}
