import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/common/view/root_tab.dart';
import 'package:codefactory_intermediate/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // API 호출을 위한 dio 활성화
  final dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // deleteToken();
    // Token 의 유무 파악
    checkToken();
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    try {
      // refreshToken 으로 갱신 요청
      final response = await dio.post('http://$baseIp:$basePort/auth/token',
          options: Options(headers: {
            'authorization': 'Bearer $refreshToken',
          }));
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: response.data['accessToken']);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RootTab()),
        (route) => false,
      );
    } catch (e) {
      // refreshToken 이 만료되었다면
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
