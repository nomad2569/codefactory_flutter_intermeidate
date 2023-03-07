import 'package:codefactory_intermediate/common/component/pagination_list_view.dart';
import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/common/utils/pagination_utils.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:codefactory_intermediate/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_intermediate/restaurant/repository/restaurant_repository.dart';
import 'package:codefactory_intermediate/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/model/cursor_pagination_model.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantStateProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            //* :rid 를 넣어주어야함
            // `go` 로 하면 직접 id 를 넣어줄 수 있지만 `goNamed` 에서는 아래와 같이 한다.
            // context.go('/restaurant/${model.id}');
            context.goNamed(RestaurantDetailScreen.routeName, params: {
              'rid': model.id,
            });
          },
          child: RestaurantCard.fromModel(
            restaurantModel: model,
            heroKey: model.id,
          ),
        );
      },
    );
  }
}
