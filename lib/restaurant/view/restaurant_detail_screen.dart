import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/product/component/product_card.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:codefactory_intermediate/restaurant/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override

  // id 화면에 들어갈 때마다 detail 요청
  void initState() {
    super.initState();

    // 상위 클래스 ConsumerStatefulWidget 의 property 접근
    ref.read(restaurantStateProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // id 에 맞는 state 를 찾아옴
    final state = ref.watch(restuarantDetailProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DefaultLayout(
        title: state.name,
        child: CustomScrollView(slivers: [
          renderTop(state),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel) renderProducts(state.products),
        ]));
  }
}

SliverToBoxAdapter renderTop(RestaurantModel restaurantModel) {
  return SliverToBoxAdapter(
    child: Column(
      children: [
        RestaurantCard.fromModel(
          restaurantModel: restaurantModel,
          isDetail: true,
        ),
      ],
    ),
  );
}

SliverPadding renderLabel() {
  return const SliverPadding(
    padding: EdgeInsets.all(16.0),
    sliver: SliverToBoxAdapter(
        child: Text(
      "메뉴",
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      ),
    )),
  );
}

// SliverList 를 반환함
renderProducts(List<ProductModel> products) {
  // Sliver 에 padding 주기
  // * child 대신 sliver 사용
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard(
              product: products[index],
            ),
          );
        },
        childCount: products.length,
      ),
    ),
  );
}
