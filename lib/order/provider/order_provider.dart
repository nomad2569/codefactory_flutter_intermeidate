import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/provider/paginate_provider.dart';
import 'package:codefactory_intermediate/order/model/order_model.dart';
import 'package:codefactory_intermediate/order/model/post_order_body.dart';
import 'package:codefactory_intermediate/order/repository/order_repository.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_intermediate/user/model/basket_item_model.dart';
import 'package:codefactory_intermediate/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(ref: ref, repository: repo);
});

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;
  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrders() async {
    const uuid = Uuid();
    final basketState = ref.read(basketProvider);
    final json = {
      "id": uuid.v4().toString(),
      "products": basketState
          .map(
            (e) =>
                ProductIdWithCountModel(productId: e.product.id, count: e.count)
                    .toJson(),
          )
          .toList(),
      "totalPrice": basketState.fold<int>(
          0, (acc, cur) => acc + (cur.product.price * cur.count)),
      "createdAt": DateTime.now().toString(),
    };

    // if (state is CursorPagination){
    //   final pState = state as CursorPagination;
    //   state = pState.copyWith(
    //     data: [...pState.data, ...(basketState.map((e) => OrderModel.fromJson(json),))]
    //   )
    // }

    try {
      final resp = await repository.postOrder(
        body: PostOrderBody.fromJson(json),
      );
    } catch (e, stack) {
      print(e);
      return false;
    }

    return true;
  }
}
