part of 'quote_details_bloc.dart';

abstract class QuoteDetailsState extends Equatable {
  const QuoteDetailsState();

  @override
  List<Object?> get props => [];
}

class QuoteDetailsInProgress extends QuoteDetailsState {
  const QuoteDetailsInProgress();
}

class QuoteDetailsSuccess extends QuoteDetailsState {
  const QuoteDetailsSuccess({
    required this.quote,
    this.eventError,
  });

  final Quote quote;
  final dynamic eventError;

  @override
  List<Object?> get props => [
        quote,
        eventError,
      ];
}

class QuoteDetailsFailure extends QuoteDetailsState {
  const QuoteDetailsFailure();
}
