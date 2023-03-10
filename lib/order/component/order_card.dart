import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/order/model/order_model.dart';
import 'package:codefactory_intermediate/product/component/product_card.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_intermediate/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final String? heroKey;
  const OrderCard({
    super.key,
    required this.order,
    this.heroKey,
  });

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final datetime =
        "${order.createdAt.year}.${order.createdAt.month.toString().padLeft(2, '0')}.${order.createdAt.day.toString().padLeft(2, '0')} ${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}";

    final productNames = order.products.length > 1
        ? "${order.products[0].product.name} 외${order.products.length - 1}개"
        : order.products[0].product.name;
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => _renderOrderDetailModal(context, order));
        },
        child: Row(
          children: [
            Hero(
              tag: ObjectKey(heroKey),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(order.restaurant.thumbUrl,
                    width: 60, height: 60, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    datetime,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    order.restaurant.name,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(productNames),
                ],
              ),
            ),
            Divider(
              height: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderOrderDetailModal(BuildContext context, OrderModel order) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.goNamed(
                    RestaurantDetailScreen.routeName,
                    params: {
                      "rid": order.restaurant.id,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                child: Text("재주문하기")),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final orderProduct = order.products[index];
              final productTotalPrice =
                  orderProduct.count * orderProduct.product.price;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ProductCard(
                      product: ProductModel(
                        id: orderProduct.product.id,
                        restaurant: order.restaurant,
                        name: orderProduct.product.name,
                        detail: orderProduct.product.detail,
                        imgUrl: orderProduct.product.imgUrl,
                        price: orderProduct.product.price,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("x ${orderProduct.count.toString()}"),
                        Text(" | ${productTotalPrice} 원"),
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (_, index) => SizedBox(
              height: 16,
            ),
            itemCount: order.products.length,
          ),
        ),
      ],
    );
  }
}
