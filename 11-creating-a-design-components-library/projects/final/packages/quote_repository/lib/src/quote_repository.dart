import 'package:domain_models/domain_models.dart';
import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:meta/meta.dart';
import 'package:quote_repository/src/mappers/mappers.dart';
import 'package:quote_repository/src/quote_local_storage.dart';

class QuoteRepository {
  QuoteRepository({
    required KeyValueStorage keyValueStorage,
    required this.remoteApi,
    @visibleForTesting QuoteLocalStorage? localStorage,
  }) : _localStorage = localStorage ??
            QuoteLocalStorage(
              keyValueStorage: keyValueStorage,
            );

  final FavQsApi remoteApi;
  final QuoteLocalStorage _localStorage;

  Stream<QuoteListPage> getQuoteListPage(
    int pageNumber, {
    Tag? tag,
    String searchTerm = '',
    String? favoritedByUsername,
    required QuoteListPageFetchPolicy fetchPolicy,
  }) async* {
    final isFilteringByTag = tag != null;
    final isSearching = searchTerm.isNotEmpty;
    final isFetchPolicyNetworkOnly =
        fetchPolicy == QuoteListPageFetchPolicy.networkOnly;
    final shouldUseCache =
        !(isFilteringByTag || isSearching || isFetchPolicyNetworkOnly);
    if (!shouldUseCache) {
      yield await _getQuoteListPageFromNetwork(
        pageNumber,
        tag: tag,
        searchTerm: searchTerm,
        favoritedByUsername: favoritedByUsername,
      );
    } else {
      final isFilteringByFavorites = favoritedByUsername != null;
      final cachedPage = await _localStorage.getQuoteListPage(
        pageNumber,
        isFilteringByFavorites,
      );

      final isFetchPolicyCacheAndNetwork =
          fetchPolicy == QuoteListPageFetchPolicy.cacheAndNetwork;

      final isFetchPolicyCacheFirst =
          fetchPolicy == QuoteListPageFetchPolicy.cacheFirst;

      final shouldEmitCachedPageFirst =
          isFetchPolicyCacheFirst || isFetchPolicyCacheAndNetwork;

      if (shouldEmitCachedPageFirst && cachedPage != null) {
        yield cachedPage.toDomainModel();
      }

      final isFetchPolicyNetworkFirst =
          fetchPolicy == QuoteListPageFetchPolicy.networkFirst;
      try {
        final shouldFetchDataFromNetwork = isFetchPolicyCacheAndNetwork ||
            isFetchPolicyNetworkFirst ||
            (isFetchPolicyCacheFirst && cachedPage == null);
        if (shouldFetchDataFromNetwork) {
          final networkPage = await _getQuoteListPageFromNetwork(
            pageNumber,
            favoritedByUsername: favoritedByUsername,
          );
          yield networkPage;
        }
      } catch (error) {
        if (cachedPage != null && isFetchPolicyNetworkFirst) {
          yield cachedPage.toDomainModel();
        }
        rethrow;
      }
    }
  }

  Future<QuoteListPage> _getQuoteListPageFromNetwork(
    int pageNumber, {
    Tag? tag,
    String searchTerm = '',
    String? favoritedByUsername,
  }) async {
    final isFiltering = tag != null || searchTerm.isNotEmpty;
    final favoritesOnly = favoritedByUsername != null;

    try {
      final apiPage = await remoteApi.getQuoteListPage(
        pageNumber,
        tag: tag?.toRemoteModel(),
        searchTerm: searchTerm,
        favoritedByUsername: favoritedByUsername,
      );

      final shouldStoreOnCache = !isFiltering;
      if (shouldStoreOnCache) {
        final shouldEmptyCache = pageNumber == 1;
        if (shouldEmptyCache) {
          await _localStorage.clearQuoteListPageList(favoritesOnly);
        }

        final cachePage = apiPage.toCacheModel();
        await _localStorage.upsertQuoteListPage(
          pageNumber,
          cachePage,
          favoritesOnly,
        );
      }

      final domainPage = apiPage.toDomainModel();
      return domainPage;
    } on EmptySearchResultFavQsException catch (_) {
      throw EmptySearchResultException();
    }
  }

  Future<Quote> getQuoteDetails(int id) async {
    final cachedQuote = await _localStorage.getQuote(id);
    if (cachedQuote != null) {
      return cachedQuote.toDomainModel();
    } else {
      final apiQuote = await remoteApi.getQuote(id);
      final domainQuote = apiQuote.toDomainModel();
      return domainQuote;
    }
  }

  Future<Quote> favoriteQuote(int id) async {
    final updatedCacheQuote =
        await remoteApi.favoriteQuote(id).toCacheUpdateFuture(
              _localStorage,
              shouldInvalidateFavoritesCache: true,
            );
    return updatedCacheQuote.toDomainModel();
  }

  Future<Quote> unfavoriteQuote(int id) async {
    final updatedCacheQuote =
        await remoteApi.unfavoriteQuote(id).toCacheUpdateFuture(
              _localStorage,
              shouldInvalidateFavoritesCache: true,
            );
    return updatedCacheQuote.toDomainModel();
  }

  Future<Quote> upvoteQuote(int id) async {
    final updatedCacheQuote =
        await remoteApi.upvoteQuote(id).toCacheUpdateFuture(
              _localStorage,
            );
    return updatedCacheQuote.toDomainModel();
  }

  Future<Quote> downvoteQuote(int id) async {
    final updatedCacheQuote =
        await remoteApi.downvoteQuote(id).toCacheUpdateFuture(
              _localStorage,
            );
    return updatedCacheQuote.toDomainModel();
  }

  Future<Quote> unvoteQuote(int id) async {
    final updatedCacheQuote =
        await remoteApi.unvoteQuote(id).toCacheUpdateFuture(
              _localStorage,
            );
    return updatedCacheQuote.toDomainModel();
  }

  Future<void> clearCache() async {
    await _localStorage.clear();
  }
}

extension on Future<QuoteRM> {
  Future<QuoteCM> toCacheUpdateFuture(
    QuoteLocalStorage localStorage, {
    bool shouldInvalidateFavoritesCache = false,
  }) async {
    try {
      final updatedApiQuote = await this;
      final updatedCacheQuote = updatedApiQuote.toCacheModel();
      await Future.wait(
        [
          localStorage.updateQuote(
            updatedCacheQuote,
            !shouldInvalidateFavoritesCache,
          ),
          if (shouldInvalidateFavoritesCache)
            localStorage.clearQuoteListPageList(true),
        ],
      );
      return updatedCacheQuote;
    } catch (error) {
      if (error is UserAuthRequiredFavQsException) {
        throw UserAuthenticationRequiredException();
      }
      rethrow;
    }
  }
}

enum QuoteListPageFetchPolicy {
  cacheAndNetwork,
  networkOnly,
  networkFirst,
  cacheFirst,
}
