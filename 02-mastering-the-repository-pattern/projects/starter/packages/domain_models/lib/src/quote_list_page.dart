import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class QuoteListPage extends Equatable {
  const QuoteListPage({
    required this.isLastPage,
    required this.quoteList,
  });

  final bool isLastPage;
  final List<Quote> quoteList;

  @override
  List<Object?> get props => [
        isLastPage,
        quoteList,
      ];
}
