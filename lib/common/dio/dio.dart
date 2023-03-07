import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../secure_storage/secure_storage.dart';

final dioProvider = Provider((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(
    CustomInterceptor(storage: storage, ref: ref),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.storage, required this.ref});

// 1. 요청을 받을 때
  // 요청 시, 'accessToken' = 'true' -> stroage 의 ACCESS_TOKEN 을 authorization 에 추가
  //
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    // access_token 삽입
    if (options.headers['accessToken'] == 'true') {
      // 키워드 헤더 삭제
      options.headers.remove('accessToken');

      // 실제 토큰 삽입
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    // refresh token 삽입
    if (options.headers['refreshToken'] == 'true') {
      // 키워드 헤더 삭제
      options.headers.remove('refreshToken');

      // 실제 토큰 삽입
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    // 실제 요청 보내기
    return super.onRequest(options, handler);
  }

// 2. 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

// 3. 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401
    // refreshToken 기반으로 토큰 재발급 시도
    // 토큰 재발급 시, 새로운 토큰으로 재요청
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 마저 없다면
    if (refreshToken == null) {
      // 에러를 그대로 생성한다.
      return handler.reject(err);
    }

    // token 을 refresh 하려다가 에러가 난 것일까 판별
    final respCode = err.response?.statusCode;
    final isPathRefresh = err.requestOptions.uri == '/auth/token';
    if (respCode == 401 && !isPathRefresh) {
      // 401 status 인데, refreshToken 을 인증하려고 한 것이 아닌 경우
      final dio = Dio();

      try {
        // refreshToken 으로 accessToken 발급 요청
        final resp = await dio.post('http://$baseIp:$basePort/auth/token',
            options: Options(
              headers: {
                "authorization": "Bearer $refreshToken",
              },
            ));

        // 에러가 안났으므로, response 에서 새로운 토큰 가져오기
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        // 요청에 새로운 토큰 추가하기
        options.headers.addAll({'authorization': 'Bearer ${accessToken}'});
        // storage 에도 새로운 토큰 추가하기
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 인증 토큰 추가하여, 기존 요청 재전송하기
        final newResp = await dio.fetch(options);

        // 새로운 요청에 대한 응답 반환하기
        return handler.resolve(newResp);
      } on DioError catch (e) {
        //* 에러가 발생했을 때 로그아웃
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }
    return super.onError(err, handler);
  }
}
