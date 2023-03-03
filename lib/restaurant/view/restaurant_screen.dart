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

import '../../common/model/cursor_pagination_model.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  // * 스크롤 마지막 내렸을 때 핸들링
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      scrollController: scrollController,
      provider: ref.read(restaurantStateProvider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* 
    - restaurantStateProvider
      - RestaurantStateNotifier
        - RestaurantRepositoryProvider (retrofit: `RestaurantRepository`)
          - dioProvider, storageProvider
    */
    final data = ref.watch(restaurantStateProvider);

    // data 가 로딩중이라면 (첫 로딩)
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // 나머지 패치 성공, 로딩 중인 경우 캐스팅
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        // * 스크롤 컨트롤러
        controller: scrollController,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Center(
              child: data is CursorPaginationFetchingMore
                  ? CircularProgressIndicator()
                  : Text("마지막 데이터!"),
            );
          }

          final item = cp.data[index];
          // repo 결과인 Model 을 기반으로 RestaurantCard 생성
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: item.id.toString(),
                  ),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              restaurantModel: item,
              heroKey: item.id,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 16,
          );
        },
      ),
    );
  }
}
