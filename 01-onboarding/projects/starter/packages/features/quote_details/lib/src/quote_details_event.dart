part of 'quote_details_bloc.dart';

abstract class QuoteDetailsEvent extends Equatable {
  const QuoteDetailsEvent();

  @override
  List<Object?> get props => [];
}

class QuoteDetailsStarted extends QuoteDetailsEvent {
  const QuoteDetailsStarted();
}

class QuoteDetailsRetried extends QuoteDetailsEvent {
  const QuoteDetailsRetried();
}

class QuoteDetailsFavorited extends QuoteDetailsEvent {
  const QuoteDetailsFavorited();
}

class QuoteDetailsUnfavorited extends QuoteDetailsEvent {
  const QuoteDetailsUnfavorited();
}

class QuoteDetailsUpvoted extends QuoteDetailsEvent {
  const QuoteDetailsUpvoted();
}

class QuoteDetailsDownvoted extends QuoteDetailsEvent {
  const QuoteDetailsDownvoted();
}

class QuoteDetailsUnvoted extends QuoteDetailsEvent {
  const QuoteDetailsUnvoted();
}
