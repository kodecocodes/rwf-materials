import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_repository/quote_repository.dart';

part 'quote_details_state.dart';

class QuoteDetailsCubit extends Cubit<QuoteDetailsState> {
  QuoteDetailsCubit({
    required this.quoteId,
    required this.quoteRepository,
  }) : super(
          const QuoteDetailsInProgress(),
        ) {
    _fetchQuoteDetails();
  }

  final int quoteId;
  final QuoteRepository quoteRepository;

  Future<void> _fetchQuoteDetails() async {
    try {
      final quote = await quoteRepository.getQuoteDetails(quoteId);
      emit(
        QuoteDetailsSuccess(quote: quote),
      );
    } catch (error) {
      emit(
        const QuoteDetailsFailure(),
      );
    }
  }

  Future<void> refetch() async {
    emit(
      const QuoteDetailsInProgress(),
    );

    _fetchQuoteDetails();
  }

  void upvoteQuote() async {
    await _executeQuoteUpdateOperation(
      () => quoteRepository.upvoteQuote(quoteId),
    );
  }

  void downvoteQuote() async {
    await _executeQuoteUpdateOperation(
      () => quoteRepository.downvoteQuote(quoteId),
    );
  }

  void unvoteQuote() async {
    await _executeQuoteUpdateOperation(
      () => quoteRepository.unvoteQuote(quoteId),
    );
  }

  void favoriteQuote() async {
    await _executeQuoteUpdateOperation(
      () => quoteRepository.favoriteQuote(quoteId),
    );
  }

  void unfavoriteQuote() async {
    await _executeQuoteUpdateOperation(
      () => quoteRepository.unfavoriteQuote(quoteId),
    );
  }

  Future<void> _executeQuoteUpdateOperation(
    Future<Quote> Function() updateQuote,
  ) async {
    try {
      final updatedQuote = await updateQuote();
      emit(
        QuoteDetailsSuccess(
          quote: updatedQuote,
        ),
      );
    } catch (error) {
      final lastState = state;
      if (lastState is QuoteDetailsSuccess) {
        emit(
          QuoteDetailsSuccess(
            quote: lastState.quote,
            quoteUpdateError: error,
          ),
        );
      }
    }
  }
}
