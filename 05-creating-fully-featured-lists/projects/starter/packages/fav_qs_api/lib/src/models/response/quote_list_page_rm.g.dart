// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_list_page_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteListPageRM _$QuoteListPageRMFromJson(Map<String, dynamic> json) {
  return $checkedNew('QuoteListPageRM', json, () {
    final val = QuoteListPageRM(
      isLastPage: $checkedConvert(json, 'last_page', (v) => v as bool),
      quoteList: $checkedConvert(
          json,
          'quotes',
          (v) => (v as List<dynamic>)
              .map((e) => QuoteRM.fromJson(e as Map<String, dynamic>))
              .toList()),
    );
    return val;
  }, fieldKeyMap: const {'isLastPage': 'last_page', 'quoteList': 'quotes'});
}
