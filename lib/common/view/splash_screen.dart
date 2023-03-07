import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/common/view/root_tab.dart';
import 'package:codefactory_intermediate/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../secure_storage/secure_storage.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      bgColor: PRIMARY_COLOR,
      child: SizedBox(
        // 넓이를 최대로 하여 자동으로 좌우 정렬이 되게 함
        width: MediaQuery.of(context).size.width,
        child: Column(
          // 가운데 정렬
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
