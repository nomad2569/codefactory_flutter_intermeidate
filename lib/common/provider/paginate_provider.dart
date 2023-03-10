import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/model/model_with_id.dart';
import 'package:codefactory_intermediate/common/repository/base_pagination_repository.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/pagination_params.dart';

class _PagintaionInfo {
  final int fetchCount;
  // 추가로 가져올 데이터가 있는지
  // true: 추가로 데이터 가져오기
  // false: 새로고침
  final bool fetchMore;
  // 강제 새로고침
  final bool forceRefetch;

  _PagintaionInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

// dart 에서는 generic 에는 implements 가 불가능하다. interface 라도, extends 하면 됨. 의도된 것
// * T: 통신받을 데이터
// * U: 각 route 별 Repository
class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final pagintaionThrottle = Throttle(
    const Duration(seconds: 1),
    initialValue: _PagintaionInfo(),
    checkEquality: false,
  );

  PaginationProvider({
    required this.repository,
  }) :
        //* instance 생성 시, 초기 상태를 `CursorPaginationLoading` 으로 설정
        //* paginate 함수 실행 (데이터 초기 패칭)
        super(CursorPaginationLoading()) {
    // 생성 하자마자 pagintae 첫 실행
    paginate();

    // throttle listen 추가
    pagintaionThrottle.values.listen((state) {
      _throttlePaginate(state);
    });
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
    // paginate 요청이 들어오면 _throttlePaginate 실행하기 위해
    // 현재 throttle 의 value 를 들어온 parmas 들로 넣어줌
    pagintaionThrottle.setValue(_PagintaionInfo(
      fetchCount: fetchCount,
      fetchMore: fetchMore,
      forceRefetch: forceRefetch,
    ));
  }

  _throttlePaginate(_PagintaionInfo info) async {
    final int fetchCount = info.fetchCount;
    // 추가로 가져올 데이터가 있는지
    // true: 추가로 데이터 가져오기
    // false: 새로고침
    final bool fetchMore = info.fetchMore;
    // 강제 새로고침
    final bool forceRefetch = info.forceRefetch;
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

      // * fetchmore
      // 데이터를 추가로 더 가져올 때
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        // FetchingMore 상태로 변환
        state = CursorPaginationFetchingMore<T>(
            meta: pState.meta, data: pState.data);

        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약 데이터가 존재한다면, 기존 데이터 보존한채로 API 호출
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          state = CursorPaginationRefetching<T>(
              meta: pState.meta, data: pState.data);
        }
        // 강력 새로고침 시 로딩
        else {
          state = CursorPaginationLoading();
        }
      }
      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

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
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: "데이터 패치 에러");
    }
  }
}
