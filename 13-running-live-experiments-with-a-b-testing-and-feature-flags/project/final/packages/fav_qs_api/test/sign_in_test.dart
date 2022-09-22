import 'package:dio/dio.dart';
import 'package:fav_qs_api/src/fav_qs_api.dart';
import 'package:fav_qs_api/src/models/models.dart';
import 'package:fav_qs_api/src/url_builder.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';

void main() {
  group('Sign in:', () {
    final dio = Dio(BaseOptions());
    final dioAdapter = DioAdapter(dio: dio);

    const email = 'email';
    const password = 'password';

    final remoteApi =
        FavQsApi(userTokenSupplier: () => Future.value(), dio: dio);

    final url = const UrlBuilder().buildSignInUrl();

    final requestJsonBody = const SignInRequestRM(
      credentials: UserCredentialsRM(
        email: email,
        password: password,
      ),
    ).toJson();

    test(
        'When sign in call completes successfully, returns an instance of UserRM',
        () async {
      dioAdapter.onPost(
        url,
        (server) => server.reply(
          200,
          {"User-Token": "token", "login": "login", "email": "email"},
          delay: const Duration(seconds: 1),
        ),
        data: requestJsonBody,
      );

      expect(await remoteApi.signIn(email, password), isA<UserRM>());
    });
  });
}
