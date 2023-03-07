import 'package:codefactory_intermediate/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            ref.watch(userMeProvider.notifier).logout();
          },
          child: Text('로그아웃')),
    );
  }
}
