import 'package:hive/hive.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:key_value_storage/src/models/dark_mode_preference_cm.dart';
import 'package:key_value_storage/src/models/models.dart';
import 'package:key_value_storage/src/models/user_cm.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

/// Wraps [Hive] so that we can register all adapters and manage all keys in a
/// single place.
///
/// To use this class, simply unwrap one of its exposed boxes, like
/// [quoteListPageBox], and execute operations in it, for example:
///
/// ```
/// (await quoteListPageBox).clear();
/// ```
///
/// Storing non-primitive types in Hive requires us to use incremental [typeId]s.
/// Having all these models and boxes' keys in a single package allows us to
/// avoid conflicts.
class KeyValueStorage {
  static const _quoteListPagesBoxKey = 'quote-list-pages';
  static const _favoriteQuoteListPagesBoxKey = 'favorite-quote-list-pages';
  static const _darkModePreferenceBoxKey = 'dark-mode-preference';
  static const _userBoxKey = 'user';

  KeyValueStorage({
    @visibleForTesting HiveInterface? hive,
  }) : _hive = hive ?? Hive {
    try {
      _hive
        ..registerAdapter(QuoteListPageCMAdapter())
        ..registerAdapter(QuoteCMAdapter())
        ..registerAdapter(DarkModePreferenceCMAdapter())
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

  Future<Box<DarkModePreferenceCM>> get darkModePreferenceBox =>
      _openHiveBox<DarkModePreferenceCM>(
        _darkModePreferenceBoxKey,
        isTemporary: false,
      );

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
