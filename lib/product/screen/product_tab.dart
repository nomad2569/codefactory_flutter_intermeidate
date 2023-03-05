import 'package:codefactory_intermediate/common/component/pagination_list_view.dart';
import 'package:codefactory_intermediate/product/component/product_card.dart';
import 'package:codefactory_intermediate/product/provider/product_provider.dart';
import 'package:codefactory_intermediate/restaurant/view/restaurant_detail_screen.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductTab extends ConsumerWidget {
  const ProductTab({super.key});

  @override
  void initState() {
    initState();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView(
      provider: productProvider,
      itemBuilder: <ProductModel>(context, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(id: model.restaurant.id),
              ),
            );
          },
          child: ProductCard(
            product: model,
          ),
        );
      },
    );
  }
}
