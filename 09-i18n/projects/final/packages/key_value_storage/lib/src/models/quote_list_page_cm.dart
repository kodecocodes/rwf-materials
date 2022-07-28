import 'package:hive/hive.dart';
import 'package:key_value_storage/src/models/models.dart';

part 'quote_list_page_cm.g.dart';

@HiveType(typeId: 1)
class QuoteListPageCM {
  const QuoteListPageCM({
    required this.isLastPage,
    required this.quoteList,
  });

  @HiveField(0)
  final bool isLastPage;
  @HiveField(1)
  final List<QuoteCM> quoteList;
}
