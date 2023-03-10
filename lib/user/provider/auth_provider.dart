import 'package:codefactory_intermediate/common/view/root_tab.dart';
import 'package:codefactory_intermediate/common/view/splash_screen.dart';
import 'package:codefactory_intermediate/order/view/order_screen.dart';
import 'package:codefactory_intermediate/restaurant/view/restaurant_detail_screen.dart';
import 'package:codefactory_intermediate/user/model/user_model.dart';
import 'package:codefactory_intermediate/user/provider/user_me_provider.dart';
import 'package:codefactory_intermediate/user/view/basket_screen.dart';
import 'package:codefactory_intermediate/user/view/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

//* GoRouter 활용한 provider
class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    //
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  // 우리가 관리할 실제 라우트 / 스크린 매핑
  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, __) => RootTab(),
            routes: [
              GoRoute(
                // `rid` 값을 routing 시 넘겨줄 수 있다.
                path: 'restaurant/:rid',
                name: RestaurantDetailScreen.routeName,
                builder: (_, state) => RestaurantDetailScreen(
                  id: state.params['rid']!,
                ),
              ),
            ]),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (_, __) => BasketScreen(),
        ),
        GoRoute(
          path: '/order-done',
          name: OrderScreen.routeName,
          builder: (_, __) => OrderScreen(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => LoginScreen(),
        ),
      ];

  //* 순환 import 를 방지하기 위해, `userMeProvider` 가 아닌
  // dio 를 의존하지 않는 함수를 만듦
  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작했을 때
  // 1. 토큰의 존재 확인
  // 2. 로그인 스크린으로 갈 것인가?
  //   2-1. 홈 스크린으로 갈 것인가?
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';

    // 유저 정보가 없는데
    // 로그인 중이라면 로그인 페이지
    // 로그인 중이 아니라면 로그인 페이지로 이동

    if (user == null) return logginIn ? null : '/login';

    // UserModel
    // 사용자 정보가 있는 상태이고,
    // 로그인 중이거나 현재 위치가 SplashScreen 이면
    // 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // 유저 정보를 받아올 때 에러가 났을 경우
    // TODO : 로그아웃 로직 추가해야함
    if (user is UserModelError) {
      return logginIn ? null : '/login';
    }
    return null;
  }
}
