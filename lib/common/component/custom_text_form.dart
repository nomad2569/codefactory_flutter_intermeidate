import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  const CustomTextFormField({
    super.key,
    this.hintText = "",
    this.errorText,
    this.autofocus = false,
    this.obscureText = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 기본으로 적용된 UnderlineInputBorder 를 덮어씌우기
    final baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      // 비밀번호 입력할 때, true
      obscureText: obscureText,
      // 화면 들어올 때 자동 focus
      autofocus: autofocus,
      // 값이 바뀔 때 마다 실행할 함수
      onChanged: onChanged,

      // Input 내부의 content 에 styling
      decoration: InputDecoration(
          // content 에 Padding 적용
          contentPadding: EdgeInsets.all(20),
          // placeHolder 적용
          hintText: hintText,
          // placeHolder styling
          hintStyle: TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14.0,
          ),
          // error 발생 시 메시지 적용
          errorText: errorText,
          // 배경색
          fillColor: INPUT_BG_COLOR,
          // 배경색 적용 or 적용하지 않기
          filled: true,
          // 모든 상태의 보더 스타일 세팅
          border: baseBorder,
          // 선택전의 보더 스타일 세팅
          enabledBorder: baseBorder,
          // input box 선택했을 때 스타일 세팅
          // `copyWith` 으로 기존 baseBorder 의 값들 오버라이딩
          focusedBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ))),
    );
  }
}
