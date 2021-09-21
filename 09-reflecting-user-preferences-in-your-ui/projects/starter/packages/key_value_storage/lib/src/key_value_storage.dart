import 'package:hive/hive.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:key_value_storage/src/models/dark_mode_preference_cm.dart';
import 'package:key_value_storage/src/models/models.dart';
import 'package:key_value_storage/src/models/user_cm.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class KeyValueStorage {
  static const _quoteListPagesBoxKey = 'quote-list-pages';
  static const _favoriteQuoteListPagesBoxKey = 'favorite-quote-list-pages';
  //TODO: Add  hive box key
  static const _userBoxKey = 'user';

  KeyValueStorage({
    @visibleForTesting HiveInterface? hive,
  }) : _hive = hive ?? Hive {
    try {
      _hive
        ..registerAdapter(QuoteListPageCMAdapter())
        ..registerAdapter(QuoteCMAdapter())
        //TODO: register the adapter
        ..registerAdapter(
          UserCMAdapter(),
        );
    } catch (_) {
      throw Exception(
          'You shouldn\'t have more than one [KeyValueStorage] instance in your '
          'project');
    }
  }

  final HiveInterface _hive;

  Future<Box<QuoteListPageCM>> get quoteListPageBox =>
      _openHiveBox<QuoteListPageCM>(
        _quoteListPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<QuoteListPageCM>> get favoriteQuoteListPageBox =>
      _openHiveBox<QuoteListPageCM>(
        _favoriteQuoteListPagesBoxKey,
        isTemporary: true,
      );

  Future<Box<UserCM>> get userBox => _openHiveBox<UserCM>(
        _userBoxKey,
        isTemporary: false,
      );

  //TODO: get the box by key

  Future<Box<T>> _openHiveBox<T>(
    String boxKey, {
    required bool isTemporary,
  }) async {
    if (_hive.isBoxOpen(boxKey)) {
      return _hive.box(boxKey);
    } else {
      final directory = await (isTemporary
          ? getTemporaryDirectory()
          : getApplicationDocumentsDirectory());
      return _hive.openBox<T>(
        boxKey,
        path: directory.path,
      );
    }
  }
}
