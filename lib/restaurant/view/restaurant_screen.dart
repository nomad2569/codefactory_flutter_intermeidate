import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:codefactory_intermediate/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_intermediate/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/model/cursor_pagination_model.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantStateProvider);
    /* 
    - restaurantStateProvider
      - RestaurantStateNotifier
        - RestaurantRepositoryProvider (retrofit: `RestaurantRepository`)
          - dioProvider, storageProvider
    */
    if (data.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: data.length,
        itemBuilder: (_, index) {
          final item = data[index];
          // repo 결과인 Model 을 기반으로 RestaurantCard 생성
          return RestaurantCard.fromModel(restaurantModel: item);
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 16,
          );
        },
      ),
    );
  }
}
