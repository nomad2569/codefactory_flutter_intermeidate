import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final String? title;
  final BottomNavigationBar? bottomNavigationBar;
  const DefaultLayout({
    super.key,
    required this.child,
    this.bgColor,
    this.title,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    // AppBar 사용하지 않을 때
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        // AppBar 가 앞으로 튀어나오는 정도
        elevation: 0,
        title: Text(title!,
            style: TextStyle(
              fontSize: 16.0,
            )),
        foregroundColor: Colors.black,
      );
    }
  }
}
