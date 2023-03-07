import 'package:codefactory_intermediate/common/component/custom_text_form.dart';
import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/common/secure_storage/secure_storage.dart';
import 'package:codefactory_intermediate/common/view/root_tab.dart';
import 'package:codefactory_intermediate/user/model/user_model.dart';
import 'package:codefactory_intermediate/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userMeProvider);
    return DefaultLayout(
      // 키보드가 올라오면 Widget 을 잘라먹기 때문에
      // * ScrollView 로 감싸서 이 페이지의 height 을 늘릴 수 있게 함.
      child: SingleChildScrollView(
        // * 키보드가 올라와있을 때, 드래그 하는 순간 키보드가 내려가게 설정.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                if (userState is UserModelLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (userState is! UserModelLoading) ...[
                  CustomTextFormField(
                    hintText: '이메일을 입력해주세요!',
                    onChanged: (String value) {
                      username = value;
                    },
                    autofocus: true,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  CustomTextFormField(
                    hintText: '비밀번호를 입력해주세요!',
                    onChanged: (String value) {
                      password = value;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 24.0,
                  )
                ],
                ElevatedButton(
                  onPressed: userState is UserModelLoading
                      ? null
                      : () async {
                          ref
                              .read(userMeProvider.notifier)
                              .login(username: username, password: password);
                        },
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
