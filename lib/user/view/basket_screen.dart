import 'dart:developer';

import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/common/view/root_tab.dart';
import 'package:codefactory_intermediate/order/provider/order_provider.dart';
import 'package:codefactory_intermediate/order/view/order_screen.dart';
import 'package:codefactory_intermediate/product/component/product_card.dart';
import 'package:codefactory_intermediate/user/provider/basket_provider.dart';
import 'package:codefactory_intermediate/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    final stringNumFormat = NumberFormat("###,###,###");

    final totalBasketPrice =
        basket.fold<int>(0, (acc, cur) => acc + cur.product.price * cur.count);

    final totalDelivFee = basket.fold<int>(
        0, (acc, cur) => acc + cur.product.restaurant.deliveryFee);

    final totalPrice = totalBasketPrice + totalDelivFee;

    return DefaultLayout(
      title: "장바구니",
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                    height: 32,
                    color: Colors.grey,
                  ),
                  itemBuilder: (_, index) {
                    final product = basket[index].product;
                    return ProductCard(product: product);
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "장바구니 금액",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        stringNumFormat.format(totalBasketPrice),
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "배달비",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        stringNumFormat.format(totalDelivFee),
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "총액",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        stringNumFormat.format(totalPrice),
                        style: TextStyle(
                            color: PRIMARY_COLOR, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    // `ElevatedButton` 길이 최대
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp =
                            await ref.read(orderProvider.notifier).postOrders();

                        // 결제 호출이 실패했다면
                        if (resp) {
                          context.go('/error');
                        }
                        context.goNamed(RootTab.routeName);
                      },
                      // `ElevatedButton` 스타일 설정
                      style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR,
                      ),
                      child: Text(
                        "결제하기",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
