import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/common/secure_storage/secure_storage.dart';
import 'package:codefactory_intermediate/user/model/user_model.dart';
import 'package:codefactory_intermediate/user/provider/auth_provider.dart';
import 'package:codefactory_intermediate/user/repository/auth_repository.dart';
import 'package:codefactory_intermediate/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final dio = ref.watch(dioProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
      authRepository: authRepository,
      repository: userMeRepository,
      storage: storage);
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;
  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 첫 생성 시 내 정보 가져오기
    getMe();
  }

  Future<void> getMe() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (accessToken == null || refreshToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getMe();

    state = resp;
  }

  Future<UserModelBase> login(
      {required String username, required String password}) async {
    try {
      state = UserModelLoading();
      final resp =
          await authRepository.login(username: username, password: password);

      // 새로 받은 토큰 저장
      await Future.wait([
        storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken),
        storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken),
      ]);

      // 로그인 시, 현재 유저의 정보 가져오기
      // `getMe` 를 하며 서버에서 token 의 유효성 검증
      final userResp = await repository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      // 로그인 실패 더 자세히 처리해야 함.
      state = UserModelError(message: '로그인에 실패하였습니다.');

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    // state 가 null 이 되면, `goRouter` redirect 가 login 으로 전송시킴
    state = null;

    //* 두 개가 동시에 시행됨. 조금 더 빨라짐
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);
  }
}
