import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  const DefaultLayout({super.key, required this.child, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor ?? Colors.white,
      body: child,
    );
  }
}
