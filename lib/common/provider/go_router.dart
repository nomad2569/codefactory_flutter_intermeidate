import 'package:codefactory_intermediate/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProivder = Provider<GoRouter>((ref) {
  // watch - 값이 변경될 때 마다 다시 빌드한다.
  // read - 한번만 읽고 값이 변경되도 빌드 안함
  final provider = ref.read(authProvider);
  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    redirect: provider.redirectLogic,
    refreshListenable: provider,
  );
});
