import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/model/pagination_params.dart';
import 'package:codefactory_intermediate/common/provider/paginate_provider.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

final restuarantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantStateProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantStateProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(RestaurantRepositoryProvider);
  return RestaurantStateNotifier(
    repository: repo,
  );
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 데이터가 하나도 없는 상태라면, 데이터 1번 불러오기
    if (state is! CursorPagination) {
      await paginate();
    }
    // 한 번 fetch 했는데도 없으면 끝
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    // id 에 해당하는 detail 정보 불러오기
    final resp = await repository.getRestaurantDetail(id: id);

    // 현재 정보 업데이트 하기
    // 1. id 와 일치하는 데이터 찾기
    // 2. resp 불러온 값이 있으면 업데이트 하기

    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(),
    );
  }
}
