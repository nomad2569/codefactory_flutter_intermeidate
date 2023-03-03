import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/model/pagination_params.dart';
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

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;
  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    // 첫 시작을 Loading 상태로 정의
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 가져올 데이터가 있는지
    // true: 추가로 데이터 가져오기
    // false: 새로고침
    bool fetchMore = false,
    // 강제 새로고침
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 상태의 가능성
      // State 의 상태
      // 1. CursorPagination = 정상적으로 데이터가 있음
      // 2. CursorPaginationLoading = 데이터가 로딩중 (데이터 없음)
      // 3. CursorPaginationError = 에러 발생
      // 4. CursorPaginationRefetching = 첫 페이지부터 다시 데이터를 가져옴
      // 5. CursorPaginationFetchMore = 추가 데이터를 paginate 해올 때

      //* 복잡한 로직을 작성할 때, 바로 반환되는 경우부터 작성. 기저사례 탈출부터
      // 바로 반환하는 상황
      // 1. CursorPaginationMeat 의 `hasMore` 가 false 일 때.
      // 2. `fetchMore` = true 일 때 (추가적 데이터를 가져올 때, 중복 데이터 호출을 방지하기 위해 바로 반환)
      // 단, 새로고침의 의도가 있다면 요청 보냄

      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        // 더 가져올 데이터가 없다면
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // param 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchmore
      // 데이터를 추가로 더 가져올 때
      if (fetchMore) {
        final pState = state as CursorPagination;

        // FetchingMore 상태로 변환
        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams.copyWith(after: pState.data.last.id);
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약 데이터가 존재한다면, 기존 데이터 보존한채로 API 호출
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state =
              CursorPaginationRefetching(meta: pState.meta, data: pState.data);
        }
        // 강력 새로고침 시 로딩
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터 이어붙이기
        state = resp.copyWith(data: [
          ...pState.data,
          ...resp.data,
        ]);
      }
      // FetchingMore 가 아닌, Refetching 이나 로딩이라면?
      else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: "데이터 패치 에러");
    }
  }

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
