import 'package:codefactory_intermediate/common/component/custom_text_form.dart';
import 'package:codefactory_intermediate/common/view/splash_screen.dart';
import 'package:codefactory_intermediate/user/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      // 우측 상단 debug 배너 없애기
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
