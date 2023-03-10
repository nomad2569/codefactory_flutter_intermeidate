import 'package:codefactory_intermediate/common/component/pagination_list_view.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/order/component/order_card.dart';
import 'package:codefactory_intermediate/order/model/order_model.dart';
import 'package:codefactory_intermediate/order/provider/order_provider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  static String get routeName => 'orderDone';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: PaginationListView<OrderModel>(
        provider: orderProvider,
        itemBuilder: <OrderModel>(_, index, item) => OrderCard(order: item),
      ),
    );
  }
}
