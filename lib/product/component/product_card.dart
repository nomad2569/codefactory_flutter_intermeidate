import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_intermediate/user/provider/basket_provider.dart';
import 'package:codefactory_intermediate/user/view/basket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basketState = ref.watch(basketProvider);
    // IntrinsicHeight Row 안에 있는 모든 위젯들의 높이가 최대 높이가 됨
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imgUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // children 서로 간의 간격 일정하게 하기
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      product.detail,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: BODY_TEXT_COLOR,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                    Text("\$${product.price}",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (GoRouter.of(context)
                .location
                .toString()
                .contains(BasketScreen.routeName) &&
            basketState.firstWhereOrNull(
                    (element) => element.product.id == product.id) !=
                null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: _Footer(
                total: (basketState
                            .firstWhere(
                                (element) => element.product.id == product.id)
                            .count *
                        basketState
                            .firstWhere(
                                (element) => element.product.id == product.id)
                            .product
                            .price)
                    .toString(),
                count: basketState
                    .firstWhere((element) => element.product.id == product.id)
                    .count,
                onSubtract: () => ref
                    .read(basketProvider.notifier)
                    .removeFromBasket(product: product),
                onAdd: () => ref
                    .read(basketProvider.notifier)
                    .addToBasket(product: product)),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    super.key,
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 \$$total',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            renderButton(icon: Icons.remove, onTap: onSubtract),
            SizedBox(
              width: 8.0,
            ),
            Text(
              count.toString(),
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            renderButton(icon: Icons.add, onTap: onAdd),
          ],
        ),
      ],
    );
  }

  Widget renderButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          )),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
