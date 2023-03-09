import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/product/component/product_card.dart';
import 'package:codefactory_intermediate/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return DefaultLayout(
      title: "장바구니",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  final product = basket[index].product;
                  return ProductCard(product: product);
                },
                itemCount: basket.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
