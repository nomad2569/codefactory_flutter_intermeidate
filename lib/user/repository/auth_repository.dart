import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/common/utils/data_utils.dart';
import 'package:codefactory_intermediate/user/model/login_response.dart';
import 'package:codefactory_intermediate/user/model/token_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio: dio, baseUrl: 'http://$baseIp:$basePort/user/me');
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login(
      {required String username, required String password}) async {
    final serialized = DataUtils.plainToBase64('$username:$password');
    print(username);
    print(password);

    final resp = await dio.post('http://$baseIp:$basePort/auth/login',
        options: Options(
          headers: {
            'authorization': 'Basic $serialized',
          },
        ));
    return LoginResponse.fromJson(resp.data);
  }

  Future<TokenResponse> token() async {
    final resp = await dio.post(
      'http://$baseIp:$basePort/token',
      options: Options(
        headers: {'refreshToken': true},
      ),
    );

    return TokenResponse.fromJson(resp.data);
  }
}
