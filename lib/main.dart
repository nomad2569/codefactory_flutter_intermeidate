import 'package:codefactory_intermediate/common/component/custom_text_form.dart';
import 'package:codefactory_intermediate/common/provider/go_router.dart';
import 'package:codefactory_intermediate/common/view/splash_screen.dart';
import 'package:codefactory_intermediate/user/provider/auth_provider.dart';
import 'package:codefactory_intermediate/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProivder);
    return MaterialApp.router(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      theme: ThemeData(fontFamily: 'NotoSans'),
      // 우측 상단 debug 배너 없애기
      debugShowCheckedModeBanner: false,

      // * GoRouter 관련
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
