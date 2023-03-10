import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/utils/pagination_utils.dart';
import 'package:codefactory_intermediate/product/component/product_card.dart';
import 'package:codefactory_intermediate/rating/component/rating_card.dart';
import 'package:codefactory_intermediate/rating/model/rating_model.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:codefactory_intermediate/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory_intermediate/restaurant/provider/restaurant_rating_provider.dart';
import 'package:codefactory_intermediate/user/provider/basket_provider.dart';
import 'package:codefactory_intermediate/user/view/basket_screen.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';
import 'package:badges/badges.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurant_detail';

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
  final ScrollController scrollController = ScrollController();

  // id 화면에 들어갈 때마다 detail 요청
  @override
  void initState() {
    super.initState();

    // 상위 클래스 ConsumerStatefulWidget 의 property 접근
    ref.read(restaurantStateProvider.notifier).getDetail(id: widget.id);

    scrollController.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      scrollController: scrollController,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    // id 에 맞는 state 를 찾아옴
    final state = ref.watch(restuarantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basketState = ref.watch(basketProvider);
    if (state == null) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        child: Badge(
          showBadge: !basketState.isEmpty,
          badgeContent: Text(
            basketState.fold<int>(
              0,
              (previousValue, element) {
                return previousValue + element.count;
              },
            ).toString(),
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10.0,
            ),
          ),
          child: Icon(Icons.shopping_bag_outlined),
          badgeColor: Colors.white,
        ),
      ),
      title: state.name,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          renderTop(state),
          renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(products: state.products),
          if (state is! RestaurantDetailModel)
            const SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(ratingsState.data),
          if (ratingsState is CursorPaginationFetchingMore<RatingModel>)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }

  SliverToBoxAdapter renderTop(RestaurantModel restaurantModel) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          RestaurantCard.fromModel(
            restaurantModel: restaurantModel,
            isDetail: true,
            heroKey: restaurantModel.id,
          ),
        ],
      ),
    );
  }

// * skeleton 적용 시 에러 나중에 할 것
  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            SkeletonParagraph(
              style: SkeletonParagraphStyle(lines: 2),
            ),
          ],
        ),
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
  SliverPadding renderProducts({required List<ProductModel> products}) {
    // Sliver 에 padding 주기
    // * child 대신 sliver 사용
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            //* 눌렀을 떄 화면에 그대로 있다면 `InkWell` 을 사용한다.
            //* `GestureDetector` 는 UI 피드백이 없음.
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: products[index],
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard(
                  product: products[index],
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding renderRatings(List<RatingModel> ratings) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return RatingCard.fromModel(ratingModel: ratings[index]);
          }, childCount: ratings.length),
        ));
  }
}
