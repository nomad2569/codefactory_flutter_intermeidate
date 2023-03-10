import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/model/model_with_id.dart';
import 'package:codefactory_intermediate/common/provider/paginate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/pagination_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;

  final PaginationWidgetBuilder itemBuilder;
  const PaginationListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  void scrollListener() {
    PaginationUtils.paginate(
      scrollController: scrollController,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // state 가 로딩중이라면 (첫 로딩)
    if (state is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
              onPressed: () async {
                await ref.read(widget.provider.notifier).paginate(
                      forceRefetch: true,
                    );
              },
              child: Text("새로고침"))
        ],
      );
    }

    // 나머지 패치 성공, 로딩 중인 경우 캐스팅
    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(widget.provider.notifier).paginate(forceRefetch: true);
        },
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          // * 스크롤 컨트롤러
          controller: scrollController,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Center(
                child: cp is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text("마지막 데이터!"),
              );
            }

            final item = cp.data[index];
            return widget.itemBuilder(_, index, item);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 16,
            );
          },
        ),
      ),
    );
  }
}
