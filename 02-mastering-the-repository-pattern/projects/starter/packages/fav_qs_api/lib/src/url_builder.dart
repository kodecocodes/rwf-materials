class UrlBuilder {
  const UrlBuilder({
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? 'https://favqs.com/api';

  final String _baseUrl;

  String buildGetQuoteListPageUrl(
    int page, {
    String? tag,
    String searchTerm = '',
    String? favoritedByUsername,
  }) {
    assert(
        (tag == null && searchTerm.isEmpty) ||
            (searchTerm.isEmpty && favoritedByUsername == null) ||
            (favoritedByUsername == null && tag == null),
        'FavQs doesn\'t support filtering favorites or searching by both query and '
        'tag at the same time.');

    final tagQueryStringPart = tag != null ? '&filter=$tag&type=tag' : '';
    final favoriteQueryStringPart = favoritedByUsername != null
        ? '&filter=$favoritedByUsername&type=user'
        : '';
    final searchQueryStringPart =
        searchTerm.isNotEmpty ? '&filter=$searchTerm' : '';
    return '$_baseUrl/quotes/?page=$page$tagQueryStringPart$searchQueryStringPart$favoriteQueryStringPart';
  }

  String buildGetQuoteUrl(int id) {
    return '$_baseUrl/quotes/$id';
  }

  String buildFavoriteQuoteUrl(int id) {
    return '$_baseUrl/quotes/$id/fav';
  }

  String buildUnfavoriteQuoteUrl(int id) {
    return '$_baseUrl/quotes/$id/unfav';
  }

  String buildUpvoteQuoteUrl(int id) {
    return '$_baseUrl/quotes/$id/upvote';
  }

  String buildDownvoteQuoteUrl(int id) {
    return '$_baseUrl/quotes/$id/downvote';
  }

  String buildUnvoteQuoteUrl(int id) {
    return '$_baseUrl/quotes/$id/clearvote';
  }

  String buildSignInUrl() {
    return '$_baseUrl/session';
  }

  String buildSignOutUrl() {
    return '$_baseUrl/session';
  }

  String buildSignUpUrl() {
    return '$_baseUrl/users';
  }

  String buildUpdateProfileUrl(String username) {
    return '$_baseUrl/users/$username';
  }

  String buildRequestPasswordResetEmailUrl() {
    return '$_baseUrl/users/forgot_password';
  }
}
